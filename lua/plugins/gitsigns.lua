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

require("theme").add_highlights(function(c)
  local highlights = {
    GitSignsAdd = { link = "GitSignsAdd", bg = "none", fg = c.green },
    GitSignsAddLn = { link = "GitSignsAddLn" },
    GitSignsAddNr = { link = "GitSignsAddNr" },

    GitSignsChange = { link = "GitSignsChange", bg = "none", fg = c.cyan },
    GitSignsChangeLn = { link = "GitSignsChangeLn" },
    GitSignsChangeNr = { link = "GitSignsChangeNr" },

    GitSignsChangedelete = { link = "GitSignsChange" },
    GitSignsChangedeleteLn = { link = "GitSignsChangeLn" },
    GitSignsChangedeleteNr = { link = "GitSignsChangeNr" },

    GitSignsDelete = { link = "GitSignsDelete", bg = "none", fg = c.red },
    GitSignsDeleteLn = { link = "GitSignsDeleteLn" },
    GitSignsDeleteNr = { link = "GitSignsDeleteNr" },

    GitSignsTopdelete = { link = "GitSignsDelete" },
    GitSignsTopdeleteLn = { link = "GitSignsDeleteLn" },
    GitSignsTopdeleteNr = { link = "GitSignsDeleteNr" },
  }

  return "gitsigns", highlights
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
