return {
	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VeryLazy",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- If encountering errors, see telescope-fzf-native README for install instructions
				"nvim-telescope/telescope-fzf-native.nvim",

				-- `build` is used to run some command when the plugin is installed/updated.
				-- This is only run then, not every time Neovim starts up.
				build = "make",

				-- `cond` is a condition used to determine whether this plugin should be
				-- installed and loaded.
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons" },
			{
				"nvim-telescope/telescope-live-grep-args.nvim",
			},
		},
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")
			local lga_actions = require("telescope-live-grep-args.actions")

			vim.keymap.set("n", "<leader>pf", function()
				builtin.find_files({ no_ignore = true, hidden = true, path_display = { "truncate" } })
			end, {})
			vim.keymap.set("n", "<leader>pg", function()
				builtin.find_files({ follow = false, hidden = true, path_display = { "truncate" } })
			end, {})
			local putils = require("telescope.previewers.utils")
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = { ".git/" },
					preview = {
						-- Do not show previewer for certain files
						filetype_hook = function(filepath, bufnr, opts)
							-- you could analogously check opts.ft for filetypes
							local excluded = vim.tbl_filter(function(ending)
								return filepath:match(ending)
							end, {
								".*%.min.js",
							})
							if not vim.tbl_isempty(excluded) then
								putils.set_preview_message(
									bufnr,
									opts.winid,
									string.format("I don't like %s files!", excluded[1]:sub(5, -1))
								)
								return false
							end
							return true
						end,
					},
				},
				extensions = {
					live_grep_args = {
						-- define mappings, e.g.
						mappings = { -- extend mappings
							i = {
								["<C-k>"] = lga_actions.quote_prompt(),
								["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
							},
						},
					}
				}
			})

			vim.keymap.set("n", "<leader>pc", telescope.extensions.live_grep_args.live_grep_args, {})
			vim.keymap.set("n", "<leader>pac", function()
				telescope.extensions.live_grep_args.live_grep_args({ additional_args = { "-u" } })
			end, {})
			vim.keymap.set("n", "<leader>pl", builtin.resume, {})

			vim.keymap.set("n", "<leader>ph", function()
				builtin.oldfiles({ cwd_only = true })
			end, {})

			-- Enable telescope extensions, if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "live_grep_args")

			vim.keymap.set("n", "<leader>/", function()
				-- You can pass additional configuration to telescope to change theme, layout, etc.
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
		end,
	},
}