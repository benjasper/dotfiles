return {
	{
		dir = "/Users/benni/.config/nvim/nightfall.nvim",
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
}