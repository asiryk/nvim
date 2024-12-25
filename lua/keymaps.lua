local keymaps_augroup = vim.api.nvim_create_augroup("keymaps", {})

vim.keymap.set("n", "<bs>", "<nop>", { desc = "Unmap backspace [User]" })
vim.keymap.set("n", "<space>", "<nop>", { desc = "Unmap space [User]" })
vim.g.mapleader = " " -- vim.keymap.set Leader key
vim.g.maplocalleader = ","

-- vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "Create new tab" })
-- vim.keymap.set({ "n", "i", "v" }, "<C-L>", "<cmd>tabnext<CR>", { desc = "Switch to right tab" })
-- vim.keymap.set({ "n", "i", "v" }, "<C-H>", "<cmd>tabprev<CR>", { desc = "Switch to left tab" })
-- vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Close current tab" })
-- vim.keymap.set("n", "<leader>tac", "<cmd>tabo<CR>", { desc = "Close all tabs" })

-- Quickfix list
do
  vim.keymap.set("n", "<M-o>", "<cmd>copen<CR>", { desc = "Quickfix list open [User]" })
  vim.keymap.set("n", "<M-q>", "<cmd>cclose<CR>", { desc = "Quickfix list close [User]" })
  vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>zz", { desc = "Quickfix list next item [User]" })
  vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>zz", { desc = "Quickfix list prev item [User]" })
  -- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Open quickfix list [User]" })
  -- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Open quickfix list [User]" })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    group = keymaps_augroup,
    callback = function(match)
      local buf = match.buf
      vim.keymap.set("n", "q", ":cclose<CR>", { buffer = buf, silent = true, desc = "Close quickfix list [User]" })
    end
  })
end

vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode [User]" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Turn off hlsearch with Esc [User]" })

-- Move one or more selected lines up and down (in Visual mode)
-- TODO: don't modify undo list; TODO: probably replace with lua function
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection 1 row up [User]" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection 1 row down [User]" })

-- Control window
-- vim.keymap.set("n", "<M-h>", "<C-w>h")
-- vim.keymap.set("n", "<M-j>", "<C-w>j")
-- vim.keymap.set("n", "<M-k>", "<C-w>k")
-- vim.keymap.set("n", "<M-l>", "<C-w>l")
--
-- vim.keymap.set("n", "<C-M-h>", "<C-w><")
-- vim.keymap.set("n", "<C-M-j>", "<C-w>-")
-- vim.keymap.set("n", "<C-M-k>", "<C-w>+")
-- vim.keymap.set("n", "<C-M-l>", "<C-w>>")

vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank into system clipboard [User]" })
vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste from system clipboard [User]" })

vim.keymap.set("n", "<leader>xf", "<cmd>source %<CR>", { desc = "Execute lua file [User]" })
vim.keymap.set("n", "<leader>xx", ":.lua<CR>", { desc = "Execute current lua line [User]" })
vim.keymap.set("v", "<leader>x", ":lua<CR>", { desc = "Execute visual lua selection [User]" })
