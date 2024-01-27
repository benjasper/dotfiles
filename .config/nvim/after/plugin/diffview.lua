require("diffview").setup({
	enhanced_diff_hl = true
})

vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>")
vim.keymap.set("n", "<leader>gc", ":DiffviewClose<CR>")

vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory %<CR>")
