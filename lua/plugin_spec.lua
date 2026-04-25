-- Don't load plugins if using neovim as manpager
for _, arg in pairs(vim.v.argv) do
  if arg == "+Man!" or arg == "Man!" then return end
end

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
    vim.o.cmdheight = 10 -- avoid "Press ENTER" prompt while Mason/Treesitter install on first launch
  end
  vim.opt.rtp:prepend(lazypath)
end

local spec = {
  {
    "nvim-lua/plenary.nvim",
    lazy = false,
  },
  {
    "nvim-tree/nvim-web-devicons",
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
      input = {
        enabled = true,
        win = { wo = { winblend = vim.o.pumblend } },
      },
    },
    -- event = "BufEnter",
  },
  { -- treesitter
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function() require("plugins.treesitter") end,
    build = ":TSUpdate",
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
  { -- telescope
    "nvim-telescope/telescope.nvim",
    config = function() require("plugins.telescope") end,
    event = "VeryLazy",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "nvim-telescope/telescope-ui-select.nvim",
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
    tag = "v2.1.0",
    event = "BufEnter",
  },
  {
    "tpope/vim-fugitive",
    config = function() require("plugins.git").setup_shared() end,
    event = "BufEnter",
  },
  {
    "sindrets/diffview.nvim",
    config = function()
      require("diffview").setup({ file_panel = { listing_style = "list" } })
      require("plugins.git").setup_shared()
    end,
  },
  { "j-hui/fidget.nvim", opts = {} },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    config = function() require("plugins.ufo") end,
    event = "BufEnter",
  },
  {
    "stevearc/quicker.nvim",
    event = "FileType qf",
    opts = {},
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      modes = {
        char = {
          keys = {},
        },
      },
    },
    keys = {
      { "S", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  }
}

require("lazy").setup(spec)
