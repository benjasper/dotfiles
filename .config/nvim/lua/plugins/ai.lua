---@type LazySpec[]

return {
	{
		"supermaven-inc/supermaven-nvim",
		event = "InsertEnter",
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<C-j>",
					accept_word = "<C-h>",
				},
				log_level = "off",
				ignore_filetypes = { NeogitStatus = true, oil = true },
			})
		end,
	},
}