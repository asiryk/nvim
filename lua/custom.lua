local utils = {}

L = {} --- for language-specific storage
G = {}
G.plugin_hl = {} -- array of functions to be applied by colorscheme
G.const = {
  default_winblend = 15,
}
G.utils = utils

do -- create buf logger
  local function get_log_buffer()
    if G._log_bufnr and vim.api.nvim_buf_is_valid(G._log_bufnr) then
      return G._log_bufnr
    end
    local log_buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_name(log_buf, "Logger")
    G._log_bufnr = log_buf
    return log_buf
  end

  local function log(msg)
    local lines = vim.split(vim.inspect(msg), "\n", { plain = true })
    local buf = get_log_buffer()
    local line_count = vim.api.nvim_buf_line_count(buf)
    vim.api.nvim_buf_set_lines(buf, line_count, line_count, false, lines)
  end

  local function open_log()
    local buf = get_log_buffer()
    vim.cmd("vsplit")
    vim.api.nvim_win_set_buf(0, buf)
  end

  vim.api.nvim_create_user_command("OpenLog", open_log, { desc = "Open log buffer" })
  G.log = log
  G.open_log = open_log
end

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
  if open then vim.api.nvim_set_current_buf(buf) end
  return buf
end

function utils.observed_table(tbl, callback)
  local observed = {}
  local mt = {
    __index = tbl,
    __newindex = function(_, key, value)
      tbl[key] = value
      if type(callback) == "function" then callback(key, value) end
    end,
  }
  return setmetatable(observed, mt)
end

function utils.read_file(filepath)
  local file = io.open(filepath, "r")
  if not file then error("Could not open query file: " .. filepath) end
  local str = file:read("*a") -- Read entire file
  file:close()
  return str
end

local function term_split_cmd()
  local term_buf = nil
  local term_win = nil

  return function(cmd)
    -- Close the previous buffer and window if they exist
    if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
      if term_win and vim.api.nvim_win_is_valid(term_win) then
        vim.api.nvim_win_close(term_win, true)
      end
      vim.api.nvim_buf_delete(term_buf, { force = true })
    end

    local prev_win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.cmd.vsplit()
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
    local _ = vim.fn.termopen(cmd)

    vim.api.nvim_set_option_value("number", false, { scope = "local", win = win })
    vim.api.nvim_set_option_value("relativenumber", false, { scope = "local", win = win })
    vim.keymap.set("n", "q", ":bd!<CR>", { buffer = buf, silent = true })

    term_buf = buf
    term_win = win

    vim.api.nvim_set_current_win(prev_win)
  end
end

-- Example
--term_split_cmd ({ "git", "log", "--oneline", "-10" })
utils.term_split_cmd = term_split_cmd()

return {
  utils = utils,
}
