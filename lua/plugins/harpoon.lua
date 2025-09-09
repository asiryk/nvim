local harpoon = require("harpoon")
local utils = require("custom").utils

harpoon:setup({
  settings = {
    save_on_toggle = true,
    save_on_change = true,
  },
})

local function set_keymap(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
end

local function select_file(id)
  return utils.center_move(function() harpoon:list():select(id) end)
end

set_keymap("<Leader>ha", function() harpoon:list():add() end, "Add file [Harpoon]")
set_keymap("<Leader>ho", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
  local win = vim.api.nvim_get_current_win()
  vim.wo[win].winblend = vim.o.pumblend
  ---@diagnostic disable-next-line
  vim.api.nvim_win_set_config(win, { border = vim.o.winborder })
end, "Open menu [Harpoon]")
set_keymap("<C-h>", select_file(1), "File 1 [Harpoon]")
set_keymap("<C-j>", select_file(2), "File 2 [Harpoon]")
set_keymap("<C-k>", select_file(3), "File 3 [Harpoon]")
set_keymap("<C-l>", select_file(4), "File 4 [Harpoon]")

require("theme").add_highlights(function(c)
  local highlights = {
    HarpoonBorder = { fg = c.cyan },
    HarpoonWindow = { fg = c.fg },
  }

  return "harpoon", highlights
end)
