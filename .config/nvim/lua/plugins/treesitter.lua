---@type LazySpec[]

return {
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "main",
		build = function()
			local treesitter = require "nvim-treesitter"
			local should_install = {
				"bash",
				"c",
				"html",
				"lua",
				"markdown",
				"vim",
				"vimdoc",
				"php",
				"phpdoc",
				"go",
				"typoscript",
				"typescript",
				"javascript",
				"gitcommit",
				"regex",
				"comment",
			}

			treesitter.install(table.except(should_install, treesitter.get_installed()))
			treesitter.update()
		end,
		config = function()
			local treesitter = require "nvim-treesitter"

			vim.filetype.add({
				extension = {
					typoscript = 'typoscript',
					tsconfig = 'typoscript',
					gitconfig = 'gitconfig',
				}
			})

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local bufnr = args.buf
					local filetype = args.match

					local lang = vim.treesitter.language.get_lang(filetype)
					if not vim.tbl_contains(treesitter.get_available(), lang) then
						return
					end

					require("nvim-treesitter").install(lang):await(function()
						vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
						vim.treesitter.start(bufnr, lang)
					end)
				end
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		config = function()
			require("nvim-treesitter-textobjects").setup {
				select = {
					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,

					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						-- You can optionally set descriptions to the mappings (used in the desc parameter of
						-- nvim_buf_set_keymap) which plugins like which-key display
						["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
					},
					-- You can choose the select mode (default is charwise 'v')
					--
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * method: eg 'v' or 'o'
					-- and should return the mode ('v', 'V', or '<c-v>') or a table
					-- mapping query_strings to modes.
					selection_modes = {
						['@parameter.outer'] = 'v', -- charwise
						['@function.outer'] = 'V', -- linewise
						['@class.outer'] = '<c-v>', -- blockwise
					},
					-- If you set this to `true` (default is `false`) then any textobject is
					-- extended to include preceding or succeeding whitespace. Succeeding
					-- whitespace has priority in order to act similarly to eg the built-in
					-- `ap`.
					--
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * selection_mode: eg 'v'
					-- and should return true or false
					include_surrounding_whitespace = false,
				},
			}
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "VeryLazy",
		keys = {
			{ "<leader>gg", function() require("treesitter-context").go_to_context() end, desc = "Go to context" },
		},
		config = function()
			require("treesitter-context").setup({
				enable = true,
				max_lines = 1, -- How many lines the window should span. Values <= 0 mean no limit.
				trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: "inner", "outer"
				min_window_height = 0, -- Minimum number of lines to be in the window.
				separator = "─",
			})
		end,
	},
}