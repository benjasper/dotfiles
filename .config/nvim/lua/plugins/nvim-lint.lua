return {
	"mfussenegger/nvim-lint",
	keys = {
		{ "<leader>xl", function() require("lint").try_lint() end, desc = "Lint current buffer" },
	},
	config = function()
		vim.api.nvim_create_user_command("LinterInfo", function()
			local runningLinters = table.concat(require("lint").get_running(), "\n")
			vim.notify(runningLinters, vim.log.levels.INFO, { title = "nvim-lint" })
		end, {})

		require("lint").linters_by_ft = {
			go = { 'golangcilint' },
		}
	end,
}