return {
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		config = function()
			require('gitsigns').setup({
				sign_priority = 100,
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					-- Navigation
					vim.keymap.set('n', ']c', function()
						if vim.wo.diff then
							vim.cmd.normal({ ']c', bang = true })
						else
							gs.nav_hunk('next')
						end
					end)

					vim.keymap.set('n', '[c', function()
						if vim.wo.diff then
							vim.cmd.normal({ '[c', bang = true })
						else
							gs.nav_hunk('prev')
						end
					end)

					vim.keymap.set('n', '<leader>hs', gs.stage_hunk)
					vim.keymap.set('n', '<leader>hr', gs.reset_hunk)
					vim.keymap.set('n', '<leader>tb', gs.toggle_current_line_blame)
					-- vim.keymap.set('n', '<leader>td', gs.toggle_deleted) Collides with neotest
					vim.keymap.set('n', '<leader>hd', gs.diffthis)
					vim.keymap.set('n', '<leader>hp', gs.preview_hunk)
					vim.keymap.set('n', '<leader>hD', function() gs.diffthis('~') end)
					vim.keymap.set('n', '<leader>hb', function() gs.blame_line { full = true } end)
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
		},
		config = function()
			local neogit = require('neogit')
			neogit.setup({
				integrations = {
					diffview = false,
				},
				log_view = {
					kind = "vsplit",
				},
				commit_select_view = {
					kind = "vsplit",
				},
				commit_editor = {
					kind = "split",
					show_staged_diff = false
				},
				mappings = {
					commit_editor = {
						["<c-p>"] = "PrevMessage",
						["<c-n>"] = "NextMessage",
					},
				},
			})
		end,
		keys = {
			{
				"<leader>gs",
				function()
					local neogit = require('neogit')

					local cwd = vim.fn.expand('%:p:h')
					if vim.bo.filetype == 'oil' then
						cwd = require('oil').get_current_dir()
					end

					neogit.open({
						kind = "split_above_all",
						cwd = cwd
					})
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
		cmd = {
			"DiffviewOpen",
			"DiffviewClose",
			"DiffviewToggleFiles",
			"DiffviewFocusFiles",
			"DiffviewRefresh",
			"DiffviewFileHistory",
			"DiffviewOpenInWindow",
		},
		keys = {
			{
				"<leader>gd",
				":DiffviewOpen<CR>",
				"Opens the diffview"
			},
		}
	},
	{ 'akinsho/git-conflict.nvim', version = "*", opts = {} },
}