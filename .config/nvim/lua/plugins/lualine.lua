--- @type LazySpec
return {
	'nvim-lualine/lualine.nvim',
	dependencies = {
		'echasnovski/mini.icons',
		'linrongbin16/lsp-progress.nvim',
	},
	config = function()
		local get_path = function()
			local bufname = vim.api.nvim_buf_get_name(0)

			-- fix oil path
			if bufname:match('oil://') then
				local replace = bufname:gsub('oil://', '')
				return vim.fn.fnamemodify(replace, ':.:h')
			end

			local path = vim.fn.fnamemodify(bufname, ':.:h')

			if path == '.' then
				return ''
			end

			return path
		end

		require('lualine').setup({
			options = {
				icons_enabled = true,
				theme = 'auto',
				disabled_filetypes = { 'lazy', 'neo-tree', 'Outline', 'navstack', 'nvim-dap-view' },
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = false,
				section_separators = { left = "", right = "" },
				component_separators = { left = "" },
			},
			sections = {
				lualine_a = { { "mode", separator = { left = "", right = "" }, right_padding = 2 } },
				lualine_b = {
					{ 'filetype', icon_only = true, padding = { left = 1, right = 0 } },
					get_path,
					{
						'filename',
						padding = { left = 1, right = 1 },
						path = 0,
						file_status = true,
						newfile_status = true,
						symbols = {
							modified = '●',
							readonly = '',
							unnamed = '',
						}
					},
				},
				lualine_c = { { 'diagnostics' } },
				lualine_x = { { 'diagnostics', sources = { 'nvim_workspace_diagnostic' } } },
				lualine_y = {
					{ 'branch', padding = { left = 1, right = 1 } },
				},
				lualine_z = { { '[[]]' }, { 'vim.fn.fnamemodify(vim.fn.getcwd(), ":t")', path = 4, padding = { left = 0, right = 1 }, separator = { left = "", right = "" } } }
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