require('general')
require('keymaps')
require('themes')
require('plugins')

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'asiryk/everforest'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'nvim-telescope/telescope.nvim', requires = { {'nvim-lua/plenary.nvim'} } }
  use { 'nvim-lualine/lualine.nvim', requires = {'kyazdani42/nvim-web-devicons', opt = true} }
end)

