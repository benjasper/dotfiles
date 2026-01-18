return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		lazy = false,
		keys = {
			{ "<leader>pe", "<cmd>Neotree toggle<cr>", desc = "Toggle NeoTree" },
		},
		---@module 'neo-tree'
		---@type neotree.Config
		opts = {
			clipboard = {
				sync = "universal",
			},
			default_component_configs = {
				modified = {
					symbol = "●",
					highlight = "NeoTreeModified",
				},
			},
			filesystem = {
				hijack_netrw_behavior = "open_current",
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_ignored = false,
				},
				follow_current_file = {
					enabled = true, -- This will find and focus the file in the active buffer every time
					--               -- the current file is changed while the tree is open.
					leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
				},
				window = {
					mappings = {
						["<bs>"] = "",
						["."] = "",
						["/"] = "",
						["D"] = "fuzzy_finder_directory",
					},
				},
			},
			buffers = {
				follow_current_file = {
					enabled = true, -- This will find and focus the file in the active buffer every time
					--              -- the current file is changed while the tree is open.
					leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
				},
			}
		}
	}
}