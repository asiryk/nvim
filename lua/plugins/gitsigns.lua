local gs = require("gitsigns")
local icons = require("colorscheme.icons").ui
local utils = require("custom").utils

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

local function nav_hunk(direction)
  return utils.center_move(function()
    gs.nav_hunk(direction, { navigation_message = false })
  end)
end

vim.keymap.set("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk [Gitsigns]" })
vim.keymap.set("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer [Gitsigns]" })
vim.keymap.set("n", "<leader>gk", nav_hunk("prev"), { desc = "Go to previous hunk [Gitsigns]" })
vim.keymap.set("n", "<leader>gj", nav_hunk("next"), { desc = "Go to next hunk [Gitsigns" })
