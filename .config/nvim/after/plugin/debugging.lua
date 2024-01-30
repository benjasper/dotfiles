local dap = require('dap')

-- Configure Signs
vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })

require('telescope').load_extension('dap')

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

require('dap-go').setup()

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

require("nvim-dap-virtual-text").setup()

vim.keymap.set('n', '<F6>', function() dap.continue() end)
vim.keymap.set('n', '<F7>', function() dap.step_over() end)
vim.keymap.set('n', '<F8>', function() dap.step_into() end)
vim.keymap.set('n', '<F9>', function() dap.step_out() end)
vim.keymap.set('n', '<Leader>dt', function() dap.terminate() end)
vim.keymap.set('n', '<F10>', function() dap.run_to_cursor() end)
vim.keymap.set('n', '<Leader>b', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>B', function() dap.set_breakpoint() end)
vim.keymap.set('n', '<Leader>lp',
	function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
