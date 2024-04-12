return {
  ["nvim-lua/plenary.nvim"] = {},
  ["nvim-tree/nvim-web-devicons"] = {},

  ["nvim-treesitter/nvim-treesitter"] = {
    config = function() require("plugins.config.treesitter") end,
    build = function()
      require("nvim-treesitter").setup()
      require("plugins.config.treesitter")
      vim.cmd("TSUpdate")
    end,
  },
  ["nvim-treesitter/nvim-treesitter-context"] = {},
  ["nvim-treesitter/nvim-treesitter-textobjects"] = {},
  ["jinh0/eyeliner.nvim"] = {
    opts = { highlight_on_key = true, dim = true }
  },

  ["mattn/emmet-vim"] = {
    ft = { "html", "svelte", "astro", "handlebars" },
    build = ":EmmetInstall",
  },

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
  ["hrsh7th/nvim-cmp"] = {
    config = function() require("plugins.config.cmp") end,
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        config = function() require("plugins.config.luasnip") end,
        event = "InsertEnter",
      },
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    }
  },

  ["numToStr/Comment.nvim"] = {
    config = function() require("plugins.config.comment-nvim") end,
    keys = { { "gc", mode = { "n", "v" } }, { "gb", mode = { "n", "v" } } },
  },

  ["nvim-telescope/telescope.nvim"] = {
    config = function() require("plugins.config.telescope") end,
    keys = { "<Leader>f" },
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
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
    tag = "v0.7"
  },

  ["mbbill/undotree"] = {
    config = function()
      vim.keymap.set("n", "<leader>ut", vim.cmd.UndotreeToggle)
    end,
    commit = "aa93a7e"
  },

  -- ["simrat39/rust-tools.nvim"] = {
  --   config = function() require("plugins.config.rust-tools") end,
  --   ft = { "rust" },
  -- },

  -- Themes
  ["sainnhe/everforest"] = {},
  ["navarasu/onedark.nvim"] = {},
}
