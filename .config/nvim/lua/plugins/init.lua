return {
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

	{
		'Exafunction/codeium.vim',
		event = 'BufEnter'
	},

	-- "gc" to comment visual regions/lines
	{
		"numToStr/Comment.nvim",
		event = "BufEnter",
		opts = {}
	},

	{ "stevearc/dressing.nvim", event = "VeryLazy" },

	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy"
	}

}