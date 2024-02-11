vim.keymap.set("n", "<leader>gl", ":FloatermNew lazygit<CR>");

local neogit = require('neogit')
neogit.setup {
	log_view = {
		kind = "vsplit",
	},
	commit_select_view = {
		kind = "vsplit",
	},
	git_services = {
		["github.com"] = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
		["gitlab.com"] = "https://gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
		["gitlab.itx.de"] = "https://gitlab.itx.de/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
	},
}

vim.keymap.set("n", "<leader>gs", function()
	neogit.open({ kind = "replace", cwd = vim.fn.expand('%:p:h') })
end)

vim.keymap.set('n', '<leader>gp', function()
	neogit.action('pull', 'from_pushremote')
end)

vim.keymap.set("n", "<leader>gP", function()
	neogit.action('push', 'to_pushremote')
end)
