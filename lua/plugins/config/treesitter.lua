local utils = require("core.utils")
local ts_config = require("nvim-treesitter.configs")

local options = {
  highlight = {
    enable = true,
    disable = function(_, buf)
      local buf_size = utils.get_buf_size_in_bytes(buf)
      return buf_size > 1000000
    end,
  },
  indent = { enable = true },
  playground = {
    enable = true,
  },
  ensure_installed = {
    "astro",
    "css",
    "html",
    "java",
    "javascript",
    "jsdoc",
    "lua",
    "markdown",
    "markdown_inline",
    "regex",
    "rust",
    "svelte",
    "tsx",
    "typescript",
    "vim",
    "c",
    "go",
    "glsl",
    "yaml",
    "toml",
    "json",
    "python",
    "latex",
    "dockerfile",
    "bash",
  },
}

ts_config.setup(options)

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("NvimTreesitter-handlebars", {}),
  pattern = "handlebars",
  callback = function() vim.cmd("set filetype=html") end,
  desc = "Use html treesitter parser for handlebars",
})
