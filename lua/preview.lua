-- :Preview — open the current markdown buffer in macOS Quick Look.

-- Quick Look is macOS-only, so the command isn't defined elsewhere.
if vim.fn.has("mac") == 0 then return end

local function quicklook_path(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  local modified = vim.bo[buf].modified

  if name ~= "" and not modified and vim.fn.filereadable(name) == 1 then
    return name
  end

  -- Unsaved or nameless buffer: Quick Look reads from disk, so dump a copy.
  -- tempname() lives in nvim's temp dir, wiped on exit.
  local path = vim.fn.tempname() .. ".md"
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  vim.fn.writefile(lines, path)
  return path
end

local function preview()
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].filetype ~= "markdown" then
    vim.notify("Preview only works in markdown buffers", vim.log.levels.WARN)
    return
  end

  local path = quicklook_path(buf)

  -- Detached so the panel outlives the call and nvim isn't blocked; qlmanage
  -- is chatty on stderr even when it succeeds, so output is discarded.
  vim.system({ "qlmanage", "-p", path }, { detach = true, stdout = false, stderr = false })
end

vim.api.nvim_create_user_command("Preview", preview, {
  desc = "Preview markdown file in macOS Quick Look [User]",
})
