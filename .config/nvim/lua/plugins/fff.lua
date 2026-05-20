return {
	'dmtrKovalenko/fff.nvim',
	build = function()
		-- downloads a prebuilt binary or falls back to cargo build
		require("fff.download").download_or_build_binary()
	end,
	opts = {
		title = 'Search',
		prompt = ' ',
		debug = {
			enabled = false,
			show_scores = false,
		},
		layout = {
			prompt_position = 'top',
		},
	},
	lazy = false, -- the plugin lazy-initialises itself
	keys = {
		{ "<leader>pf",  function() require('fff').find_files() end,                                           desc = 'FFFind files' },
		{ "<leader>pg",  function() require('fff').find_files() end,                                           desc = 'FFFind files' },
		{ "<leader>pc",  function() require('fff').live_grep({ grep = { modes = { 'fuzzy', 'plain' } } }) end, desc = 'LiFFFe grep' },
		{ "<leader>pac", function() require('fff').live_grep({ grep = { modes = { 'fuzzy', 'plain' } } }) end, desc = 'LiFFFe grep' },
	},
}