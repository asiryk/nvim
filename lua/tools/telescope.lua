local telescope = require("telescope")

local noremap = { noremap = true }

telescope.setup {
  pickers = {
    find_files = {
      theme = "ivy",
    },
  },
}

vim.api.nvim_set_keymap("n", "<Leader>p", "<cmd>lua require('telescope.builtin').find_files()<CR>", noremap)
vim.api.nvim_set_keymap("n", "<Leader>F", "<cmd>lua require('telescope.builtin').live_grep()<CR>", noremap)
vim.api.nvim_set_keymap("n", "<Leader>B", "<cmd>lua require('telescope.builtin').buffers()<CR>", noremap)
vim.api.nvim_set_keymap("n", "<Leader>H", "<cmd>lua require('telescope.builtin').help_tags()<CR>", noremap)
vim.api.nvim_set_keymap("n", "<Leader>a", "<cmd>lua require('telescope.builtin').builtin()<CR>", noremap)
