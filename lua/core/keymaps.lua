local set = vim.keymap.set

set("n", "<bs>", "<nop>") -- Unmap Backspace
set("n", "<space>", "<nop>") -- Unmap Space
vim.g.mapleader = " " -- Set Leader key

set("n", "tn", "<cmd>tabnew<CR>") -- Create new tab
set({ "n", "i", "v" }, "<C-L>", "<cmd>tabnext<CR>") -- Switch to right tab
set({ "n", "i", "v" }, "<C-H>", "<cmd>tabprev<CR>") -- Switch to left tab
set("n", "tc", "<cmd>tabclose<CR>") -- Close current tab
set("n", "tac", "<cmd>tabo<CR>") -- Close all tabs

-- LSP, :help vim.lsp.*
local buf = vim.lsp.buf
set("n", "gd", buf.definition)
set("n", "<S-K>", buf.hover)
set("n", "<Leader>lf", buf.formatting)
set("n", "<Leader>lr", buf.rename)
set("n", "<Leader>la", buf.code_action)
set("n", "<Leader>lcr", vim.lsp.codelens.refresh)

-- Quickfix list
set("n", "<C-j>", "<cmd>cnext<CR>zz")
set("n", "<C-k>", "<cmd>cprev<CR>zz")
set("n", "<leader>k", "<cmd>lnext<CR>zz")
set("n", "<leader>j", "<cmd>lprev<CR>zz")
