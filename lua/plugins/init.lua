return {
  ["wbthomason/packer.nvim"] = {},
  ["nvim-lua/plenary.nvim"] = { module = "plenary" },
  ["kyazdani42/nvim-web-devicons"] = { module = "nvim-web-devicons" },

  ["nvim-treesitter/nvim-treesitter"] = {
    -- Force load Treesitter because of the first time initialization error.
    -- TODO: it should be lazy loaded.
    setup = function() vim.cmd("PackerLoad nvim-treesitter") end,
    config = function() require("plugins.config.treesitter") end,
    run = ":TSUpdate",
  },

  ["neovim/nvim-lspconfig"] = { config = function() require("plugins.config.lspconfig") end },

  ["jose-elias-alvarez/null-ls.nvim"] = {
    after = "nvim-lspconfig",
    config = function() require("plugins.config.null-ls") end,
  },

  -- Completion and snippets. Are loaded in Insert mode only.
  ["rafamadriz/friendly-snippets"] = { event = "InsertEnter" },
  ["L3MON4D3/LuaSnip"] = { config = function() require("plugins.config.luasnip") end, after = "friendly-snippets" },
  ["hrsh7th/nvim-cmp"] = { config = function() require("plugins.config.cmp") end, after = "LuaSnip" },
  ["saadparwaiz1/cmp_luasnip"] = { after = "nvim-cmp" },
  ["hrsh7th/cmp-nvim-lsp"] = { after = "cmp_luasnip" },
  ["hrsh7th/cmp-nvim-lua"] = { after = "cmp-nvim-lsp" },
  ["hrsh7th/cmp-buffer"] = { after = "cmp-nvim-lua" },
  ["hrsh7th/cmp-path"] = { after = "cmp-buffer" },

  ["numToStr/Comment.nvim"] = { config = function() require("Comment").setup() end, keys = { "gc", "gb" } },

  ["nvim-telescope/telescope.nvim"] = {
    config = function() require("plugins.config.telescope") end,
    keys = { "<Leader>f" }, -- All Telescope keybindings start with <Leader>f
  },

  ["lewis6991/gitsigns.nvim"] = { config = function() require("plugins.config.gitsigns") end },

  ---- Themes
  --["sainnhe/everforest"] = {},
  --["navarasu/onedark.nvim"] = {},
}
