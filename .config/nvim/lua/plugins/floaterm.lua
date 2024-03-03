--- @type LazySpec
return {
	{
		"voldikss/vim-floaterm",
		cmd = "FloatermNew",
		keys = {
			{ "<leader>gl", "<cmd>FloatermNew lazygit<cr>", desc = "Open lazygit" },
		},
		config = function()
			vim.g.floaterm_width = 0.95
			vim.g.floaterm_height = 0.95
		end,
	},
}