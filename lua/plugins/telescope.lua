local telescope = require("telescope")
local builtin = require("telescope.builtin")
local bind = require("plenary.fun").bind

local function find_nvim_config() builtin.find_files({ cwd = "~/.config/nvim/" }) end

vim.keymap.set("n", "<Leader>fo",
  bind(builtin.find_files, { hidden = true }),
  { desc = "Find files [Telescope]" }
)
vim.keymap.set("n", "<Leader>ff",
  bind(builtin.live_grep, { additional_args = { "--hidden" } }),
  { desc = "Find text [Telescope]" }
)
vim.keymap.set("n", "<Leader>fa", builtin.builtin, { desc = "Find action [Telescope]" })
vim.keymap.set("n", "<Leader>fb", builtin.buffers, { desc = "Find buffers [Telescope]" })
vim.keymap.set("n", "<Leader>fc", find_nvim_config, { desc = "Find Neovim configs [Telescope]" })
vim.keymap.set("n", "<Leader>fr", builtin.lsp_references, { desc = "Find LSP references [Telescope]" })
vim.keymap.set("n", "<Leader>fh", builtin.help_tags, { desc = "Find Neovim help [Telescope]" })
vim.keymap.set("n", "<Leader>fk", builtin.keymaps, { desc = "Find keymaps [Telescope]" })
vim.keymap.set("n", "<Leader>fm", builtin.marks, { desc = "Find marks [Telescope]" })

local ignore_files = {
  -- folders
  ".git/",
  "node_modules/",
  "bin/",
  "obj/",

  -- files
  "^.*%.ogg$",
  "^.*%.m4a$",
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
    winblend = G.const.default_winblend,
    prompt_prefix = "",
    selection_caret = "  ",
    file_ignore_patterns = ignore_files,
  },
}

telescope.setup(options)
telescope.load_extension("fzf")
