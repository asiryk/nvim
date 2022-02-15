local use_packages = function(use)
  -- utils
  use "wbthomason/packer.nvim"
  use "nvim-lua/plenary.nvim"
  use "kyazdani42/nvim-web-devicons"

  --editor
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
  use "numToStr/Comment.nvim"
  use "L3MON4D3/LuaSnip"                                        -- snippets engine
  use "hrsh7th/nvim-cmp"                                        -- completion engine
  use "saadparwaiz1/cmp_luasnip"                                -- integration of snippets with completion
  use "hrsh7th/cmp-nvim-lua"                                    -- cmp source for Lua
  use "hrsh7th/cmp-buffer"                                      -- cmp source for buffer words
  use "hrsh7th/cmp-path"                                        -- cmp source for for filesystem paths

  -- interface
  use "asiryk/everforest"
  use "nvim-lualine/lualine.nvim"
  use "nvim-telescope/telescope.nvim"
  use "kyazdani42/nvim-tree.lua"

  -- languages
  use "neovim/nvim-lspconfig"                                   -- config for language servers
  use "hrsh7th/cmp-nvim-lsp"                                    -- integration of lsp with completion
end

require("packer").startup(use_packages)
require "primary"
require "keymaps"
require "editor"
require "interface"
require "languages"