---@diagnostic disable: missing-fields
local utils = require("custom").utils
local ts_config = require("nvim-treesitter.configs")

ts_config.setup({
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
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "c",
    "go",
    "gomod",
    "gosum",
    "gotmpl",
    "gowork",
    "yaml",
    "toml",
    "json",
    "dockerfile",
    "bash",
    "sql",
    "c_sharp",
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        ["af"] = { query = "@function.outer", desc = "Select around function" },
        ["if"] = { query = "@function.inner", desc = "Select inside function" },
        ["ab"] = { query = "@block.outer", desc = "Select around block" },
        ["ib"] = { query = "@block.inner", desc = "Select inside block" },
        ["ac"] = { query = "@comment.outer", desc = "Select around comment" },
        ["ic"] = { query = "@comment.inner", desc = "Select inside comment" },
      }
    }
  },
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("NvimTreesitter-handlebars", {}),
  pattern = "handlebars",
  callback = function() vim.cmd("set filetype=html") end,
  desc = "Use html treesitter parser for handlebars",
})

require("treesitter-context").setup({
  enable = true,
  -- throttle = true, -- Throttles plugin updates (may improve performance)
  -- max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
  -- show_all_context = true,
  patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
    -- For all filetypes
    -- Note that setting an entry here replaces all other patterns for this entry.
    -- By setting the 'default' entry below, you can control which nodes you want to
    -- appear in the context window.
    default = {
      "function",
      "method",
      "for",
      "while",
      "if",
      "switch",
      "case",
    },

    rust = {
      "loop_expression",
      "impl_item",
    },

    typescript = {
      "class_declaration",
      "abstract_class_declaration",
      "else_clause",
    },
  },
})
