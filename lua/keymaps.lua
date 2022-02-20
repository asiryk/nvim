local noremap = { noremap = true, silent = true }

local function map(mode, lhs, rhs, opts)
  local _opts = {}
  if opts then _opts = vim.tbl_extend('force', _opts, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, _opts)
end

map("i", "jk", "<esc>")                           -- Remap "esc" to "jk"
map("n", "tn", "<cmd>tabnew<CR>", noremap)        -- Create new tab
map("n", "<C-L>", "<cmd>tabnext<CR>", noremap)    -- Switch to right tab
map("n", "<C-H>", "<cmd>tabprev<CR>", noremap)    -- Switch to left tab
map("n", "tc", "<cmd>tabclose<CR>", noremap)      -- Close current tab
map("n", "tac", "<cmd>tabo<CR>", noremap)         -- Close all tabs
