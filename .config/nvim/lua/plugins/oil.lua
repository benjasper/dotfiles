return {
	{
		'stevearc/oil.nvim',
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		-- Optional dependencies
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
		-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
		version = "*",
		lazy = false,
		keys = {
			{
				"<leader>pv",
				function()
					require("oil").open()
				end,
				"[P]roject [V]iew"
			},
			{
				"-",
				function()
					require("oil").open()
				end,
				"[P]roject [V]iew"
			},

		},
		config = function()
			-- Declare a global function to retrieve the current directory
			function _G.get_oil_winbar()
				local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
				local dir = require("oil").get_current_dir(bufnr)
				if dir then
					return vim.fn.fnamemodify(dir, ":~")
				else
					-- If there is no current directory (e.g. over ssh), just show the buffer name
					return vim.api.nvim_buf_get_name(0)
				end
			end

			require("oil").setup(
				{
					-- Id is automatically added at the beginning, and name at the end
					-- See :help oil-columns
					columns = {
						"icon",
					},
					-- Window-local options to use for oil buffers
					delete_to_trash = true,
					-- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
					skip_confirm_for_simple_edits = true,
					-- Selecting a new/moved/renamed file or directory will prompt you to save changes first
					-- (:help prompt_save_on_select_new_entry)
					prompt_save_on_select_new_entry = true,
					-- Oil will automatically delete hidden buffers after this delay
					-- You can set the delay to false to disable cleanup entirely
					-- Note that the cleanup process only starts when none of the oil buffers are currently displayed
					cleanup_delay_ms = 2000,
					lsp_file_methods = {
						-- Enable or disable LSP file operations
						enabled = true,
						-- Time to wait for LSP file operations to complete before skipping
						timeout_ms = 1000,
						-- Set to true to autosave buffers that are updated with LSP willRenameFiles
						-- Set to "unmodified" to only save unmodified buffers
						autosave_changes = true,
					},
					-- Constrain the cursor to the editable parts of the oil buffer
					-- Set to `false` to disable, or "name" to keep it on the file names
					constrain_cursor = "name",
					-- Set to true to watch the filesystem for changes and reload oil
					watch_for_changes = true,
					keymaps = {
						["tab"] = "actions.preview",
						["g?"] = { "actions.show_help", mode = "n" },
						["<CR>"] = "actions.select",
						["<C-s>"] = { "actions.select", opts = { vertical = true } },
						["<C-v>"] = { "actions.select", opts = { horizontal = true } },
						["q"] = { "actions.close", mode = "n" },
						["<C-r>"] = "actions.refresh",
						["-"] = { "actions.parent", mode = "n" },
						["_"] = { "actions.open_cwd", mode = "n" },
						["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
						["gs"] = { "actions.change_sort", mode = "n" },
						["gx"] = "actions.open_external",
						["g."] = { "actions.toggle_hidden", mode = "n" },
					},
					use_default_keymaps = false,
					view_options = {
						-- Show files and directories that start with "."
						show_hidden = true,
						-- This function defines what will never be shown, even when `show_hidden` is set
						is_always_hidden = function(name, _)
							-- DS_Store
							return name:match('^%.DS_Store$')
						end,
						sort = {
							-- sort order can be "asc" or "desc"
							-- see :help oil-columns to see which columns are sortable
							{ "type", "asc" },
							{ "name", "asc" },
						},
					},
					buf_options = {
						buflisted = true,
					},
					win_options = {
						signcolumn = "yes:2",
						winbar = "%!v:lua.get_oil_winbar()",
					}
				}
			)
		end,
	},
	{
		"refractalize/oil-git-status.nvim",

		dependencies = {
			"stevearc/oil.nvim",
		},

		config = true,
	},
}