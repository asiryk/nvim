local packer = require("plugins.packer")

vim.cmd("packadd packer.nvim")

local plugins = {
   ["wbthomason/packer.nvim"] = {},
   ["nvim-lua/plenary.nvim"] = { module = "plenary" },
   ["kyazdani42/nvim-web-devicons"] = { module = "nvim-web-devicons" },

   ["nvim-treesitter/nvim-treesitter"] = {
      module = "nvim-treesitter",
      setup = function()
         packer.load_on_file_open("nvim-treesitter")
      end,
      run = ":TSUpdate",
      config = function()
         require "plugins.config.treesitter"
      end,
   },

   ["neovim/nvim-lspconfig"] = {
      module = "lspconfig",
      config = function()
         require "plugins.config.lspconfig"
      end,
   },

   -- Load snippets engine and snippets for insert mode only
   ["rafamadriz/friendly-snippets"] = { event = "InsertEnter" },
   ["hrsh7th/nvim-cmp"] = {
      after = "friendly-snippets",
      config = function()
         require "plugins.config.cmp"
      end,
   },
   ["L3MON4D3/LuaSnip"] = {
      wants = "friendly-snippets",
      after = "nvim-cmp",
      config = function()
         require("plugins.config.luasnip")
      end,
   },
   ["saadparwaiz1/cmp_luasnip"] = { after = "LuaSnip" },
   ["hrsh7th/cmp-nvim-lua"] = { after = "cmp_luasnip" },
   ["hrsh7th/cmp-nvim-lsp"] = { after = "cmp-nvim-lua" },
   ["hrsh7th/cmp-buffer"] = { after = "cmp-nvim-lsp" },
   ["hrsh7th/cmp-path"] = { after = "cmp-buffer" },

   ["numToStr/Comment.nvim"] = {
      module = "comment-nvim",
      keys = { "gc", "gb" },
      config = function()
         require("plugins.config.comment")
      end,
   },

   ["nvim-telescope/telescope.nvim"] = {
      cmd = "Telescope",
      config = function()
         require "plugins.config.telescope"
      end,
   },

   -- Themes
   ["sainnhe/everforest"] = {},
   ["navarasu/onedark.nvim"] = {},
}

packer.startup(plugins)
