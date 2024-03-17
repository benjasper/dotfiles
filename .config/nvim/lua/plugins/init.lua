---@type LazySpec[]
return {
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

	{
		'Exafunction/codeium.vim',
		event = 'BufEnter',
		config = function()
			vim.g.codeium_disable_bindings = 1

			vim.keymap.set('i', '<C-y>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
			vim.keymap.set('i', '<c-.>', function() return vim.fn['codeium#CycleCompletions'](1) end,
				{ expr = true, silent = true })
			vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end,
				{ expr = true, silent = true })
			vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
		end
	},

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
	}

}