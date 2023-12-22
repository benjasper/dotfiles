require('telescope').setup{}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', function () builtin.find_files({no_ignore=true}) end, {})
vim.keymap.set('n', '<leader>pg', builtin.git_files, {})
vim.keymap.set('n', '<leader>pc', builtin.live_grep, {})
vim.keymap.set('n', '<leader>po', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>cc', builtin.registers, {})
vim.keymap.set('n', '<leader>gb', builtin.git_branches, {})
vim.keymap.set('n', '<leader>ds', function ()
	return builtin.diagnostics({bufnr = 0})
end
, {})

require('telescope').load_extension('fzf')
