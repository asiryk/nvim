return {
  ["wbthomason/packer.nvim"] = {},
  ["nvim-lua/plenary.nvim"] = { module = "plenary" },
  ["kyazdani42/nvim-web-devicons"] = { module = "nvim-web-devicons" },

  ["nvim-treesitter/nvim-treesitter"] = {
    config = function() require("plugins.config.treesitter") end,
    run = function()
      require("nvim-treesitter").setup()
      require("plugins.config.treesitter")
      vim.cmd("TSUpdate")
    end,
  },
  ["nvim-treesitter/nvim-treesitter-context"] = {
    config = function() require("plugins.config.treesitter-context") end,
    after = "nvim-treesitter",
  },
  ["m-demare/hlargs.nvim"] = {
    config = function() require("plugins.config.hlargs") end,
    after = "nvim-treesitter",
  },
  ["nvim-treesitter/playground"] = { after = "nvim-treesitter" },

  ["jinh0/eyeliner.nvim"] = {
    config = function() require("eyeliner").setup({ highlight_on_key = true }) end,
  },

  ["mattn/emmet-vim"] = {
    ft = { "html", "svelte", "astro", "handlebars" },
    run = ":EmmetInstall",
  },

  ["neovim/nvim-lspconfig"] = {
    config = function() require("plugins.config.lspconfig") end,
  },
  ["williamboman/mason.nvim"] = {
    after = "nvim-lspconfig",
    config = function() require("plugins.config.mason") end,
  },

  ["jose-elias-alvarez/null-ls.nvim"] = {
    after = "nvim-lspconfig",
    config = function() require("plugins.config.null-ls") end,
  },

  -- Completion and snippets. Are loaded in Insert mode only.
  ["L3MON4D3/LuaSnip"] = {
    config = function() require("plugins.config.luasnip") end,
    event = "InsertEnter",
  },
  ["hrsh7th/nvim-cmp"] = {
    config = function() require("plugins.config.cmp") end,
    after = "LuaSnip",
  },
  ["saadparwaiz1/cmp_luasnip"] = { after = "nvim-cmp" },
  ["hrsh7th/cmp-nvim-lsp"] = { after = "cmp_luasnip" },
  ["hrsh7th/cmp-nvim-lua"] = { after = "cmp-nvim-lsp" },
  ["hrsh7th/cmp-buffer"] = { after = "cmp-nvim-lua" },
  ["hrsh7th/cmp-path"] = { after = "cmp-buffer" },

  ["numToStr/Comment.nvim"] = {
    config = function() require("plugins.config.comment-nvim") end,
    keys = { "gc", "gb" },
  },

  ["nvim-telescope/telescope.nvim"] = {
    config = function() require("plugins.config.telescope") end,
    keys = { "<Leader>f" },
  },

  ["ThePrimeagen/harpoon"] = {
    config = function() require("plugins.config.harpoon") end,
  },

  ["kyazdani42/nvim-tree.lua"] = {
    config = function() require("plugins.config.nvim-tree") end,
    keys = { "<C-N>", "<Leader>n" },
  },

  ["lewis6991/gitsigns.nvim"] = {
    config = function() require("plugins.config.gitsigns") end,
    commit = "d3a8ba0b0d34bbac482b963e52b346065169fa20",
  },

  ["akinsho/toggleterm.nvim"] = {
    config = function() require("plugins.config.toggleterm") end,
    keys = { "<C-T>" },
  },

  ["simrat39/rust-tools.nvim"] = {
    config = function() require("plugins.config.rust-tools") end,
    ft = { "rust" },
  },

  -- Themes
  ["sainnhe/everforest"] = {},
  ["navarasu/onedark.nvim"] = {},
}
