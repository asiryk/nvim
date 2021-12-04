vim.cmd[[inoremap jk <esc>]]                                                    -- Remap "esc" to "jk"
vim.api.nvim_set_keymap('n', '<C-N>',
  ':Lexplore<CR> :vertical resize 30<CR>', { noremap = true })                  -- Open explorer
vim.api.nvim_set_keymap('n', 'tn', ':tabnew<CR>', { noremap = true })           -- Create new tab
vim.api.nvim_set_keymap('n', '<C-L>', ':tabnext<CR>', { noremap = true })       -- Switch to right tab
vim.api.nvim_set_keymap('n', '<C-H>', ':tabprev<CR>', { noremap = true })       -- Switch to left tab
vim.api.nvim_set_keymap('n', 'tc', ':tabclose<CR>', { noremap = true })         -- Close current tab
vim.api.nvim_set_keymap('n', 'tac', ':tabo<CR>', { noremap = true })            -- Close all tabs

