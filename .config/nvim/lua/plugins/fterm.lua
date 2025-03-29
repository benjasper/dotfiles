--- @type LazySpec
return {
	{
		"numToStr/FTerm.nvim",
		keys = {
			{ "<leader>gl", function()
				local fterm = require('FTerm')
				local cwd = vim.fn.expand('%:p:h')
				if vim.bo.filetype == 'oil' then
					cwd = require('oil').get_current_dir()
				end

				local lazygit = fterm:new({
					ft = 'fterm_lazygit', -- You can also override the default filetype, if you want
					cmd = "lazygit",
					dimensions = {
						height = 0.9,
						width = 0.9
					},
					border = 'rounded',
				})

				lazygit:toggle()
			end, "[G]it [L]azy" },
		},
		config = function()
			require 'FTerm'.setup({})
		end,
	},
}