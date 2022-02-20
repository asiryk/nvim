local opts = { noremap = true, silent = true }
local expr = { noremap = true, silent = true, expr = true }

vim.opt.mouse = "a"                               -- Enable mouse support
vim.opt.clipboard = "unnamedplus"                 -- Use system clipboard
vim.opt.cursorline = true                         -- Highlight current line
vim.opt.number = true                             -- Show line numbers
vim.opt.relativenumber = true                     -- Show line number starting at cursor position
vim.opt.swapfile = false                          -- Disable swapfiles
vim.cmd[[au BufEnter * set fo-=c fo-=r fo-=o]]    -- Don't auto comment new lines

vim.opt.expandtab = true                          -- Use tabs instead of spaces
vim.opt.tabstop = 2                               -- Amount of spaces the tab is displayed
vim.opt.shiftwidth = 2                            -- Amount of spaces to use for each step of (auto)indent
vim.opt.smartindent = true                        -- Copy indent from the previous line

--
-- Following remaps don't add new features, but improve existing behavior
--

-- Set undo breakpoints: Every time following key ({"<CR>", "."})
-- gets pressed, it stops current change, so the next "undo"
-- will apply up to this key
for _, key in pairs({"<CR>", "."}) do
  vim.api.nvim_set_keymap("i", key, key .. "<c-g>u", opts)
end

-- Center screen on the "next" and "previos" search jumps
vim.api.nvim_set_keymap("n", "n", "nzzzv", opts) -- todo don't pollute :reg by pressing x, pasting, etc
vim.api.nvim_set_keymap("n", "N", "Nzzzv", opts)

-- Move one or more selected lines up and down (in Visual mode)
vim.api.nvim_set_keymap("v", "J", ":m '>+1<CR>gv=gv", opts) -- todo: don't modify undo list
vim.api.nvim_set_keymap("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Add position to jumplist if moving more than 5 lines up or down
vim.api.nvim_set_keymap("n", "j", [[v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'j']], expr)
vim.api.nvim_set_keymap("n", "k", [[v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'k']], expr)
