do -- download lazy if not exists
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

local spec = {
  {
    "nvim-lua/plenary.nvim",
    lazy = false,
  },
  "nvim-tree/nvim-web-devicons",
  {
    "echasnovski/mini.nvim",
    config = function() require("plugins.mini") end,
  },
  {
    "folke/snacks.nvim",
    opts = {
      bigfile = { enabled = true },
      indent = {
        enabled = true,
        hl = "SnacksIndent",
        scope = { hl = "SnacksIndent1" },
        animate = { enabled = false },
      },
    },
  },
  { -- treesitter
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function() require("plugins.treesitter") end,
    build = function()
      require("nvim-treesitter").setup()
      require("plugins.treesitter")
      vim.cmd("TSUpdate")
    end,
  },
  { -- lsp
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      -- formatting
      "stevearc/conform.nvim",
    },
    config = function() require("plugins.lsp") end,
  },
  { -- completion
    -- Probably replace it with blink.nvim. Only if blink has better
    -- highlight groups support (doesn't mess highlights on theme change),
    -- and snippets work either the same or better.
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function() require("plugins.completion") end,
  },
  {
    "supermaven-inc/supermaven-nvim",
    commit = "07d20fce48a5629686aefb0a7cd4b25e33947d50",
    config = function()
      vim.api.nvim_create_user_command(
        "AIStart",
        function() vim.notify("Turned on AI", vim.log.levels.INFO) end,
        { desc = "Manually turn on AI completion [User]" }
      )
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<C-l>",
          clear_suggestion = "<C-]>",
          accept_word = "<C-j>",
        },
      })
    end,
    cmd = "AIStart",
  },
  { -- telescope
    "nvim-telescope/telescope.nvim",
    config = function() require("plugins.telescope") end,
    keys = { "<Leader>f" },
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
  },
  -- misc
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    config = function() require("plugins.harpoon") end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function() require("plugins.gitsigns") end,
    tag = "v1.0.2",
  },
  {
    "tpope/vim-fugitive",
    config = function() require("plugins.fugitive") end,
  },
  {
    "sindrets/diffview.nvim",
    config = function() require("plugins.diffview") end,
  },
  {
    "jinh0/eyeliner.nvim",
    opts = { highlight_on_key = true, dim = true },
  },
  {
    "mattn/emmet-vim",
    ft = { "html", "svelte", "astro", "handlebars" },
    build = ":EmmetInstall",
  },
  { "j-hui/fidget.nvim", opts = {} },
  {
    "stevearc/dressing.nvim",
    opts = {
      input = {
        win_options = {
          winblend = vim.o.pumblend,
        },
      },
    },
  },
  {
    "stevearc/quicker.nvim",
    event = "FileType qf",
    opts = {},
  },
  {
    "catgoose/nvim-colorizer.lua",
    config = function()
      vim.api.nvim_create_user_command(
        "Color",
        function() vim.notify("Turned Color", vim.log.levels.INFO) end,
        { desc = "Manually turn on Color [User]" }
      )
      require("colorizer").setup({
        filetypes = { "*" },
      })
    end,
    cmd = "Color",
  },
  "mbbill/undotree",
}

require("lazy").setup(spec)
