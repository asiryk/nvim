local present = pcall(require, "harpoon")

if not present then return end

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
vim.keymap.set("n", alt["j"], function() harpoon_ui.nav_file(1) end)
vim.keymap.set("n", alt["k"], function() harpoon_ui.nav_file(2) end)
vim.keymap.set("n", alt["l"], function() harpoon_ui.nav_file(3) end)
vim.keymap.set("n", alt[";"], function() harpoon_ui.nav_file(4) end)
