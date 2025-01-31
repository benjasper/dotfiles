--- @type LazySpec

return {
	"nvim-neo-tree/neo-tree.nvim",
	version = "*",
	cmd = "Neotree",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{
			"<leader>pv",
			function()
				require("neo-tree.command").execute({ toggle = true, reveal = true, position = "current" })
			end,
			"[P]roject [V]iew"
		},
		{
			"<leader>pV",
			function()
				require("neo-tree.command").execute({ toggle = true, reveal = true, position = "float" })
			end,
			"[P]roject [V]iew"
		}
	},
	init = function()
		if vim.fn.argc(-1) == 1 then
			local stat = vim.loop.fs_stat(vim.fn.argv(0))
			if stat and stat.type == "directory" then
				require("neo-tree")
			end
		end
	end,
	config = function()
		local events = require("neo-tree.events")

		require("neo-tree").setup({
			close_if_last_window = true,
			popup_border_style = "rounded",
			filesystem = {
				hijack_netrw_behavior = "open_current",
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					never_show = {
						".git",
						".DS_Store"
					},
				},
				follow_current_file = {
					enabled = false
				},
				window = {
					mappings = {
						["o"] = "system_open",
					},
				},
				commands = {
					system_open = function(state)
						local node = state.tree:get_node()
						local path = node:get_id()
						-- macOs: open file in default application in the background.
						vim.fn.jobstart({ "open", path }, { detach = true })
					end,
				},
			},
			event_handlers = {
				{
					event = "neo_tree_buffer_enter",
					handler = function()
						vim.opt_local.relativenumber = true
					end,
				},
				-- NOTE: restore alternate file for files opened with neo-tree
				{
					event = events.NEO_TREE_WINDOW_BEFORE_OPEN,
					handler = function()
						vim.w.neo_tree_before_open_visible_buffer = vim.api.nvim_get_current_buf()
					end,
				},
				{
					event = events.FILE_OPENED,
					handler = function()
						vim.fn.setreg("#", vim.w.neo_tree_before_open_visible_buffer)
					end,
				},
			}
		})

		vim.keymap.set("n", "<leader>pv", ":Neotree reveal position=current<cr>")
		vim.keymap.set("n", "<leader>pV", ":Neotree toggle reveal position=float<cr>")
	end
}