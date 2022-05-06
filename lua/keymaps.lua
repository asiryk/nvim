local options = { silent = true }

vim.keymap.set("n", "tn", "<cmd>tabnew<CR>", options)        -- Create new tab
vim.keymap.set("n", "<C-L>", "<cmd>tabnext<CR>", options)    -- Switch to right tab
vim.keymap.set("n", "<C-H>", "<cmd>tabprev<CR>", options)    -- Switch to left tab
vim.keymap.set("n", "tc", "<cmd>tabclose<CR>", options)      -- Close current tab
vim.keymap.set("n", "tac", "<cmd>tabo<CR>", options)         -- Close all tabs

vim.keymap.set("n", "<BS>", "<NOP>")              -- Unmap Backspace
vim.keymap.set("n", "<Space>", "<NOP>")           -- Unmap Space
vim.g.mapleader = " "                             -- Set Leader key
