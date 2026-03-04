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

local F = {}

function F.get_blame_win()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.bo[buf].filetype
    if ft == "gitsigns-blame" then return win end
  end
  return -1
end

function F.close_git_blame()
  local win = F.get_blame_win()
  if win >= 0 then vim.api.nvim_win_close(win, true) end
end

function F.toggle_git_blame()
  local win = F.get_blame_win()
  if win >= 0 then
    F.close_git_blame()
  else
    gs.blame({}, function(err)
      if err ~= nil then return end

      vim.schedule(function()
        local bufnr = vim.api.nvim_get_current_buf()
        if vim.bo[bufnr].filetype ~= "gitsigns-blame" then return end

        local fn = function()
          pcall(
            function() require("plugins.fugitive").open_commit_diff_under_cursor() end
          )
        end


        -- TODO: need to unify the git stuff
        -- maybe merge gitsigns, fugitive, diffview configs
        -- into 1 git.lua file.
        -- Because things are getting really messy. Lines below are copy-pasted
        -- from fugitive
        vim.keymap.set("n", "<CR>", function()
          local line = vim.api.nvim_get_current_line()
          -- Extract commit hash (7 hex characters)
          local hash = line:match("([0-9a-f]+)")
          if hash then vim.cmd("Gtabedit " .. hash) end
        end, { buffer = bufnr, silent = true })

        vim.keymap.set("n", "K", fn, { buffer = bufnr })
        vim.keymap.set("n", "<2-LeftMouse>", fn, { buffer = bufnr })
        vim.keymap.set("n", "q", F.close_git_blame, { buffer = bufnr })
      end)
    end)
  end
end

return {
  get_blame_win = F.get_blame_win,
  close_git_blame = F.close_git_blame,
  toggle_git_blame = F.toggle_git_blame,
}
