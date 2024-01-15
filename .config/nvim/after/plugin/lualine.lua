require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = 'catppuccin',
		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' },
		disabled_filetypes = { 'packer', 'NvimTree' };
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
		lualine_b = { 'location', 'diagnostics' },
		lualine_c = { { 'branch', padding = { left = 2, right = 1 } }, '%=' },
		lualine_x = { require('lsp-progress').progress },
		lualine_y = { { 'filetype', icon_only = true, padding = { left = 1, right = 0 } }, { 'filename', file_status = true } },
		lualine_z = { { '[[]]' }, { 'vim.fn.fnamemodify(vim.fn.getcwd(), ":t")', path = 4, padding = { left = 0, right = 1 } } }
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { 'filename' },
		lualine_x = { 'location' },
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {}
}

-- listen lsp-progress event and refresh lualine
vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
	group = "lualine_augroup",
	pattern = "LspProgressStatusUpdated",
	callback = require("lualine").refresh,
})
