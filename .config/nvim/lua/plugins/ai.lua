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
				ignore_filetypes = { NeogitStatus = true, ["Neo-tree"] = true, ["neo-tree-popup"] = true, TelescopePrompt = true, oil = true },
			})
		end,
	},
}