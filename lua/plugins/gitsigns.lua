local gs = require("gitsigns")
local icons = require("colorscheme.icons").ui
local utils = require("custom").utils

local options = {
  signs = {
    add = { text = icons.block },
    change = { text = icons.block },
    delete = { text = icons.dash },
    topdelete = { text = icons.dash },
    changedelete = { text = icons.block },
  },
  signs_staged = {
    add = { text = icons.block_thin },
    change = { text = icons.block_thin },
    delete = { text = icons.dash },
    topdelete = { text = icons.dash },
    changedelete = { text = icons.block_thin },
  },
}

table.insert(G.plugin_hl, function(c)
  vim.api.nvim_set_hl(0, "GitSignsAdd", { link = "GitSignsAdd", bg = "none", fg = c.green })
  vim.api.nvim_set_hl(0, "GitSignsAddLn", { link = "GitSignsAddLn" })
  vim.api.nvim_set_hl(0, "GitSignsAddNr", { link = "GitSignsAddNr" })

  vim.api.nvim_set_hl(0, "GitSignsChange", { link = "GitSignsChange", bg = "none", fg = c.cyan })
  vim.api.nvim_set_hl(0, "GitSignsChangeLn", { link = "GitSignsChangeLn" })
  vim.api.nvim_set_hl(0, "GitSignsChangeNr", { link = "GitSignsChangeNr" })

  vim.api.nvim_set_hl(0, "GitSignsChangedelete", { link = "GitSignsChange" })
  vim.api.nvim_set_hl(0, "GitSignsChangedeleteLn", { link = "GitSignsChangeLn" })
  vim.api.nvim_set_hl(0, "GitSignsChangedeleteNr", { link = "GitSignsChangeNr" })

  vim.api.nvim_set_hl(0, "GitSignsDelete", { link = "GitSignsDelete", bg = "none", fg = c.red })
  vim.api.nvim_set_hl(0, "GitSignsDeleteLn", { link = "GitSignsDeleteLn" })
  vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { link = "GitSignsDeleteNr" })

  vim.api.nvim_set_hl(0, "GitSignsTopdelete", { link = "GitSignsDelete" })
  vim.api.nvim_set_hl(0, "GitSignsTopdeleteLn", { link = "GitSignsDeleteLn" })
  vim.api.nvim_set_hl(0, "GitSignsTopdeleteNr", { link = "GitSignsDeleteNr" })

  -- vim.cmd([[highlight WinSeparator guibg=None]]) -- Remove borders for window separators
  -- vim.cmd([[highlight SignColumn guibg=None]]) -- Remove background from signs column
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
vim.keymap.set("n", "<leader>ga", gs.stage_hunk, { desc = "Stage hunk [Gitsigns" })
