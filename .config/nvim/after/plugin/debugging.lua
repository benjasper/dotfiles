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

-- K to hover while session is active
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

dap.listeners.after['event_terminated']['me'] = function()
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

require('dap-go').setup()

require("dapui").setup()
local dap, dapui = require("dap"), require("dapui")
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
