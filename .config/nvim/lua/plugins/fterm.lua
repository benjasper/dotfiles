--- @type LazySpec
return {
	{
		"numToStr/FTerm.nvim",
		cmd = { "FTerm", "Lazygit" },
		keys = {
			{ "<leader>gl", "<cmd>Lazygit<cr>", desc = "Open lazygit" },
		},
		config = function()
			local fterm = require('FTerm')
			local lazygit = fterm:new({
				ft = 'fterm_lazygit', -- You can also override the default filetype, if you want
				cmd = "lazygit",
				dimensions = {
					height = 0.9,
					width = 0.9
				},
				border = 'rounded',
			})

			vim.api.nvim_create_user_command('Lazygit', function()
				lazygit:toggle()
			end, { bang = true })

			require 'FTerm'.setup({})
		end,
	},
}
