--- @type LazySpec[]

return {
	{
		"olimorris/codecompanion.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"j-hui/fidget.nvim",
			{
				"Davidyz/VectorCode",
				version = "*",
				build = "pipx install vectorcode",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
		},
		opts = {
			adapters = {
				gemini = function()
					return require("codecompanion.adapters").extend("gemini", {
						env = {
							api_key = "AIzaSyAr7EfbLTK-ln3SKcZofESl_3RmJDwxo9I",
						},
					})
				end,
			},
			strategies = {
				chat = {
					adapter = "gemini",
					tools = {
						vectorcode = {
							description = "Run VectorCode to retrieve the project context.",
							callback = function()
								return require("vectorcode.integrations").codecompanion.chat.make_tool()
							end,
						}
					},
				},
				inline = {
					adapter = "gemini",
				},
			},
		},
	}
}
