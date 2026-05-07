-- Per-window bar above the buffer showing the current file name.

local function should_skip(buf)
  if vim.bo[buf].buftype ~= "" then return true end
  local ft = vim.bo[buf].filetype
  if ft == "" or ft == "minifiles" or ft == "snacks_picker_list" then return true end
  return false
end

_G.Winbar_render = function()
  local buf = vim.api.nvim_get_current_buf()
  if should_skip(buf) then return "" end

  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then return " [No Name]" end

  local rel = vim.fn.fnamemodify(name, ":.")
  local flags = ""
  if vim.bo[buf].modified then flags = flags .. " •" end
  if vim.bo[buf].readonly or not vim.bo[buf].modifiable then flags = flags .. " " end

  return " " .. rel .. flags
end

local function apply()
  local buf = vim.api.nvim_get_current_buf()
  if should_skip(buf) then
    vim.wo.winbar = ""
  else
    vim.wo.winbar = "%{%v:lua.Winbar_render()%}"
  end
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "WinEnter", "FileType" }, {
  callback = apply,
})
