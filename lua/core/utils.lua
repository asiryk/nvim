local utils = {}

function utils.get_buf_size_in_bytes(buf)
  local line_count = vim.api.nvim_buf_line_count(buf)
  return vim.api.nvim_buf_get_offset(buf, line_count)
end

-- Wrap given function (assumes that it's move)
-- and center the screen after calling it.
-- NOTE: the function shoud be synchrounous
function utils.center_move(fn)
  return function()
    fn()
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

return utils
