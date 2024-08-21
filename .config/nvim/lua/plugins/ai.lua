---@type LazySpec[]

return {
	{
		"supermaven-inc/supermaven-nvim",
		event = "BufEnter",
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<C-y>",
					clear_suggestion = "<C-]>",
				},
				log_level = "off",
				ignore_filetypes = { NeogitStatus = true, ["Neo-tree"] = true, ["neo-tree-popup"] = true, TelescopePrompt = true },
			})
		end,
	},
}