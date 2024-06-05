local utils = {}

G = {}
G.plugin_hl = {} -- array of functions to be applied by colorscheme
G.const = {
  default_winblend = 15,
}
G.utils = utils
G.bufnr = vim.api.nvim_get_current_buf
G.log = function(msg) vim.notify(vim.inspect(msg), vim.log.levels.DEBUG) end

function utils.get_buf_size_in_bytes(buf)
  local line_count = vim.api.nvim_buf_line_count(buf)
  return vim.api.nvim_buf_get_offset(buf, line_count)
end

-- Wrap given function (assumes that it's move)
-- and center the screen after calling it.
-- NOTE: the function shoud be synchrounous
function utils.center_move(fn)
  return function()
    if type(fn) == "function" then fn() end
    vim.cmd("norm! zz")
  end
end

function utils.remove_trailin_whitespace()
  if vim.bo.modifiable then
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd("%s/\\s\\+$//e")
    vim.api.nvim_win_set_cursor(0, cursor_pos)
  end
end

function utils.new_buf(text, open)
  if type(text) ~= "string" then return end
  local lines = {}
  for line in text:gmatch("([^\n]*)\n?") do
    table.insert(lines, line)
  end
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  if open then
    vim.api.nvim_set_current_buf(buf)
  end
  return buf
end

return {
  utils = utils,
}
