--- @type LazySpec[]

return {
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"j-hui/fidget.nvim",
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
			extensions = {
				mcphub = {
					callback = "mcphub.extensions.codecompanion",
					opts = {
						show_result_in_chat = false, -- Show the mcp tool result in the chat buffer
						make_vars = true,   -- make chat #variables from MCP server resources
						make_slash_commands = true, -- make /slash_commands from MCP server prompts
					},
				}
			}
		},
	}
}