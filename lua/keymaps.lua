vim.keymap.set("n", "<bs>", "<nop>") -- Unmap Backspace
vim.keymap.set("n", "<space>", "<nop>") -- Unmap Space
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

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Turn off hlsearch with Esc" })
