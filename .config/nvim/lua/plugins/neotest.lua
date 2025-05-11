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
			{ "olimorris/neotest-phpunit" },
			{ "mfussenegger/nvim-dap" },
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-golang")({
						runner = "gotestsum",
						go_test_args = { "-count=1", "-tags=unittest netgo" },
						go_list_args = { "-tags=unittest netgo" },
						dap_go_opts = {
							delve = {
								build_flags = { "-tags=unittest netgo" },
							},
						},
					}),
					require("neotest-phpunit")({
						phpunit_cmd = function()
							local path = vim.fn.getcwd()
							if (string.find(path, "docker-compose.yml")) then
								return {
									"docker",
									"compose",
									"exec",
									"php-fpm",
									"php",
									"vendor/bin/phpunit",
								}
							else
								return "vendor/bin/phpunit"
							end
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
			{ "<leader>ts", function() require("neotest").output.open() end,                 desc = "Show output of test" },
		}
	}
}