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
  use "norcalli/nvim-colorizer.lua"                             -- highlight colors

  -- interface
  use "nvim-lualine/lualine.nvim"
  use "sainnhe/everforest"
  use "navarasu/onedark.nvim"

  -- languages
  use "neovim/nvim-lspconfig"                                   -- config for language servers
  use "hrsh7th/cmp-nvim-lsp"                                    -- integration of lsp with completion

  -- tools
  use "nvim-telescope/telescope.nvim"
  use "akinsho/toggleterm.nvim"
end

require "defaults"
require "keymaps"

local present, packer = pcall(require, "packer")
if not present then
  return print("You should install packer.nvim \nhttps://github.com/wbthomason/packer.nvim")
end

packer.startup(use_packages)

require "editor"
require "interface"
require "languages"
require "tools"
