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
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons",
  {
    "echasnovski/mini.nvim",
    config = function() require("mini.files").setup() end,
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
      "folke/neodev.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      -- formatting
      "stevearc/conform.nvim",
    },
    config = function() require("plugins.lsp") end
  },
  { -- completion
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
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
    config = function() require("plugins.harpoon") end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function() require("plugins.gitsigns") end,
    tag = "v0.8.1"
  },
  {
    "jinh0/eyeliner.nvim",
    opts = { highlight_on_key = true, dim = true }
  },
  {
    "mattn/emmet-vim",
    ft = { "html", "svelte", "astro", "handlebars" },
    build = ":EmmetInstall",
  },
  -- colorschemes
  "sainnhe/everforest",
  "navarasu/onedark.nvim",
}

require("lazy").setup(spec)

-- consider later
--
-- ["mbbill/undotree"] = {
--   config = function()
--     vim.keymap.set("n", "<leader>ut", vim.cmd.UndotreeToggle)
--   end,
--   commit = "aa93a7e"
-- },


-- ["kyazdani42/nvim-tree.lua"] = {
--   config = function() require("plugins.nvim-tree") end,
--   keys = { "<C-N>", "<Leader>n" },
-- },
