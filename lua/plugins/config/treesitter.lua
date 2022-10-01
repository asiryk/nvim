local present, treesitter = pcall(require, "nvim-treesitter.configs")
local utils = require("core.utils")

-- Try to load treesitter on first launch when autoinstalled plugins
-- todo probably remove since :TSUpdate at the end of the config
if not present then vim.cmd("PackerLoad nvim-treesitter") end

present, treesitter = pcall(require, "nvim-treesitter.configs")

if not present then return end

local options = {
  highlight = {
    enable = true,
    use_languagetree = true,
    disable = function(_, buf)
      local buf_size = utils.get_buf_size_in_bytes(buf)
      return buf_size > 1000000
    end,
  },
  indent = { enable = false },
  playground = {
    enable = true,
  },
  ensure_installed = {
    "css",
    "html",
    "java",
    "javascript",
    "jsdoc",
    "lua",
    "markdown",
    "regex",
    "rust",
    "svelte",
    "tsx",
    "typescript",
    "vim",
  },
}

treesitter.setup(options)

vim.cmd("normal! :TSUpdate<cr>")
