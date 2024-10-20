--- @type LazySpec[]

return {
	{
		"mfussenegger/nvim-dap",
		keys = {
			{ "<F6>",       function() require('dap').continue() end },
			{ "<Leader>b",  function() require('dap').toggle_breakpoint() end },
			{ "<Leader>B",  function() require('dap').set_breakpoint() end },
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
			vim.keymap.set('n', '<Leader>dh', function() require('dap.ui.widgets').hover() end)
			vim.keymap.set('n', '<Leader>dp', function() require('dap.ui.widgets').preview() end)

			-- TODO: This is not working yet, there is a problem restoring the keymap
			--[[ -- A keymapping to allow hover while a debug session is active
			local dap = require('dap')
			local api = vim.api
			local keymap_restore = {}
			dap.listeners.after['event_initialized']['me'] = function()
				for _, buf in pairs(api.nvim_list_bufs()) do
					local keymaps = api.nvim_buf_get_keymap(buf, 'n')
					for _, keymap in pairs(keymaps) do
						if keymap.lhs == "K" then
							table.insert(keymap_restore, keymap)
							api.nvim_buf_del_keymap(buf, 'n', 'K')
						end
					end
				end
				api.nvim_set_keymap(
					'n', 'K', '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
			end

			local revert_keymaps = function()
				for _, keymap in pairs(keymap_restore) do
					api.nvim_buf_set_keymap(
						keymap.buffer,
						keymap.mode,
						keymap.lhs,
						keymap.rhs,
						{ silent = keymap.silent == 1 }
					)
				end
				keymap_restore = {}
			end

			dap.listeners.after['event_terminated']['me'] = revert_keymaps
			dap.listeners.after['disconnect']['me'] = revert_keymaps ]]
		end
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
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
			dap.listeners.after.disconnect.dapui_config = function()
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
}