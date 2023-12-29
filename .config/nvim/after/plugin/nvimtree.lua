local api = require "nvim-tree.api"

require("nvim-tree").setup({
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = true,
	},
})

vim.keymap.set("n", "<leader>pv", api.tree.toggle)
vim.keymap.set("n", "<leader>ff", function()
	api.tree.find_file({open=true, focus=true})
end
)
