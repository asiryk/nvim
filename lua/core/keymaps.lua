local set = vim.keymap.set

set("n", "<bs>", "<nop>") -- Unmap Backspace
set("n", "<space>", "<nop>") -- Unmap Space
vim.g.mapleader = " " -- Set Leader key

set("n", "tn", "<cmd>tabnew<CR>") -- Create new tab
set({ "n", "i", "v" }, "<C-L>", "<cmd>tabnext<CR>") -- Switch to right tab
set({ "n", "i", "v" }, "<C-H>", "<cmd>tabprev<CR>") -- Switch to left tab
set("n", "tc", "<cmd>tabclose<CR>") -- Close current tab
set("n", "tac", "<cmd>tabo<CR>") -- Close all tabs

-- Quickfix list
set("n", "<C-c>", "<cmd>cclose<CR>")
set("n", "<C-j>", "<cmd>cnext<CR>zz")
set("n", "<C-k>", "<cmd>cprev<CR>zz")
set("n", "<leader>k", "<cmd>lnext<CR>zz")
set("n", "<leader>j", "<cmd>lprev<CR>zz")
