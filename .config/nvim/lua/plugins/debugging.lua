--- @type LazySpec[]

return {
	{
		"mfussenegger/nvim-dap",
		keys = {
			{ "<F6>", function() require('dap').continue() end },
			{ "<Leader>b", function() require('dap').toggle_breakpoint() end },
			{ "<Leader>B", function() require('dap').set_breakpoint() end },
			{ "<Leader>lp", function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end },
		},
		config = function()
			local dap = require('dap')

			-- Configure Signs
			vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })

			dap.adapters.php = {
				type = "executable",
				command = "node",
				args = { os.getenv("HOME") .. "/debugger/vscode-php-debug/out/phpDebug.js" }
			}
			dap.configurations.php = {
				{
					type = "php",
					request = "launch",
					name = "Listen for Xdebug",
					port = 9000,
					pathMappings = {
						['/var/www/html'] = "${workspaceFolder}"
					}
				}
			}
			vim.keymap.set('n', '<F7>', function() dap.step_over() end)
			vim.keymap.set('n', '<F8>', function() dap.step_into() end)
			vim.keymap.set('n', '<F9>', function() dap.step_out() end)
			vim.keymap.set('n', '<Leader>dt', function() dap.terminate() end)
			vim.keymap.set('n', '<F10>', function() dap.run_to_cursor() end)
			vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
		end
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap" },
		event = "VeryLazy",
		config = function()
			local dap = require("dap")
			require("dapui").setup()
			local dapui = require("dapui")
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			vim.keymap.set('n', '<Leader>du', function() dapui.toggle() end)
		end
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		dependencies = { "mfussenegger/nvim-dap" },
		event = "VeryLazy",
		config = function()
			require("nvim-dap-virtual-text").setup()
		end
	},
	{
		"nvim-telescope/telescope-dap.nvim",
		dependencies = { "mfussenegger/nvim-dap" },
		event = "VeryLazy",
		config = function()
			require('telescope').load_extension('dap')
		end
	},
	{
		"leoluz/nvim-dap-go",
		event = "VeryLazy",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require('dap-go').setup()
		end
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		event = "VeryLazy",
		config = function()
			require("mason-nvim-dap").setup({
				ensure_installed = { "delve" },
				automatic_installation = true,
			})
		end
	}
}