vim.keymap.set("n", "<bs>", "<nop>", { desc = "Unmap backspace [User]" })
vim.keymap.set("n", "<space>", "<nop>", { desc = "Unmap space [User]" })
vim.g.mapleader = " " -- vim.keymap.set Leader key

-- vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "Create new tab" })
-- vim.keymap.set({ "n", "i", "v" }, "<C-L>", "<cmd>tabnext<CR>", { desc = "Switch to right tab" })
-- vim.keymap.set({ "n", "i", "v" }, "<C-H>", "<cmd>tabprev<CR>", { desc = "Switch to left tab" })
-- vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Close current tab" })
-- vim.keymap.set("n", "<leader>tac", "<cmd>tabo<CR>", { desc = "Close all tabs" })

-- Quickfix list [overridden prior to harpoon]
-- vim.keymap.set("n", "<C-c>", "<cmd>cclose<CR>")
-- vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode [User]" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Turn off hlsearch with Esc [User]" })

-- Move one or more selected lines up and down (in Visual mode)
-- TODO: don't modify undo list; TODO: probably replace with lua function
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection 1 row up [User]" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection 1 row down [User]" })

