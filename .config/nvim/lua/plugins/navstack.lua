return {
	'benjasper/navstack.nvim',
	-- dir = "~/Workspace/navstack.nvim",
	dependencies = {
		{ 'echasnovski/mini.icons', version = '*' }, -- or { 'nvim-tree/nvim-web-devicons', version = '*' }
	},
	event = "VeryLazy",
	config = function()
		local navstack = require("navstack")

		local width = 40

		navstack.setup({
			win_type = "float",
			sidebar = {
				show_current = true,
				open_on_start = true
			},
			direct_jump_as_new_entry = false,
			quit_when_last_window = true,
			window_float = {
				width = width,
				col = vim.o.columns - width,
				height = 18,
			}
		})

		for i = 1, 9 do
			vim.keymap.set("n", "<leader>" .. tostring(i), function() navstack.jump_to(i) end,
				{ noremap = true, silent = true })
		end

		vim.keymap.set("n", "<C-p>", function() navstack.jump_to_previous() end, { noremap = true, silent = true })
		vim.keymap.set("n", "<C-n>", function() navstack.jump_to_next() end, { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>n", function() navstack.toggle_sidebar() end, { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>cn", function() navstack.clear() end, { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>pn", function() navstack.toggle_pin() end, { noremap = true, silent = true })
	end
}