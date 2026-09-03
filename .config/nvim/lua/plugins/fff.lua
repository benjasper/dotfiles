return {
	'dmtrKovalenko/fff',
	branch = 'main',
	build = function()
		-- downloads a prebuilt binary or falls back to cargo build
		require("fff.download").download_or_build_binary()
	end,
	opts = {
		title = 'Search',
		lazy_sync = false,
		prompt = ' ',
		debug = {
			enabled = false,
			show_scores = false,
		},
		layout = {
			prompt_position = 'top',
		},
		keymaps = {
			cycle_previous_query = '<C-k>',
			cycle_forward_query = '<C-j>',
		}
	},
	lazy = false, -- the plugin lazy-initialises itself
	keys = {
		{ "<leader>pf",  function() require('fff').find_files() end,                                           desc = 'FFFind files' },
		{ "<leader>pg",  function() require('fff').find_files() end,                                           desc = 'FFFind files' },
		{ "<leader>pc",  function() require('fff').live_grep({ grep = { modes = { 'plain', 'fuzzy' } } }) end, desc = 'LiFFFe grep' },
		{ "<leader>pac", function() require('fff').live_grep({ grep = { modes = { 'plain', 'fuzzy' } } }) end, desc = 'LiFFFe grep' },
	},
}