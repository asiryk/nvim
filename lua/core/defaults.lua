-- Following remaps don't add new features/keybindings, but improve existing ones

local autocmd = vim.api.nvim_create_autocmd

vim.opt.mouse = "a" -- Enable mouse support
-- vim.opt.clipboard = "unnamedplus" -- Use system clipboard -- TODO change this to use registers/tmux in the future
vim.opt.cursorline = false -- Don't highlight current line
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show line number starting at cursor position
vim.opt.signcolumn = "yes" -- Show sign column always, even without lsp or gitsigns
vim.opt.swapfile = false -- Disable swapfiles
vim.opt.expandtab = true -- Use tabs instead of spaces
vim.opt.tabstop = 2 -- Amount of spaces the tab is displayed
vim.opt.shiftwidth = 2 -- Amount of spaces to use for each step of (auto)indent
vim.opt.smartindent = true -- Copy indent from the previous line
vim.opt.termguicolors = true -- Set 24 bit colors
vim.opt.laststatus = 3 -- Set global status line
vim.opt.hlsearch = false -- Don't highlight searches
vim.opt.ignorecase = true -- Ignore case when searching

-- Set undo breakpoints: Every time following key ({"<CR>", "."})
-- gets pressed, it stops current change, so the next "undo"
-- will apply up to this key
local undo_breakpoints = { "<CR>", "." }
for _, key in pairs(undo_breakpoints) do
  vim.keymap.set("i", key, key .. "<c-g>u")
end

-- Center cursor
vim.keymap.set("n", "<C-i>", "<C-i>zz")
vim.keymap.set("n", "<C-o>", "<C-o>zz")

vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

vim.keymap.set("n", "<C-f>", "<C-f>zz")
vim.keymap.set("n", "<C-b>", "<C-b>zz")

vim.keymap.set("n", "<S-g>", "<S-g>zz")

vim.keymap.set("n", "n", "nzzzv") -- TODO: don't pollute :reg by pressing x, pasting, etc
vim.keymap.set("n", "N", "Nzzzv")

-- Move one or more selected lines up and down (in Visual mode)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- TODO: don't modify undo list; TODO: probably replace with lua function
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Add position to jumplist if moving more than 5 lines up or down
vim.keymap.set("n", "j", [[v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'j']], { expr = true })
vim.keymap.set("n", "k", [[v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'k']], { expr = true })

-- Don't auto comment new lines
autocmd("BufEnter", {
  pattern = "*",
  command = "set fo-=c fo-=r fo-=o",
})

-- Highilight yanked text for a short time
autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 40,
    })
  end,
})

-- Disable some default plugins
local default_plugins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "matchit",
  "tar",
  "tarPlugin",
  "rrhelper",
  "spellfile_plugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
  "python3_provider",
  "python_provider",
  "node_provider",
  "ruby_provider",
  "perl_provider",
  "tutor",
  "rplugin",
  "syntax",
  "synmenu",
  "optwin",
  "compiler",
  "bugreport",
  -- "ftplugin",
}

for _, plugin in pairs(default_plugins) do
  vim.g["loaded_" .. plugin] = 1
end
