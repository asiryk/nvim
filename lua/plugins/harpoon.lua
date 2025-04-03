local present = pcall(require, "harpoon")

if not present then return end

local bind = require("plenary.fun").bind
local utils = require("custom").utils
local harpoon_mark = require("harpoon.mark")
local harpoon_ui = require("harpoon.ui")

local function set_keymap(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
end

set_keymap("<Leader>ha", harpoon_mark.add_file, "Add file [Harpoon]")
set_keymap("<Leader>ho", function()
  harpoon_ui.toggle_quick_menu()
  vim.wo.winblend = vim.o.pumblend
end, "Open menu [Harpoon]")
set_keymap("<C-h>", utils.center_move(bind(harpoon_ui.nav_file, 1)), "File 1 [Harpoon]")
set_keymap("<C-j>", utils.center_move(bind(harpoon_ui.nav_file, 2)), "File 2 [Harpoon]")
set_keymap("<C-k>", utils.center_move(bind(harpoon_ui.nav_file, 3)), "File 3 [Harpoon]")
set_keymap("<C-l>", utils.center_move(bind(harpoon_ui.nav_file, 4)), "File 4 [Harpoon]")

require("theme").add_highlights(function(c)
  local highlights = {
    HarpoonBorder = { fg = c.cyan },
    HarpoonWindow = { fg = c.fg },
  }

  return "harpoon", highlights
end)
