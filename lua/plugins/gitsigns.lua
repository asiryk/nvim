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
vim.keymap.set({"o", "x"}, "ih", gs.select_hunk, { desc = "Select hunk text object [Gitsigns]" })
vim.keymap.set("n", "<leader>gb", function()
  if (PopUpMenu) then
    PopUpMenu.toggle_git_blame()
  end
end, { desc = "Toggle blame [Gitsigns]" })
