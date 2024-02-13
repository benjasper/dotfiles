require('telescope').setup {}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', function() builtin.find_files({ no_ignore = true, hidden = true }) end, {})
vim.keymap.set('n', '<leader>pg', function() builtin.find_files({ follow = false, hidden = true }) end, {})
local putils = require("telescope.previewers.utils")
require('telescope').setup {
	defaults = {
		preview = {
			-- 1) Do not show previewer for certain files
			filetype_hook = function(filepath, bufnr, opts)
				-- you could analogously check opts.ft for filetypes
				local excluded = vim.tbl_filter(function(ending)
					return filepath:match(ending)
				end, {
					".*%.min.js",
				})
				if not vim.tbl_isempty(excluded) then
					putils.set_preview_message(
						bufnr,
						opts.winid,
						string.format("I don't like %s files!",
							excluded[1]:sub(5, -1))
					)
					return false
				end
				return true
			end
		},
	}
}

vim.keymap.set('n', '<leader>pc', builtin.live_grep, {})
vim.keymap.set('n', '<leader>pac', function() builtin.live_grep({ additional_args = { "-u" } }) end, {})
vim.keymap.set('n', '<leader>pl', builtin.resume, {})

vim.keymap.set('n', '<leader>ph', function() builtin.oldfiles({ cwd_only = true }) end, {})

require('telescope').load_extension('fzf')
