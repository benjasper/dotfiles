--- @type LazySpec
return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			-- Providers
			{ "fredrikaverpil/neotest-golang", version = "*" },
			{ "olimorris/neotest-phpunit" }
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-golang")({
						runner = "gotestsum",
						-- TODO: this is not working yet
						-- gotestsum_args = { "--format=standard-verbose", "-tags=unittest,netgo" },
					}),
					require("neotest-phpunit")({
						phpunit_cmd = function()
							-- TODO: Maybe switch to docker container
							return "vendor/bin/phpunit"
						end
					}),
				},
			})
		end,
		keys = {
			{ "<leader>tt", function() require("neotest").run.run() end,                     desc = "Run nearest test" },
			{ "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Run test with debugging" },
			{ "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,   desc = "Run test file" },
			{ "<leader>to", function() require("neotest").summary.toggle() end,              desc = "Run test summary" },
		}
	}
}