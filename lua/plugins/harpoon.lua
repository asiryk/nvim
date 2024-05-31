local present = pcall(require, "harpoon")

if not present then return end

local bind = require("plenary.fun").bind
local utils = require("custom").utils
local harpoon_mark = require("harpoon.mark")
local harpoon_ui = require("harpoon.ui")

local function set_keymap(lhs, rhs) vim.keymap.set("n", lhs, rhs, { silent = true }) end

set_keymap("<Leader>ha", harpoon_mark.add_file)
set_keymap("<Leader>ho", function ()
  harpoon_ui.toggle_quick_menu()
  vim.wo.winblend = 20
end)
set_keymap("<C-J>", utils.center_move(bind(harpoon_ui.nav_file, 1)))
set_keymap("<C-K>", utils.center_move(bind(harpoon_ui.nav_file, 2)))
set_keymap("<C-L>", utils.center_move(bind(harpoon_ui.nav_file, 3)))
set_keymap("<C-:>", utils.center_move(bind(harpoon_ui.nav_file, 4)))

table.insert(G.plugin_hl, function(color)
  -- Make Harpoon transparent
  vim.api.nvim_set_hl(0, "HarpoonBorder", { bg = nil, fg = color.fg })
  vim.api.nvim_set_hl(0, "HarpoonWindow", { bg = nil, fg = color.fg })
end)
