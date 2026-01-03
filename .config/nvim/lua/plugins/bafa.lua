return {
	'mistweaverco/bafa.nvim',
	version = '*',
	keys = {
		{ '<leader>pb', function() require('bafa.ui').toggle() end, desc = 'Toggle BAFA' },
	},
}