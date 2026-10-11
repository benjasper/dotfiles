-- Diagnostic keymaps
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })

-- Center view when doing specific jumping actions
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- We want to interact with the system clipboard, but only when yanking.
-- This has the effect that deleted text won't go into the system clipboard, but only yanked text.
-- Ctrl p is used to paste the last yanked text.
vim.keymap.set("n", "<C-P>", "\"0p")
vim.keymap.set({ "v", "n" }, "y", "\"+y")

-- Copy relative file path with line number to clipboard
vim.keymap.set("n", "<leader>ll", function()
	local relpath = vim.fn.fnamemodify(vim.fn.expand('%'), ':.') -- relative path from cwd
	local line = vim.fn.line('.')
	local result = relpath .. ':' .. line
	vim.fn.setreg('+', result)
	vim.notify("Copied path '" .. result .. "' to clipboard")
end, { desc = "Copy relative file path with line number to clipboard" })