-- Rust-specific features.
--
-- Test detection is treesitter (synchronous, so the right-click menu can ask
-- it while the MenuPopup event is being handled). The command itself comes
-- from rust-analyzer's `experimental/runnables`, which knows the package,
-- target (lib / bin / integration test) and module path of the test — things
-- that are tedious and error-prone to derive by hand in a workspace.

local M = {}

-- `#[test]`, `#[tokio::test]`, `#[tokio::test(flavor = "multi_thread")]`, ...
-- rust-analyzer treats any attribute whose last path segment is `test` as a
-- test attribute, so do the same.
local function is_test_attr(attr_item, buf)
  local attr = attr_item:named_child(0)
  local path = attr and attr:named_child(0)
  if not path then return false end
  local text = vim.treesitter.get_node_text(path, buf)
  return text == "test" or text:match("::test$") ~= nil
end

local function is_test_fn(fn, buf)
  local sib = fn:prev_named_sibling()
  while sib do
    local t = sib:type()
    if t == "attribute_item" then
      if is_test_attr(sib, buf) then return true end
    elseif t ~= "line_comment" and t ~= "block_comment" then
      return false
    end
    sib = sib:prev_named_sibling()
  end
  return false
end

-- With the cursor on one of a function's attributes (or a comment between
-- them), the node under it is a sibling of the `function_item`, not its descendant.
local function fn_after_attrs(node)
  local sib = node:next_named_sibling()
  while sib do
    local t = sib:type()
    if t == "function_item" then return sib end
    if t ~= "attribute_item" and t ~= "line_comment" and t ~= "block_comment" then
      return nil
    end
    sib = sib:next_named_sibling()
  end
end

--- The test function under the cursor, as `{ name, row, col }` of its name
--- identifier (0-based), or nil when the cursor is not inside a test.
function M.test_under_cursor(buf, win)
  buf = buf or vim.api.nvim_get_current_buf()
  win = win or vim.api.nvim_get_current_win()
  if vim.bo[buf].filetype ~= "rust" then return nil end

  local parser = vim.treesitter.get_parser(buf, "rust", { error = false })
  if not parser then return nil end
  local tree = parser:parse()[1]
  if not tree then return nil end

  local cursor = vim.api.nvim_win_get_cursor(win)
  local row, col = cursor[1] - 1, cursor[2]
  local node = tree:root():named_descendant_for_range(row, col, row, col)

  -- Walk outwards so a cursor inside a closure or helper fn nested in a test
  -- still finds the enclosing test.
  while node do
    local t = node:type()
    local fn = t == "function_item" and node
      or (t == "attribute_item" or t == "line_comment" or t == "block_comment") and fn_after_attrs(node)
    if fn and is_test_fn(fn, buf) then
      local name = fn:field("name")[1]
      if not name then return nil end
      local r, c = name:start()
      return { name = vim.treesitter.get_node_text(name, buf), row = r, col = c }
    end
    node = node:parent()
  end
end

--- Whether the right-click menu should offer "Run Test".
function M.can_run_test(buf, win)
  buf = buf or vim.api.nvim_get_current_buf()
  if vim.bo[buf].filetype ~= "rust" then return false end
  if not vim.fs.root(buf, "Cargo.toml") then return false end
  return M.test_under_cursor(buf, win) ~= nil
end

-- Output goes to a terminal in a bottom split. Only one is kept: re-running
-- replaces the previous output in the same window.
local term_buf

local function run_in_term(cmd, opts)
  local src_win = vim.api.nvim_get_current_win()

  local win = term_buf and vim.api.nvim_buf_is_valid(term_buf) and vim.fn.bufwinid(term_buf) or -1
  if win == -1 then
    vim.cmd("botright 15split")
    win = vim.api.nvim_get_current_win()
  else
    vim.api.nvim_set_current_win(win)
  end

  local old = term_buf
  term_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(win, term_buf)
  -- Force-deleting also stops a test run that is still going.
  if old and vim.api.nvim_buf_is_valid(old) then vim.api.nvim_buf_delete(old, { force = true }) end

  vim.fn.jobstart(cmd, { term = true, cwd = opts.cwd, env = opts.env })
  pcall(vim.api.nvim_buf_set_name, term_buf, "cargo test: " .. opts.name)
  vim.keymap.set("n", "q", "<C-w>q", { buffer = term_buf, desc = "Close test output [User]" })

  if vim.api.nvim_win_is_valid(src_win) then vim.api.nvim_set_current_win(src_win) end
end

-- Smallest `test …` runnable whose range covers the test's name: that is the
-- test itself, not its enclosing `mod tests` or the whole package.
local function pick_runnable(runnables, test)
  local best, best_size
  for _, r in ipairs(runnables or {}) do
    local range = r.location and r.location.targetRange
    if r.label and r.label:match("^test ") and range then
      local s, e = range.start, range["end"]
      local covers = (s.line < test.row or (s.line == test.row and s.character <= test.col))
        and (e.line > test.row or (e.line == test.row and e.character >= test.col))
      local size = e.line - s.line
      if covers and (not best or size < best_size) then
        best, best_size = r, size
      end
    end
  end
  return best
end

-- rust-analyzer emits `cargo` runnables normally, and `shell` ones when
-- `runnables.test.overrideCommand` is configured.
local function runnable_cmd(r)
  -- JSON nulls (e.g. `overrideCargo`) decode to vim.NIL, which is truthy.
  local a = vim.tbl_map(function(v) return v ~= vim.NIL and v or nil end, r.args)
  if r.kind == "shell" then return vim.list_extend({ a.program }, a.args or {}), a.cwd end
  local cmd = { a.overrideCargo or "cargo" }
  vim.list_extend(cmd, a.cargoArgs or {})
  vim.list_extend(cmd, a.cargoExtraArgs or {})
  if a.executableArgs and #a.executableArgs > 0 then
    table.insert(cmd, "--")
    vim.list_extend(cmd, a.executableArgs)
  end
  return cmd, a.cwd or a.workspaceRoot, a.environment
end

-- Without rust-analyzer (not attached yet, still indexing, ...) fall back to
-- cargo's name filter. It is a substring match across every target, so it
-- can run more than the one test.
local function run_fallback(buf, test)
  vim.notify(
    "rust-analyzer has no runnable for this test; running `cargo test " .. test.name .. "`",
    vim.log.levels.WARN
  )
  run_in_term({ "cargo", "test", test.name }, { cwd = vim.fs.root(buf, "Cargo.toml"), name = test.name })
end

function M.run_test_under_cursor()
  local buf = vim.api.nvim_get_current_buf()
  local test = M.test_under_cursor(buf)
  if not test then
    vim.notify("Cursor is not on a Rust test", vim.log.levels.WARN)
    return
  end

  local client = vim.lsp.get_clients({ bufnr = buf, name = "rust_analyzer" })[1]
  if not client then return run_fallback(buf, test) end

  local params = {
    textDocument = vim.lsp.util.make_text_document_params(buf),
    position = { line = test.row, character = test.col },
  }
  -- A rust-analyzer extension, so it isn't in Neovim's list of LSP methods.
  ---@diagnostic disable-next-line: param-type-mismatch
  client:request("experimental/runnables", params, function(err, result)
    local r = not err and pick_runnable(result, test)
    if not r then return run_fallback(buf, test) end
    local cmd, cwd, env = runnable_cmd(r)
    run_in_term(cmd, { cwd = cwd, env = env, name = test.name })
  end, buf)
end

vim.api.nvim_create_user_command(
  "RustTest",
  M.run_test_under_cursor,
  { desc = "Run the Rust test under the cursor [User]" }
)

return M
