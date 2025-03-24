--- @type LazySpec
return {
	{
		"voldikss/vim-floaterm",
		cmd = "FloatermNew",
		keys = {
			{ "<leader>gl", function()
				local cwd = vim.fn.expand('%:p:h')
				if vim.bo.filetype == 'oil' then
					cwd = require('oil').get_current_dir()
				end

				vim.cmd('FloatermNew --cwd=' .. cwd .. ' lazygit')
			end, "[G]it [L]azy" },
		},
		config = function()
			vim.g.floaterm_width = 0.95
			vim.g.floaterm_height = 0.95
		end,
	},
}
