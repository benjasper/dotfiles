---@type LazySpec[]
return {
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

	-- "gc" to comment visual regions/lines
	{
		"numToStr/Comment.nvim",
		event = "BufEnter",
		opts = {},
		keys = {
			{ "<leader>xt", "<cmd>TodoTrouble<cr>", "Opens todos in a trouble list" }
		},
	},

	{ "stevearc/dressing.nvim", event = "VeryLazy" },

	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end
	},

	{
		"shortcuts/no-neck-pain.nvim",
		version = "*",
		event = "VeryLazy",
		keys = {
			{
				"<leader>nn",
				"<cmd>:NoNeckPain<CR>",
				mode = { "n", "x" }
			}
		},
		config = function(self, opts)
			require("no-neck-pain").setup({
				width = 160,
			})
		end
	},
}