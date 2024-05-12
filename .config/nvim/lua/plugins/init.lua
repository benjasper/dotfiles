---@type LazySpec[]
return {
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

	-- "gc" to comment visual regions/lines
	{
		"numToStr/Comment.nvim",
		event = "BufEnter",
		opts = {},
		keys = {
			{ "<leader>xt", "<cmd>TodoTrouble<cr>", "Opens todos in a trouble list" }
		},
	},

	{ "stevearc/dressing.nvim", event = "VeryLazy" },

	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end
	},

	{
		"chrishrb/gx.nvim",
		keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
		cmd = { "Browse" },
		init = function()
			vim.g.netrw_nogx = 1 -- disable netrw gx
		end,
		dependencies = { "nvim-lua/plenary.nvim" },
		submodules = false, -- not needed, submodules are required only for tests

		-- you can specify also another config if you want
		config = function()
			require("gx").setup {
				open_browser_app = "open", -- specify your browser app; default for macOS is "open", Linux "xdg-open" and Windows "powershell.exe"
				-- open_browser_args = { "--background" }, -- specify any arguments, such as --background for macOS' "open".
				handlers = {
					plugin = true, -- open plugin links in lua (e.g. packer, lazy, ..)
					github = true, -- open github issues
					brewfile = true, -- open Homebrew formulaes and casks
					package_json = true, -- open dependencies from package.json
					search = false, -- search the web/selection on the web if nothing else is found
					tron = { -- custom handler to open Jira tickets (these have higher precedence than builtin handlers)
						handle = function(mode, line, _)
							local ticket = require("gx.helper").find(line, mode, "(TRON-%d+)")
							if ticket and #ticket < 20 then
								return "http://jira.company.com/browse/" .. ticket
							end
						end,
					},
				},
				handler_options = {
					search_engine = "google", -- you can select between google, bing, duckduckgo, and ecosia
				},
			}
		end,
	},

	{
		"shortcuts/no-neck-pain.nvim",
		version = "*",
		event = "VeryLazy",
		keys = {
			{
				"<leader>ct",
				"<cmd>:NoNeckPain<CR>",
				mode = { "n", "x" }
			}
		},
		config = function(self, opts)
			require("no-neck-pain").setup({
				width = 130,
			})
		end
	},
}