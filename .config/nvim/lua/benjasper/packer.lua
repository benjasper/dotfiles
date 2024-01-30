-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.5',
		-- or                            , branch = '0.1.x',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}
	use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

	use { "catppuccin/nvim", as = "catppuccin" }

	use {
		'nvim-treesitter/nvim-treesitter',
		run = function()
			local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
			ts_update()
		end,
	}
	use 'windwp/nvim-ts-autotag'

	use('mbbill/undotree')
	use('nvim-tree/nvim-tree.lua')

	use 'voldikss/vim-floaterm'

	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		requires = {
			-- LSP Support
			{ 'neovim/nvim-lspconfig' },
			-- Autocompletion
			{ 'hrsh7th/nvim-cmp' },
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'L3MON4D3/LuaSnip' },
		}
	}
	use {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	}
	use 'WhoIsSethDaniel/mason-tool-installer.nvim'
	use {
		'creativenull/efmls-configs-nvim',
		tag = 'v1.*', -- tag is optional, but recommended
		requires = { 'neovim/nvim-lspconfig' },
	}

	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'nvim-tree/nvim-web-devicons', opt = true }
	}
	use {
		'linrongbin16/lsp-progress.nvim',
		config = function()
			require('lsp-progress').setup()
		end
	}
	use {
		'folke/trouble.nvim',
		requires = "nvim-tree/nvim-web-devicons",
	}

	use {
		'folke/todo-comments.nvim',
		requires = "nvim-lua/plenary.nvim",
	}

	use 'lewis6991/gitsigns.nvim'

	use 'nvim-tree/nvim-web-devicons'

	use 'ThePrimeagen/vim-be-good'

	use {
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		requires = { { "nvim-lua/plenary.nvim" } }
	}

	use 'Exafunction/codeium.vim'

	-- Debugging
	use 'mfussenegger/nvim-dap'
	use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }
	use 'theHamsta/nvim-dap-virtual-text'
	use 'nvim-telescope/telescope-dap.nvim'
	use 'leoluz/nvim-dap-go'

	use { "nvim-pack/nvim-spectre", requires = { "nvim-lua/plenary.nvim" } }

	use "sindrets/diffview.nvim"
end)
