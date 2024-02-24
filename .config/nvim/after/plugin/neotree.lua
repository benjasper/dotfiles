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
			event = "file_opened",
			handler = function(file_path)
				-- close neo-tree on file open
				require("neo-tree.command").execute({ action = "close" })
			end
		},
		{
			event = "neo_tree_buffer_enter",
			handler = function()
				vim.opt_local.relativenumber = true
			end,
		},
	}
})

vim.keymap.set("n", "<leader>pv", ":Neotree reveal position=current<cr>")
vim.keymap.set("n", "<leader>pV", ":Neotree toggle reveal position=float<cr>")
