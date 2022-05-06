local telescope = require("telescope")
local builtin = require("telescope/builtin")

telescope.setup {
  pickers = {
    find_files = {
      theme = "ivy",
    },
  },
}

vim.keymap.set("n", "<Leader>p", builtin.find_files)
vim.keymap.set("n", "<Leader>F", builtin.live_grep)
vim.keymap.set("n", "<Leader>a", builtin.builtin)
