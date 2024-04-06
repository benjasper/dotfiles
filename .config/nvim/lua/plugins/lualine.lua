--- @type LazySpec
return {
	'nvim-lualine/lualine.nvim',
	dependencies = {
		'nvim-tree/nvim-web-devicons',
		'linrongbin16/lsp-progress.nvim',
	},
	config = function()
		local debuggingIntegration = {
			function()
				return require("dap").status()
			end,
			icon = { "", color = { fg = "#e7c664" } }, -- nerd icon.
			cond = function()
				if not package.loaded.dap then
					return false
				end
				local session = require("dap").session()
				return session ~= nil
			end,
		}

		local codeiumIntegration = {
			function()
				local status = ""
				local result = vim.api.nvim_call_function("codeium#GetStatusString", {})
				if result == nil or result == "   " or result == " * "
				then
					status = " "
				elseif result == " ON" then
					status = " "
				elseif result == "OFF" then
					status = " "
				elseif result == " 0 " then
					status = " "
				else
					status = " "
				end

				return "" .. status
			end,
			icon = { " " },
		}

		require('lualine').setup({
			options = {
				icons_enabled = true,
				theme = 'catppuccin',
				component_separators = { left = '', right = '' },
				section_separators = { left = '', right = '' },
				disabled_filetypes = { 'lazy', 'neo-tree' },
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = false,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				}
			},
			sections = {
				lualine_a = { '[[]]', { 'mode', padding = { left = 0, right = 1 } } },
				lualine_b = { 'location', 'progress' },
				lualine_c = { { 'branch', padding = { left = 2, right = 1 } }, 'diagnostics', '%=', debuggingIntegration },
				lualine_x = { codeiumIntegration },
				lualine_y = { { 'filetype', icon_only = true, padding = { left = 1, right = 0 } }, { 'filename', padding = { left = 0, right = 1 }, path = 1, file_status = true } },
				lualine_z = { { '[[]]' }, { 'vim.fn.fnamemodify(vim.fn.getcwd(), ":t")', path = 4, padding = { left = 0, right = 1 } } }
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { 'filename', path = 1 } },
				lualine_x = { 'location' },
				lualine_y = {},
				lualine_z = {}
			},
			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = {}
		})
	end
}