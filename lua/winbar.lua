-- Per-window bar above the buffer showing the current file name.

-- Diffview paints its own per-side winbar ("WORKING TREE - path", "<hash>:path")
-- when winbar_info is enabled. Leave those windows untouched so we neither
-- clobber the base side's winbar with "" nor override the working-tree side
-- with our plain path — diffview owns the winbar consistently on both sides.
local function in_diffview_diff_win()
  local lib = package.loaded["diffview.lib"]
  if not lib then return false end
  local ok, view = pcall(lib.get_current_view)
  if not ok or not view or not view.cur_layout then return false end
  local win = vim.api.nvim_get_current_win()
  for _, w in ipairs(view.cur_layout.windows or {}) do
    if w.id == win then return true end
  end
  return false
end

local function should_skip(buf)
  if in_diffview_diff_win() then return "diffview" end
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
  local skip = should_skip(buf)
  if skip == "diffview" then
    -- Diffview owns this window's winbar; don't touch it.
  elseif skip then
    vim.wo.winbar = ""
  else
    vim.wo.winbar = "%{%v:lua.Winbar_render()%}"
  end
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "WinEnter", "FileType" }, {
  callback = apply,
})
