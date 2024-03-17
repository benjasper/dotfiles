return {
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		config = function()
			require('gitsigns').setup({
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					vim.keymap.set('n', '<leader>hs', gs.stage_hunk)
					vim.keymap.set('n', '<leader>hr', gs.reset_hunk)
					vim.keymap.set('n', '<leader>tb', gs.toggle_current_line_blame)
					vim.keymap.set('n', '<leader>td', gs.toggle_deleted)
					vim.keymap.set('n', '<leader>hd', gs.diffthis)
					vim.keymap.set('n', '<leader>hp', gs.preview_hunk)
					vim.keymap.set('n', '<leader>hD', function() gs.diffthis('~') end)
					vim.keymap.set('n', '<leader>hb', function() gs.blame_line{full=true} end)
				end,
				current_line_blame_opts = {
					delay = 0
				}
			})
		end
	},

	{
		"NeogitOrg/neogit",
		cmd = "Neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration

			"nvim-telescope/telescope.nvim", -- optional
		},
		config = function()
			local neogit = require('neogit')
			neogit.setup({
				log_view = {
					kind = "vsplit",
				},
				commit_select_view = {
					kind = "vsplit",
				},
				commit_editor = {
					kind = "split",
				},
				git_services = {
					["github.com"] = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
					["gitlab.com"] =
					"https://gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
					["gitlab.itx.de"] =
					"https://gitlab.itx.de/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
				},
			})
		end,
		keys = {
			{
				"<leader>gs",
				function()
					local neogit = require('neogit')
					neogit.open({ kind = "replace", cwd = vim.fn.expand('%:p:h') })
				end,
				"[G]it [S]tatus"
			},
			{
				"<leader>gp",
				function()
					local neogit = require('neogit')
					neogit.action('pull', 'from_pushremote')
				end,
				"[G]it [p]ull"
			},
			{
				"<leader>gP",
				function()
					local neogit = require('neogit')
					neogit.action('push', 'to_pushremote')
				end,
				"[G]it [P]ush"
			}
		}
	},

	{
		"sindrets/diffview.nvim",
		config = function()
			require("diffview").setup({
				enhanced_diff_hl = true
			})
		end,
		keys = {
			{
				"<leader>gd",
				":DiffviewOpen<CR>",
				"Opens the diffview"
			},
			{
				"<leader>gc",
				":DiffviewClose<CR>",
				"Closes the diffview"
			}
		}
	}
}