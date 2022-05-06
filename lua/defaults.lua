--
-- Following remaps don't add new features/keybindings, but improve existing ones
--
local autocmd = require("helpers").autocmd

vim.opt.mouse = "a"                               -- Enable mouse support
vim.opt.clipboard = "unnamedplus"                 -- Use system clipboard
vim.opt.cursorline = true                         -- Highlight current line
vim.opt.number = true                             -- Show line numbers
vim.opt.relativenumber = true                     -- Show line number starting at cursor position
vim.opt.swapfile = false                          -- Disable swapfiles
vim.opt.expandtab = true                          -- Use tabs instead of spaces
vim.opt.tabstop = 2                               -- Amount of spaces the tab is displayed
vim.opt.shiftwidth = 2                            -- Amount of spaces to use for each step of (auto)indent
vim.opt.smartindent = true                        -- Copy indent from the previous line
vim.opt.termguicolors = true                      -- Set 24 bit colors

-- Set undo breakpoints: Every time following key ({"<CR>", "."})
-- gets pressed, it stops current change, so the next "undo"
-- will apply up to this key
for _, key in pairs({ "<CR>", "." }) do
  vim.keymap.set("i", key, key .. "<c-g>u")
end

-- Center screen on the "next" and "previos" search jumps
vim.keymap.set("n", "n", "nzzzv") -- todo don't pollute :reg by pressing x, pasting, etc
vim.keymap.set("n", "N", "Nzzzv")

-- Move one or more selected lines up and down (in Visual mode)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- todo: don't modify undo list; todo: probably replace with lua function
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Add position to jumplist if moving more than 5 lines up or down
vim.keymap.set("n", "j", [[v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'j']], { expr = true })
vim.keymap.set("n", "k", [[v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'k']], { expr = true })

autocmd("VimLeave", { "guicursor", "a:ver100" }) -- set beam cursor when leaving neovim
autocmd("BufEnter", function()
  -- Don't auto comment new lines
  vim.opt.formatoptions = vim.opt.formatoptions
      - "c"
      - "r"
      - "o"
end)
