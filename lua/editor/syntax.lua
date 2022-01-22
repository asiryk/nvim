require("nvim-treesitter.configs").setup {
  highlight = {
    enable = true,
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
    "lua",
    "python",
    "regex",
    "rust",
    "toml",
    "tsx",
    "typescript",
  },
}