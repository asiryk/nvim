local present, gitsigns = pcall(require, "gitsigns")

if not present then return end

local ic = require("ui.icons").ui

local options = {
   signs = {
      add = { hl = "GitSignsAdd", text = ic["U258E"], numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
      change = { hl = "GitSignsChange", text = ic["U258E"], numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
      delete = { hl = "GitSignsDelete", text = ic["U25B8"], numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
      topdelete = { hl = "GitSignsDelete", text = ic["U25B8"], numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
      changedelete = { hl = "GitSignsChange", text = ic["U258E"], numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
   },
   yadm = { enable = false },
}

gitsigns.setup(options)
