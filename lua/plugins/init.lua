return {
   ["wbthomason/packer.nvim"] = {},
   ["nvim-lua/plenary.nvim"] = { module = "plenary" },
   ["kyazdani42/nvim-web-devicons"] = { module = "nvim-web-devicons" },

   --["nvim-treesitter/nvim-treesitter"] = {
   --   run = ":TSUpdate",
   --   config = function() require("plugins.config.treesitter") end,
   --},

   ["neovim/nvim-lspconfig"] = { config = function() require("plugins.config.lspconfig") end },

   --["jose-elias-alvarez/null-ls.nvim"] = {
   --   after = "nvim-lspconfig",
   --   config = function() require("plugins.config.null-ls") end,
   --},

   -- Completion and snippets
   ["rafamadriz/friendly-snippets"] = {}, -- todo maybe add some event not to load every time
   ["hrsh7th/nvim-cmp"] = { config = function() require("plugins.config.cmp") end },
   ["L3MON4D3/LuaSnip"] = { config = function() require("plugins.config.luasnip") end },
   ["saadparwaiz1/cmp_luasnip"] = { after = "LuaSnip" },
   ["hrsh7th/cmp-nvim-lsp"] = { after = "cmp_luasnip" },
   ["hrsh7th/cmp-nvim-lua"] = { after = "cmp-nvim-lsp" },
   ["hrsh7th/cmp-buffer"] = { after = "cmp-nvim-lua" },
   ["hrsh7th/cmp-path"] = { after = "cmp-buffer" },

   ["numToStr/Comment.nvim"] = { config = function() require("Comment").setup() end },

   ["nvim-telescope/telescope.nvim"] = { config = function() require("plugins.config.telescope") end },

   ["lewis6991/gitsigns.nvim"] = { config = function() require("plugins.config.gitsigns") end },

   ---- Themes
   --["sainnhe/everforest"] = {},
   --["navarasu/onedark.nvim"] = {},
}
