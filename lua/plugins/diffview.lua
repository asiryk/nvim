require("diffview").setup({
  file_panel = {
    listing_style = "list",
  },
})

--- check if diffview is open in current tab
local function is_diffview_open()
  local view = require("diffview.lib").get_current_view()
  return view ~= nil
end

local function toggle_diffview()
  local is_open = is_diffview_open()
  if is_open then
    vim.cmd("DiffviewClose")
  else
    vim.cmd("DiffviewOpen")
  end
end

vim.keymap.set("n", "<leader>gd", toggle_diffview, { desc = "Toggle Git Diff [Diffview]" })
