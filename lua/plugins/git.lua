-- Shared orchestration for git plugins (fugitive, gitsigns, diffview).
--
-- Each plugin's own setup() stays in its shim / plugin_spec entry, but
-- cross-plugin wiring, <leader>g* keymaps, and buffer-level helpers live
-- here so there's one place to audit git UX and no copy-pasted keymaps.
--
-- setup_shared() is idempotent: whichever plugin loads first triggers it;
-- subsequent calls no-op.

local F = {}
local S = { shared_loaded = false }

-- ──────────────────────── Commit-under-cursor helpers ────────────────────────

function F.open_commit_diff_under_cursor()
  pcall(function()
    local line = vim.api.nvim_get_current_line()
    local hash = line:match("([0-9a-f]+)")
    if hash then vim.cmd("DiffviewOpen " .. hash .. "^!") end
  end)
end

function F.goto_commit_tab()
  local line = vim.api.nvim_get_current_line()
  local hash = line:match("([0-9a-f]+)")
  if hash then vim.cmd("Gtabedit " .. hash) end
end

--- Shared keymap block for git, git-graph, and gitsigns-blame buffers.
---@param buf integer
---@param opts? { close_fn?: fun() }
function F.setup_commit_buffer_keymaps(buf, opts)
  opts = opts or {}
  local set = vim.keymap.set
  set("n", "K", F.open_commit_diff_under_cursor,
    { buffer = buf, desc = "Diffview on commit under cursor [Git]" })
  set("", "<2-LeftMouse>", F.open_commit_diff_under_cursor,
    { buffer = buf, desc = "Diffview on commit under cursor [Git]" })
  set("n", "<CR>", F.goto_commit_tab,
    { buffer = buf, silent = true, desc = "Open commit in tab [Git]" })
  set("n", "q", opts.close_fn or "<cmd>q<cr>",
    { buffer = buf, silent = true })
end

-- ──────────────────────────── Fugitive helpers ───────────────────────────────

--- Returns a URL to create a new PR/MR for the current branch.
--- Supports GitHub and GitLab remotes (both SSH and HTTPS formats).
function F.get_pr_url()
  local remote = vim.fn.system("git remote get-url origin"):gsub("%s+$", "")
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to get remote origin", vim.log.levels.ERROR)
    return nil
  end

  local branch = vim.fn.system("git branch --show-current"):gsub("%s+$", "")
  if vim.v.shell_error ~= 0 or branch == "" then
    vim.notify("Failed to get current branch", vim.log.levels.ERROR)
    return nil
  end

  -- Normalize SSH URLs to HTTPS format
  -- git@github.com:user/repo.git -> github.com/user/repo
  local host, path
  if remote:match("^git@") then
    host, path = remote:match("^git@([^:]+):(.+)$")
  else
    host, path = remote:match("^https?://([^/]+)/(.+)$")
  end

  if not host or not path then
    vim.notify("Could not parse remote URL: " .. remote, vim.log.levels.ERROR)
    return nil
  end

  path = path:gsub("%.git$", "")

  local url
  if host:match("github") then
    url = ("https://%s/%s/pull/new/%s"):format(host, path, branch)
  elseif host:match("gitlab") then
    local encoded_branch = vim.uri_encode(branch)
    url = ("https://%s/%s/-/merge_requests/new?merge_request%%5Bsource_branch%%5D=%s"):format(
      host,
      path,
      encoded_branch
    )
  else
    vim.notify("Unknown git host: " .. host, vim.log.levels.WARN)
    return nil
  end

  return url
end

-- Passes a list to systemlist() so git is exec'd directly without a shell.
-- Going through fish would fire fnm's use-on-cd hook in projects with a
-- .node-version/.nvmrc and pollute the buffer with "Using Node vX.Y.Z".
local function git_log_base()
  return {
    "git", "log", "--graph",
    "--pretty=format:%h%d %s <%ad | %an>",
    "--abbrev-commit", "--date=local",
  }
end

local function append_user_args(cmd, args)
  if not args or args == "" then return end
  for arg in args:gmatch("%S+") do
    table.insert(cmd, arg)
  end
end

