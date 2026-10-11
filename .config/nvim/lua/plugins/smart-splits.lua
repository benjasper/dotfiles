return {
	"smart-splits-nvim/smart-splits.nvim",
	version = "^3.0.0",
	lazy = false,
	dependencies = {
		{
			"smart-splits-nvim/backend-ghostty",
			opts = {},
		},
	},
	opts = {
		mux = { backend = "smart-splits-backend-ghostty" },
		move = { at_edge = "stop" },
	},
	config = function(_, opts)
		local splits = require("smart-splits")
		splits.setup(opts)
		vim.keymap.set("n", "<C-h>", splits.move_cursor_left, { desc = "Move focus left (Neovim/Ghostty)" })
		vim.keymap.set("n", "<C-j>", splits.move_cursor_down, { desc = "Move focus down (Neovim/Ghostty)" })
		vim.keymap.set("n", "<C-k>", splits.move_cursor_up, { desc = "Move focus up (Neovim/Ghostty)" })
		vim.keymap.set("n", "<C-l>", splits.move_cursor_right, { desc = "Move focus right (Neovim/Ghostty)" })
		vim.keymap.set("n", "<C-Left>", splits.resize_left, { desc = "Resize split left" })
		vim.keymap.set("n", "<C-Down>", splits.resize_down, { desc = "Resize split down" })
		vim.keymap.set("n", "<C-Up>", splits.resize_up, { desc = "Resize split up" })
		vim.keymap.set("n", "<C-Right>", splits.resize_right, { desc = "Resize split right" })
	end,
}