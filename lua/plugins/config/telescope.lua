local present, telescope = pcall(require, "telescope")

if not present then return end

local builtin = require("telescope.builtin")

local function find_nvim_config() builtin.find_files({ cwd = "~/.config/nvim/" }) end

vim.keymap.set("n", "<Leader>fo", builtin.find_files)
vim.keymap.set("n", "<Leader>ff", builtin.live_grep)
vim.keymap.set("n", "<Leader>fa", builtin.builtin)
vim.keymap.set("n", "<Leader>fb", builtin.buffers)
vim.keymap.set("n", "<Leader>fc", find_nvim_config)
vim.keymap.set("n", "<Leader>fr", builtin.lsp_references)
vim.keymap.set("n", "<Leader>fh", builtin.help_tags)

local ignore_files = {
  -- work
  "assets/.+%.json",
  "config/.+%.json",
  "multimedia/.+%.json",
  "logs/.+%.json",

  -- folders
  "node_modules/",

  -- files
  "snippets/.+%.json$",
  "^.*%.log$",
  "^.*%.png$",
  "^.*%.jpg$",
  "^.*%.wav$",
  "^.*%.webp$",
  "^.*%.fnt$",
  "^.*%.woff?2$",
  "^.*%.atlas$",
  "^.*%.spine$",
}

local options = {
  defaults = {
    prompt_prefix = "",
    selection_caret = "  ",
    file_ignore_patterns = ignore_files,
  },
}

telescope.setup(options)
