return {
  ["nvim-lua/plenary.nvim"] = {},
  ["nvim-tree/nvim-web-devicons"] = {},

  -- ["asiryk/auto-hlsearch.nvim"] = { config = {} },

  ["nvim-treesitter/nvim-treesitter"] = {
    config = function() require("plugins.config.treesitter") end,
    build = function()
      require("nvim-treesitter").setup()
      require("plugins.config.treesitter")
      vim.cmd("TSUpdate")
    end,
  },
  -- ["m-demare/hlargs.nvim"] = { config = {} },
  -- ["nvim-treesitter/playground"] = {},

  -- ["jinh0/eyeliner.nvim"] = {
  --   config = function() require("eyeliner").setup({ highlight_on_key = true }) end,
  -- },

  -- ["mattn/emmet-vim"] = {
  --   ft = { "html", "svelte", "astro", "handlebars" },
  --   build = ":EmmetInstall",
  -- },

  ["neovim/nvim-lspconfig"] = {
    config = function() require("plugins.config.lspconfig") end,
  },
  ["williamboman/mason.nvim"] = {
    config = function() require("plugins.config.mason") end,
  },

  ["jose-elias-alvarez/null-ls.nvim"] = {
    config = function() require("plugins.config.null-ls") end,
  },

  -- Completion and snippets. Are loaded in Insert mode only.
  ["L3MON4D3/LuaSnip"] = {
    config = function() require("plugins.config.luasnip") end,
    event = "InsertEnter",
  },
  ["hrsh7th/nvim-cmp"] = {
    config = function() require("plugins.config.cmp") end,
  },
  ["saadparwaiz1/cmp_luasnip"] = {},
  ["hrsh7th/cmp-nvim-lsp"] = {},
  ["hrsh7th/cmp-nvim-lua"] = {},
  ["hrsh7th/cmp-buffer"] = {},
  ["hrsh7th/cmp-path"] = {},

  ["numToStr/Comment.nvim"] = {
    config = function() require("plugins.config.comment-nvim") end,
    keys = { { "gc", mode = { "n", "v" } }, { "gb", mode = { "n", "v" } } },
  },

  ["nvim-telescope/telescope.nvim"] = {
    config = function() require("plugins.config.telescope") end,
    keys = { "<Leader>f" },
  },
  ["nvim-telescope/telescope-fzf-native.nvim"] = {
    build = "make"
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

  -- ["akinsho/toggleterm.nvim"] = {
  --   config = function() require("plugins.config.toggleterm") end,
  --   keys = { "<C-T>" },
  -- },

  -- ["simrat39/rust-tools.nvim"] = {
  --   config = function() require("plugins.config.rust-tools") end,
  --   ft = { "rust" },
  -- },
  -- ["folke/zen-mode.nvim"] = {
  --   config = function()
  --     require("zen-mode").setup()
  --     vim.api.nvim_create_user_command(
  --       "Zen",
  --       function() require("zen-mode").toggle() end,
  --       {}
  --     )
  --   end,
  -- },

  -- Themes
  ["sainnhe/everforest"] = {},
  ["navarasu/onedark.nvim"] = {},
}