function F.run_git_log(args)
  local cmd = git_log_base()
  vim.list_extend(cmd, {
    "--invert-grep",
    "--grep=Auto version update",
    "--grep=Auto update assets",
    "--grep=Merge branch",
    "--grep=Merge remote-tracking branch",
  })
  append_user_args(cmd, args)

  local output = vim.fn.systemlist(cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify("Git command failed", vim.log.levels.ERROR)
    return nil
  end

  return output
end

function F.run_git_log_full(args)
  local cmd = git_log_base()
  append_user_args(cmd, args)

  local output = vim.fn.systemlist(cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify("Git command failed", vim.log.levels.ERROR)
    return nil
  end

  return output
end

function F.create_git_graph_buf(content, bufname)
  local existing = vim.fn.bufnr(bufname)
  if existing ~= -1 then
    local win = vim.fn.bufwinid(existing)
    if win ~= -1 then
      vim.api.nvim_set_current_win(win)
      return
    end
  end

  local bufnr = vim.api.nvim_create_buf(false, true)

  vim.bo[bufnr].buftype = "nofile"
  vim.bo[bufnr].bufhidden = "wipe"
  vim.bo[bufnr].swapfile = false
  vim.bo[bufnr].filetype = "git-graph"

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, content)
  vim.bo[bufnr].modifiable = false

  vim.cmd.split()
  vim.api.nvim_set_current_buf(bufnr)

  vim.api.nvim_buf_set_name(bufnr, bufname)

  vim.opt_local.listchars = { trail = " ", tab = "  ", nbsp = "␣" }
end

-- ──────────────────────────── Diffview helpers ───────────────────────────────

function F.is_diffview_open()
  local view = require("diffview.lib").get_current_view()
  return view ~= nil
end

function F.toggle_diffview()
  if F.is_diffview_open() then
    vim.cmd("DiffviewClose")
  else
    vim.cmd("DiffviewOpen")
  end
end

function F.current_file_history_with_author()
  local M = {}
  M.co = coroutine.create(function(authors)
    vim.ui.select(authors, {
      prompt = "Select Git Author:",
    }, function(selected) coroutine.resume(M.co, selected) end)
    local selected = coroutine.yield()

    vim.cmd(
      "DiffviewFileHistory % --no-merges" .. string.format(" --author='%s'", selected)
    )
  end)

  vim.system(
    { "sh", "-c", "git log --format='%aN' | sort -u" },
    { text = true },
    function(result)
      if result.code ~= 0 then error("Failed to get authors") end

      local authors = {}
      for author in result.stdout:gmatch("[^\r\n]+") do
        table.insert(authors, author)
      end

      coroutine.resume(M.co, authors)
    end
  )
end

function F.current_file_history_selected_lines(opts)
  local file = vim.fn.expand("%")
  local start_line = opts.line1
  local end_line = opts.line2

  local cmd = string.format("DiffviewFileHistory -L%d,%d:%s", start_line, end_line, file)
  vim.cmd(cmd)
end

-- ──────────────────────────── Orchestration ──────────────────────────────────

function F.setup_shared()
  if S.shared_loaded then return end
  S.shared_loaded = true

  local set = vim.keymap.set

  -- <leader>g* keymaps (central audit point)
  set("n", "<leader>gC", "Git commit --amend --no-edit",
    { desc = "Commit with amend [Fugitive]" })
  set("n", "<leader>gP", function()
    local url = F.get_pr_url()
    if url then
      -- make that multiline, so it opens :mes history
      vim.print("\n" .. url)
    end
  end, { desc = "Print PR URL (GitHub, GitLab) [Fugitive]" })
  set("n", "<leader>gd", F.toggle_diffview,
    { desc = "Toggle Git Diff [Diffview]" })

  -- User commands
  vim.api.nvim_create_user_command("Gitl", function(opts)
    local output = F.run_git_log(opts.args)
    if output == nil then return end
    local bufname = "git-graph://" .. vim.fn.getcwd() .. " Gitl"
    F.create_git_graph_buf(output, bufname)
  end, { desc = "Git log graph excluding generated commits [User]", nargs = "*" })

  vim.api.nvim_create_user_command("Gitlo", function(opts)
    local output = F.run_git_log_full(opts.args)
    if output == nil then return end
    local bufname = "git-graph://" .. vim.fn.getcwd() .. " Gitlo"
    F.create_git_graph_buf(output, bufname)
  end, { desc = "Git log graph [User]", nargs = "*" })

  vim.api.nvim_create_user_command("DiffPreset", function(opts)
    vim.ui.select({
      "Current file: filter by author",
      "Current file: selected lines",
    }, { prompt = "Select preset:" }, function(selected)
      if selected == "Current file: filter by author" then
        F.current_file_history_with_author()
      elseif selected == "Current file: selected lines" then
        F.current_file_history_selected_lines(opts)
      end
    end)
  end, {
    range = true,
    desc = "Select one of multiple preset diff configurations [User]",
  })

  vim.api.nvim_create_user_command(
    "DiffLines",
    function(opts) F.current_file_history_selected_lines(opts) end,
    {
      range = true,
      desc = "Show file history for selected lines [User]",
    }
  )

  -- Buffer-level keymaps for git UI buffers
  local buf_group = vim.api.nvim_create_augroup("git_shared_buffers", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = buf_group,
    pattern = { "git", "git-graph" },
    callback = function(args) F.setup_commit_buffer_keymaps(args.buf) end,
  })

  -- Post-Diffview-close cleanup: refresh gitsigns, reset UFO fold state
  local dv_group = vim.api.nvim_create_augroup("git_shared_diffview", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = dv_group,
    pattern = "DiffviewViewClosed",
    callback = function()
      -- Wait 100ms since gitsigns may still be updating
      vim.defer_fn(function() pcall(require("gitsigns").refresh) end, 100)

      -- Diffview leaves windows with foldmethod=diff / foldenable=false,
      -- which makes UFO's applyFoldRanges silently bail out.
      -- Reset fold state and re-enable UFO for all affected windows.
      vim.schedule(function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].buflisted then
            vim.wo[win].foldmethod = "manual"
            vim.wo[win].foldenable = true
            vim.api.nvim_win_call(win, function() vim.cmd("silent! %foldopen!") end)
            require("ufo").disableFold(buf)
          end
        end
      end)
    end,
  })

end

return F
