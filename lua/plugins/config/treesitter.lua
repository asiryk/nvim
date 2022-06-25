local present, treesitter = pcall(require, "nvim-treesitter.configs")

if not present then return end

local options = {
   highlight = {
      enable = true,
      use_languagetree = true,
   },
   indent = {
      enable = false,
   },
   ensure_installed = {
      "bash",
      "css",
      "html",
      "java",
      "javascript",
      "jsdoc",
      "json",
      "latex",
      "lua",
      "markdown",
      "python",
      "regex",
      "rust",
      "svelte",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "yaml",
   },
}

treesitter.setup(options)
