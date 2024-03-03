--- @type LazySpec
return {
	'nvim-pack/nvim-spectre',
	dependencies = {
		'nvim-lua/plenary.nvim',
	},
	keys = {
		{ "<leader>R", function() require('spectre').toggle() end, desc = "Spectre" },
		{
			"<leader>sw",
			function()
				require('spectre').open_visual({ select_word = true })
			end,
			desc = "Search current word"
		},

		{
			"<leader>sw",
			function()
				require('spectre').open_visual({ select_word = true })
			end,
			desc = "Search current word",
			mode = "v"
		},

		{
			"<leader>sf",
			function()
				require('spectre').open_file_search({ select_word = true })
			end,
			desc = "Search on current file"
		},

	}
}