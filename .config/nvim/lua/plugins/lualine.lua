--- @type LazySpec
return {
	'nvim-lualine/lualine.nvim',
	dependencies = {
		'echasnovski/mini.icons',
		'linrongbin16/lsp-progress.nvim',
	},
	config = function()
		require('lualine').setup({
			options = {
				icons_enabled = true,
				theme = 'auto',
				component_separators = { left = '', right = '' },
				section_separators = { left = '', right = '' },
				disabled_filetypes = { 'lazy', 'neo-tree', 'Outline', 'navstack', 'nvim-dap-view' },
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = false,
			},
			sections = {
				lualine_a = { '[[]]', { 'mode', padding = { left = 0, right = 1 } } },
				lualine_b = { 'location', 'progress' },
				lualine_c = { { 'branch', padding = { left = 2, right = 1 } }, { 'diagnostics', sources = { 'nvim_workspace_diagnostic' } } },
				lualine_x = {},
				lualine_y = { { 'diagnostics' }, { 'filetype', icon_only = true, padding = { left = 1, right = 0 } },
					{
						'filename',
						padding = { left = 0, right = 1 },
						path = 1,
						file_status = true,
						newfile_status = true,
						symbols = {
							modified = '●',
							readonly = '',
							unnamed = '',
						}
					}
				},
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