return {
	{
		"benjasper/nightfall.nvim",
		-- dir = "~/Workspace/nightfall.nvim/",
		lazy = false,
		priority = 1000,
		config = function()
			-- Ensure the module can be required
			local status_ok, nightfall = pcall(require, "nightfall")
			if not status_ok then
				vim.notify("nightfall module not found!", vim.log.levels.ERROR)
				return
			end

			-- Setup the colorscheme
			nightfall.setup()

			vim.cmd([[colorscheme nightfall]])
		end,
	},
	{ -- You can easily change to a different colorscheme.
		-- Change the name of the colorscheme plugin below, and then
		-- change the command in the config to whatever the name of that colorscheme is
		--
		-- If you want to see what colorschemes are already installed
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				integrations = {
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
					neogit = true,
					lsp_trouble = true,
					harpoon = true,
					grug_far = true,
					snacks = { enabled = true },
					neotest = true,
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
						NormalFloat = { bg = colors.base },
						Pmenu = { bg = colors.base },
						FloatBorder = { fg = myBorder },
						BlinkCmpDocBorder = { fg = myBorder },
						BlinkCmpSignatureHelpBorder = { fg = myBorder },
						BlinkCmpMenuBorder = { fg = myBorder },
						lualine_c_normal = { bg = colors.base, fg = colors.text },
					}
				end
			})

			-- vim.cmd.colorscheme("catppuccin")
		end,
	},
}