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
  {
    dir = "~/personal/nvim-web-devicons",
    config = function()
      local devicons = require("nvim-web-devicons")
      devicons.setup({ blend = 0 })
    end,
  },
  {
    "echasnovski/mini.nvim",
    config = function() require("plugins.mini") end,
  },
  {
    "asiryk/snacks.nvim",
    opts = {
      bigfile = { enabled = true },
      indent = {
        enabled = true,
        hl = "SnacksIndent",
        scope = { hl = "SnacksIndent1" },
        animate = { enabled = false },
      },
      dim = {}, -- Leave it on for fun. Usage :lua Snacks.dim.enable()
    },
    event = "BufEnter",
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
    event = "BufEnter",
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
  {
    "saghen/blink.cmp",
    dependencies = { "L3MON4D3/LuaSnip" },
    version = "1.*",
    config = function() require("plugins.blink") end,
    event = "BufEnter",
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
  -- {
  --   "sourcegraph/amp.nvim",
  --   branch = "main",
  --   opts = { auto_start = false, log_level = "info" },
  -- },
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
    event = "BufEnter",
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function() require("plugins.gitsigns") end,
    tag = "v1.0.2",
    event = "BufEnter",
  },
  {
    "tpope/vim-fugitive",
    config = function() require("plugins.fugitive") end,
    event = "BufEnter",
  },
  {
    "sindrets/diffview.nvim",
    config = function() require("plugins.diffview") end,
  },
  {
    "jinh0/eyeliner.nvim",
    opts = { highlight_on_key = true, dim = true },
    event = "BufEnter",
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
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    config = function()
      require("plugins.ufo")
    end,
    event = "BufEnter",
  },
  {
    "stevearc/quicker.nvim",
    event = "FileType qf",
    opts = {},
  },
  "mbbill/undotree",
  require("plugins.obsidian"),
}

require("lazy").setup(spec)
