return {
	{
		"folke/snacks.nvim",
		---@type snacks.Config
		opts = {
			win = {
				backdrop = {
					blend = 85
				},
			},
			explorer = {
				replace_netrw = false,
			},
			picker = {
				layout = {
					default = {
						backdrop = false,
					}
				},
				formatters = {
					file = {
						filename_first = true,
					}
				},
				matcher = {
					frecency = true
				},
				win = {
					input = {
						keys = {
							["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
							["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
						}
					},
					list = {
						keys = {
							["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
							["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
						}
					}
				},
				previewers = {
					diff = {
						builtin = false,
						cmd = { "delta" }
					},
					git = {
						builtin = false,
					}
				}

			},
			input = {},
		},
		keys = {
			{
				"<leader>pe",
				function()
					Snacks.picker.explorer({
						win = {
							list = {
								keys = {
									["<c-u>"] = { "list_scroll_up", mode = { "i", "n" } },
									["<c-d>"] = { "list_scroll_down", mode = { "i", "n" } },
									["gx"] = { "explorer_open", mode = { "n" } },
								},
							}
						}
					})
				end,
				desc = "Explorer"
			},

			{ "<leader>pb", function() Snacks.picker.buffers() end,                                desc = "Buffers" },
			{ "<leader>pf", function() Snacks.picker.files({ ignored = true, hidden = true }) end, desc = "Find Files" },
			{ "<leader>pg", function() Snacks.picker.files({ ignored = false }) end,               desc = "Find Git Files" },
			{
				"<leader>ph",
				function()
					Snacks.picker.recent({
						filter = { cwd = true },
						matcher = {
							frecency = false,
						}
					})
				end,
				desc = "Recent"
			},
			{ "<leader><space>", function() Snacks.picker.smart() end,                                 desc = "Smart Find Files" },

			{ "<leader>pl",      function() Snacks.picker.resume() end,                                desc = "Resume" },
			{ "<leader>vh",      function() Snacks.picker.help() end,                                  desc = "Help" },

			{ "<leader>pc",      function() Snacks.picker.grep({ hidden = true }) end,                 desc = "Grep" },
			{ "<leader>pac",     function() Snacks.picker.grep({ ignored = true, hidden = true }) end, desc = "Grep in all files" },
			{ "<leader>pC",      function() Snacks.picker.grep_buffers() end,                          desc = "Grep Open Buffers" },

			{ "<leader>gh",      function() Snacks.picker.git_log_file() end,                          desc = "Git Log File" },

			-- LSP
			{ "gd",              function() Snacks.picker.lsp_definitions() end,                       desc = "Goto Definition" },
			{ "gr",              function() Snacks.picker.lsp_references() end,                        nowait = true,                  desc = "References" },
			{ "gD",              function() Snacks.picker.lsp_declarations() end,                      desc = "Goto Declaration" },
			{ "gi",              function() Snacks.picker.lsp_implementations() end,                   desc = "Goto Implementation" },
			{ "gt",              function() Snacks.picker.lsp_type_definitions() end,                  desc = "Goto T[y]pe Definition" },
		}
	}
}