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
		"tpope/vim-fugitive",
		keys = {
			{ "<leader>gs", ":Git<CR>", desc = "Open Fugitive status" },
		},
		config = function()
			-- Define buffer-local keymaps when inside fugitive status window
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "fugitive",
				callback = function()
					local bufnr = vim.api.nvim_get_current_buf()
					local opts = { buffer = bufnr, remap = false }
					vim.keymap.set("n", "<leader>p", function()
						vim.cmd.Git('push')
					end, opts)

					-- rebase always
					vim.keymap.set("n", "<leader>P", function()
						vim.cmd.Git({ 'pull' })
					end, opts)

					-- quit status window
					vim.keymap.set("n", "q", function()
						vim.cmd.q()
					end, opts)
				end,
			})
		end,
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
