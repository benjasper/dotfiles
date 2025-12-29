--- @type LazySpec[]

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"jbyuki/one-small-step-for-vimkind",
			"theHamsta/nvim-dap-virtual-text",
			{
				"igorlfs/nvim-dap-view",
				-- let the plugin lazy load itself
				lazy = false,
				---@module 'dap-view'
				---@type dapview.Config
				opts = {
					auto_toggle = true,
					winbar = {
						sections = { "repl", "watches", "scopes", "breakpoints", "threads", "exceptions", "console" },
						default_section = "repl",
					},
					windows = {
						terminal = {
							hide = { "php", "go" },
						},
					}
				},
			},
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
			{ "<leader>du", function() require("dapui").toggle() end },
			{ "<leader>dn", function() require "osv".launch({ port = 8086 }) end },
		},
		config = function()
			local dap = require('dap')

			-- Function to update launch.json with ticket number
			local function update_launch_json_with_ticket()
				local launch_json_path = vim.fn.getcwd() .. "/.vscode/launch.json"

				-- Check if launch.json exists
				if vim.fn.filereadable(launch_json_path) == 0 then
					return
				end

				-- Read the current launch.json
				local file = io.open(launch_json_path, "r")
				if not file then
					return
				end

				local content = file:read("*all")
				file:close()

				-- Parse JSON
				local json = vim.json.decode(content)
				if not json or not json.configurations then
					return
				end

				-- Check if there's a PHP configuration
				local has_php_config = false
				for _, config in ipairs(json.configurations) do
					if config.type == "php" then
						has_php_config = true
						break
					end
				end

				if not has_php_config then
					return
				end

				-- Get ticket number from get-test-server command
				local handle = io.popen("get-test-server --ticket")
				if not handle then
					return
				end

				local ticket_output = handle:read("*a")
				handle:close()

				-- Extract ticket number (assuming it's a number)
				local ticket_number = ticket_output:match("(%d+)")
				if not ticket_number then
					vim.notify("Could not extract ticket number from get-test-server --ticket", vim.log.levels.WARN)
					return
				end

				-- Update path mappings in PHP configurations
				for _, config in ipairs(json.configurations) do
					if config.type == "php" and config.pathMappings then
						-- Create a new pathMappings table to preserve order and avoid issues
						local new_path_mappings = {}
						for server_path, local_path in pairs(config.pathMappings) do
							-- Replace the ticket number in the server path
							local new_server_path = server_path:gsub("/releases/%d+", "/releases/" .. ticket_number)
							new_path_mappings[new_server_path] = local_path
						end
						config.pathMappings = new_path_mappings
					end
				end

				-- Write the updated JSON back to file
				local updated_content = vim.json.encode(json)
				local pretty = vim.fn.system("jq .", updated_content)
				if pretty then
					file = io.open(launch_json_path, "w")
					if file then
						file:write(pretty)
						file:close()

						vim.notify("Updated launch.json with ticket number: " .. ticket_number, vim.log.levels.INFO)
					end
				end
			end

			dap.listeners.before.attach.change_branch = function()
				update_launch_json_with_ticket()
			end

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

			dap.adapters.nlua = function(callback, config)
				callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
			end

			dap.configurations.lua = {
				{
					type = 'nlua',
					request = 'attach',
					name = "Attach to running Neovim instance",
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
		end
	},
}
