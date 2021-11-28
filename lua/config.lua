-------------------------------------------------
-- General
-------------------------------------------------
vim.opt.mouse = 'a'                               -- Enable mouse support
vim.opt.clipboard = 'unnamedplus'                 -- Use system clipboard
vim.opt.number = true                             -- Show line numbers
vim.opt.relativenumber = true                     -- Show line number starting at cursor position
vim.cmd[[au BufEnter * set fo-=c fo-=r fo-=o]]    -- Don't auto comment new lines
vim.cmd[[colorscheme murphy]]                     -- Set the colorscheme

-------------------------------------------------
-- Tabs, indentation
-------------------------------------------------
vim.opt.expandtab = true                          -- Use tabs instead of spaces
vim.opt.tabstop = 2                               -- Amount of spaces the tab is displayed
vim.opt.shiftwidth = 2                            -- Amount of spaces to use for each step of (auto)indent
vim.opt.smartindent = true                        -- Copy indent from the previous line

