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
					blink_cmp = true,
					native_lsp = {
						enabled = true,
						underlines = {
							errors = { "undercurl" },
							hints = { "undercurl" },
							warnings = { "undercurl" },
							information = { "undercurl" },
						},
					},
					neotree = true,
					neogit = true,
					lsp_trouble = true,
					harpoon = true,
					grug_far = true,
				},
				color_overrides = {
					all = {
						base = "#1C1C2A",
						mantle = "#1C1C2A"
					}
				},
				custom_highlights = function(colors)
					local myBorder = "#4A4C5F"

					return {
						FloatTitle = { fg = "#ffffff" },
						TelescopeTitle = { fg = colors.text },
						NormalFloat = { bg = colors.base },
						Pmenu = { bg = colors.base },
						FloatBorder = { fg = myBorder },
						BlinkCmpDocBorder = { fg = myBorder },
						BlinkCmpSignatureHelpBorder = { fg = myBorder },
						BlinkCmpMenuBorder = { fg = myBorder },
						NeoTreeNormal = { bg = colors.base },
						NeoTreeFloatTitle = { bg = colors.base, fg = myBorder },
						NeoTreeFloatBorder = { bg = colors.base, fg = myBorder, bold = false },
						lualine_c_normal = { bg = colors.base, fg = colors.text },
					}
				end
			})

			vim.cmd.colorscheme("catppuccin")
		end,
	},
}