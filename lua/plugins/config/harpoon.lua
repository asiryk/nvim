local present = pcall(require, "harpoon")

if not present then return end

local bind = require("plenary.fun").bind
local utils = require("core.utils")
local harpoon_mark = require("harpoon.mark")
local harpoon_ui = require("harpoon.ui")

local alt = { -- When I press alt<key> on macos
  ["n"] = "˜",
  ["m"] = "µ",
  ["j"] = "∆",
  ["k"] = "˚",
  ["l"] = "¬",
  [";"] = "…",
}

vim.keymap.set("n", alt["n"], harpoon_mark.add_file)
vim.keymap.set("n", alt["m"], harpoon_ui.toggle_quick_menu)
vim.keymap.set("n", alt["j"], utils.center_move(bind(harpoon_ui.nav_file, 1)))
vim.keymap.set("n", alt["k"], utils.center_move(bind(harpoon_ui.nav_file, 2)))
vim.keymap.set("n", alt["l"], utils.center_move(bind(harpoon_ui.nav_file, 3)))
vim.keymap.set("n", alt[";"], utils.center_move(bind(harpoon_ui.nav_file, 4)))
