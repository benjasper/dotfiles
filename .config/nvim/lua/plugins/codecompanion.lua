--- @type LazySpec[]

return {
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"j-hui/fidget.nvim",
			{
				"Davidyz/VectorCode",
				version = "*",
				build = "pipx install vectorcode || pipx upgrade vectorcode",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
		},
		cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionInline", "CodeCompanionActions" },
		keys = {
			{ "<leader>cc", "<cmd>CodeCompanionChat<cr>", desc = "CodeCompanion: Open" },
		},
		opts = {
			adapters = {
				gemini = function()
					return require("codecompanion.adapters").extend("gemini", {
						env = {
							api_key = vim.env.GEMINI_API_KEY,
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