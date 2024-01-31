require("neo-tree").setup({
	filesystem = {
		filtered_items = {
			visible = true,
			never_show = {
				".git",
				".DS_Store"
			},
		},
		follow_current_file = {
			enabled = true
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
	}
})

vim.keymap.set("n", "<leader>pv", ":Neotree toggle<cr>")
