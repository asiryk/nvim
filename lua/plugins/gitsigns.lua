local gs = require("gitsigns")
local icons = require("icons").ui

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
  preview_config = {
    border = vim.o.winborder,
  },
}
require("theme").add_highlights(function()
  return "gitsigns",
    {
      ---@param c VaguePalette
      vague = function(c)
        return {
          GitSignsAdd = { link = "GitSignsAdd", bg = "none", fg = c.plus },
          GitSignsAddLn = { link = "GitSignsAddLn" },
          GitSignsAddNr = { link = "GitSignsAddNr" },

          GitSignsChange = { link = "GitSignsChange", bg = "none", fg = c.delta },
          GitSignsChangeLn = { link = "GitSignsChangeLn" },
          GitSignsChangeNr = { link = "GitSignsChangeNr" },

          GitSignsChangedelete = { link = "GitSignsChange" },
          GitSignsChangedeleteLn = { link = "GitSignsChangeLn" },
          GitSignsChangedeleteNr = { link = "GitSignsChangeNr" },

          GitSignsDelete = { link = "GitSignsDelete", bg = "none", fg = c.error },
          GitSignsDeleteLn = { link = "GitSignsDeleteLn" },
          GitSignsDeleteNr = { link = "GitSignsDeleteNr" },

          GitSignsTopdelete = { link = "GitSignsDelete" },
          GitSignsTopdeleteLn = { link = "GitSignsDeleteLn" },
          GitSignsTopdeleteNr = { link = "GitSignsDeleteNr" },
        }
      end,
      ---@param c OneDarkPalette
      onedark = function(c)
        return {
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
      end,
    }
end)

gs.setup(options)

local function nav_hunk(direction)
  return function() gs.nav_hunk(direction, {
    navigation_message = false,
  }, function()
      vim.cmd("norm! zz")
    end)
  end
end

vim.keymap.set("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk [Gitsigns]" })
vim.keymap.set("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer [Gitsigns]" })
vim.keymap.set("n", "<leader>gk", nav_hunk("prev"), { desc = "Go to previous hunk [Gitsigns]" })
vim.keymap.set("n", "<leader>gj", nav_hunk("next"), { desc = "Go to next hunk [Gitsigns" })
vim.keymap.set("n", "<leader>ga", gs.stage_hunk, { desc = "Stage hunk [Gitsigns" })
vim.keymap.set("n", "<leader>gb", function()
  if (PopUpMenu) then
    PopUpMenu.toggle_git_blame()
  end
end, { desc = "Stage hunk [Gitsigns" })
