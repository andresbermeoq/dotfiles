vim.cmd.packadd("packer.nvim")

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  -- You can alias plugin names
  use {'folke/tokyonight.nvim', as = 'tokyonight'}
  -- Telescope
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.6',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }
  -- Treesiter
  use {'nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'}}
  -- LSP
  use {
	  'VonHeikemen/lsp-zero.nvim', branch = 'v3.x',
	  requires = {
		  'neovim/nvim-lspconfig',
		  'williamboman/mason.nvim',
		  'williamboman/mason-lspconfig.nvim',
	  },
  }
  -- Autocomplete CMP
  use {
	  'hrsh7th/nvim-cmp',
	  requires = {
		  'hrsh7th/cmp-nvim-lsp',
		  'hrsh7th/cmp-path',
		  'hrsh7th/cmp-buffer',
		  'hrsh7th/cmp-cmdline',
		  'L3MON4D3/LuaSnip',
	  }
  }
end)
