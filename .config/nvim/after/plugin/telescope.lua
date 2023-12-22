require('telescope').setup{}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>pg', builtin.git_files, {})
vim.keymap.set('n', '<leader>pc', builtin.live_grep, {})
vim.keymap.set('n', '<leader>po', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>cc', builtin.registers, {})
vim.keymap.set('n', '<leader>gb', builtin.git_branches, {})
vim.keymap.set('n', '<leader>ds', builtin.diagnostics, { buffer = 0 })

require('telescope').load_extension('fzf')
