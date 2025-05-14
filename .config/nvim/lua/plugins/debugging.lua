--- @type LazySpec[]

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"theHamsta/nvim-dap-virtual-text",
			{
				"rcarriga/nvim-dap-ui",
				dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
			}
		},
		keys = {
			{ "<F6>",      function() require("dap").continue() end },
			{ "<Leader>b", function() require("dap").toggle_breakpoint() end },
			{
				"<Leader>B",
				function()
					vim.ui.input(
						{ prompt = "Breakpoint condition: " },
						function(input) require("dap").set_breakpoint(input) end
					)
				end,
				desc = "Conditional Breakpoint",
			},
			{ "<Leader>lp", function() require("dap").set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end },
			{
				"<leader>ds",
				function()
					require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes,
						{ border = "rounded" })
				end,
				desc = "DAP Scopes",
			},
			{ "<leader>du", function() require("dapui").toggle() end }
		},
		config = function()
			local dap = require('dap')

			-- Configure Signs
			local sign = vim.fn.sign_define
			sign("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
			sign("DapBreakpointCondition", { text = "", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
			sign("DapBreakpointRejected", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
			sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
			sign("DapStopped", { texthl = "DapStopped" })

			dap.adapters.php = {
				type = "executable",
				-- NOTE: This needs to be installed manually installed
				command = os.getenv("HOME") .. "/debugger/vscode-php-debug/run.sh",
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
			vim.keymap.set('n', '<Leader>dh', function() require('dap.ui.widgets').hover() end)
			vim.keymap.set('n', '<Leader>dp', function() require('dap.ui.widgets').preview() end)

			-- Setup virtual text
			require("nvim-dap-virtual-text").setup({
				virt_lines = true
			})

			-- Setup dap-go
			require('dap-go').setup({
				dap_configurations = {
					{
						type = "go",
						name = "Debug test (go.mod) with build flags",
						request = "launch",
						mode = "test",
						program = "./${relativeFileDirname}",
						buildFlags = require("dap-go").get_build_flags,
					},
				}
			})

			-- Setup dap ui
			local dapui = require("dapui")
			dapui.setup()

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
			dap.listeners.after.disconnect.dapui_config = function()
				dapui.close()
			end
		end
	},
}