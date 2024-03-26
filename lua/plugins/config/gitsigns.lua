local gs = require("gitsigns")
local icons = require("ui.icons").ui
local utils = require("core.utils")

local options = {
  signs = {
    add = {
      hl = "GitSignsAdd",
      text = icons.block,
      numhl = "GitSignsAddNr",
      linehl = "GitSignsAddLn",
    },
    change = {
      hl = "GitSignsChange",
      text = icons.block,
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
    delete = {
      hl = "GitSignsDelete",
      text = icons.triangle,
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    topdelete = {
      hl = "GitSignsDelete",
      text = icons.triangle,
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    changedelete = {
      hl = "GitSignsChange",
      text = icons.block,
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
  },
  yadm = { enable = false },
}

table.insert(G.plugin_hl, function(c)
  vim.cmd([[highlight GitSignsAdd guibg=None guifg=]] .. c.green)
  vim.cmd([[highlight GitSignsChange guibg=None guifg=]] .. c.cyan)
  vim.cmd([[highlight GitSignsDelete guibg=None guifg=]] .. c.light_grey)
  vim.cmd([[highlight WinSeparator guibg=None]]) -- Remove borders for window separators
  vim.cmd([[highlight SignColumn guibg=None]]) -- Remove background from signs column
end)

gs.setup(options)

vim.keymap.set("n", "<leader>gr", gs.reset_hunk)
vim.keymap.set("n", "<leader>gR", gs.reset_buffer)
vim.keymap.set("n", "<leader>gk", utils.center_move(gs.prev_hunk))
vim.keymap.set("n", "<leader>gj", utils.center_move(gs.next_hunk))
