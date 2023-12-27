require('gitsigns').setup({
	on_attach = function (bufnr)
		local gs = package.loaded.gitsigns

		vim.keymap.set('n', '<leader>hs', gs.stage_hunk)
		vim.keymap.set('n', '<leader>hr', gs.reset_hunk)
		vim.keymap.set('n', '<leader>tb', gs.toggle_current_line_blame)
		vim.keymap.set('n', '<leader>hd', gs.diffthis)
		vim.keymap.set('n', '<leader>hD', function() gs.diffthis('~') end)
		vim.keymap.set('n', '<leader>td', gs.toggle_deleted)
	end
})


