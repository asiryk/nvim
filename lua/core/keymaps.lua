local set = vim.keymap.set

set("n", "<bs>", "<nop>")                 -- Unmap Backspace
set("n", "<space>", "<nop>")              -- Unmap Space
vim.g.mapleader = " "                     -- Set Leader key

set("n", "tn", "<cmd>tabnew<CR>")         -- Create new tab
set("n", "<C-L>", "<cmd>tabnext<CR>")     -- Switch to right tab
set("n", "<C-H>", "<cmd>tabprev<CR>")     -- Switch to left tab
set("n", "tc", "<cmd>tabclose<CR>")       -- Close current tab
set("n", "tac", "<cmd>tabo<CR>")          -- Close all tabs

-- LSP, :help vim.lsp.*
local buf = vim.lsp.buf
set("n", "gd", buf.definition)
set("n", "<S-K>", buf.hover)
set("n", "<Leader>lf", buf.formatting)
set("n", "<Leader>lr", buf.rename)
set("n", "<Leader>la", buf.code_action)
