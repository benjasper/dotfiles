return {
	{ -- You can easily change to a different colorscheme.
		-- Change the name of the colorscheme plugin below, and then
		-- change the command in the config to whatever the name of that colorscheme is
		--
		-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				integrations = {
					cmp = true,
					native_lsp = {
						enabled = true,
					},
					mason = true,
					neotree = true,
					neogit = true,
					lsp_trouble = true,
					harpoon = true,
					grug_far = true,
				},
			})

			vim.cmd.colorscheme("catppuccin")
		end,
	},
}