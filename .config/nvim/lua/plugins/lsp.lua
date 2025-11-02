---@type LazySpec[]
return {
	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {},
		config = function()
			-- Disable logging, switch to debug when needed
			vim.lsp.set_log_level("error")

			vim.filetype.add({
				pattern = {
					-- Matches any filename containing "jenkins" (case-insensitive)
					-- Matches all files in a `jenkins/` directory with no extension
					[".*/jenkins/.+"] = function(path, _)
						if not path:match("%.[^/]+$") then
							return "groovy"
						end
					end,
					[".*Jenkinsfile"] = "groovy",
				},
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set({ "n", "v" }, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- NOTE: Other LSP mappings are in the `snacks` picker module

					-- Rename the variable under your cursor
					--  Most Language Servers support renaming across files, etc.
					map("<leader>r", vim.lsp.buf.rename, "[R]e[n]ame")

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

					-- Opens a popup that displays documentation about the word under your cursor
					--  See `:help K` for why this keymap
					map("K", vim.lsp.buf.hover, "Hover Documentation")

					-- Show signature help - commented out in favor of blink.cmp signature help
					-- map("gk", vim.lsp.buf.signature_help, "Show signature help")
					-- vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help)

					-- Highlight usages of the symbol under your cursor
					map("gh", vim.lsp.buf.document_highlight, "Highlight usages")
				end,
			})

			-- Add borders to floats
			vim.diagnostic.config({
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = '●',
						[vim.diagnostic.severity.WARN] = '●',
						[vim.diagnostic.severity.INFO] = '●',
						[vim.diagnostic.severity.HINT] = '●',
					}
				},
				float = { border = 'rounded', sources = { 'always' } },
				virtual_lines = {
					current_line = false,
				},
				-- NOTE: Try lsp lines for now
				virtual_text = false
				-- virtual_text = {
				-- 	source = 'if_many',
				-- 	spacing = 2,
				-- 	format = function(diagnostic)
				-- 		local diagnostic_message = {
				-- 			[vim.diagnostic.severity.ERROR] = diagnostic.message,
				-- 			[vim.diagnostic.severity.WARN] = diagnostic.message,
				-- 			[vim.diagnostic.severity.INFO] = diagnostic.message,
				-- 			[vim.diagnostic.severity.HINT] = diagnostic.message,
				-- 		}
				-- 		return diagnostic_message[diagnostic.severity]
				-- 	end,
				-- },
			})

			-- Show virtual lines for current line, else show virtual text
			vim.keymap.set('n', '<leader>k', function()
				vim.diagnostic.config({ virtual_lines = { current_line = true }, virtual_text = false })

				vim.api.nvim_create_autocmd('CursorMoved', {
					group = vim.api.nvim_create_augroup('line-diagnostics', { clear = true }),
					callback = function()
						vim.diagnostic.config({ virtual_lines = false, virtual_text = true })
						return true
					end,
				})
			end)

			-- Toggle virtual lines for current line
			vim.keymap.set("n", "<leader>dv", function()
				vim.diagnostic.config({
					virtual_lines = { current_line = not vim.diagnostic.config().virtual_lines.current_line },
				})
			end, { desc = "Toggle global virtual lines" })

			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				clangd = {
					filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
				},
				gopls = {
					settings = {
						gopls = {
							buildFlags = { "-tags=unittest,wireinject" },
							semanticTokens = true,
							staticcheck = true,
							-- gofumpt = true, -- Disabled for now
							analyses = {
								unusedparams = true,
								unusedresult = true,
								nilness = true,
								buildtag = true,
								nilerr = true,
								defers = true,
								loopclosure = true,
								printf = true,
								waitgroup = true,
								yield = true,
								httpresponse = true,
								ST1000 = false,
							},
						},
					},
				},
				rust_analyzer = {},
				vtsls = {},
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = {
								disable = { "missing-parameters", "missing-fields" }
							},
						},
					}
				},
				intelephense = {
					init_options = {
						licenceKey = vim.env.INTELEPHENSE_LICENSE_KEY,
					},
					settings = {
						intelephense = {
							files = {
								maxSize = 5000000,
								exclude = {
									"PackageArtifact.php"
								}
							}
						}
					}
				},
				jsonls = {},
				yamlls = {},
				tailwindcss = {},
				cssls = {},
				astro = {},
				biome = {},
				graphql = {
					filetypes = {
						"graphql",
						"typescript",
						"typescriptreact",
					}
				},
				taplo = {},
				html = {},
				eslint = {},
				templ = {},
				nil_ls = {},
				protols = {},
				sourcekit = {},
			}

			-- Register language servers
			for server_name, config in pairs(servers) do
				vim.lsp.config(server_name, config)
				vim.lsp.enable(server_name)
			end
		end,
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "snacks.nvim",        words = { "Snacks" } },
				{ path = "lazy.nvim",          words = { "LazyVim", "LazySpec" } },
			},
		},
	},
	{
		'L3MON4D3/LuaSnip',
		build = "make install_jsregexp",
		version = "v2.*",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
	{
		'saghen/blink.cmp',
		dependencies = { { 'L3MON4D3/LuaSnip', version = 'v2.*' } },

		-- use a release tag to download pre-built binaries
		version = '*',
		-- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			-- see the "default configuration" section below for full documentation on how to define
			-- your own keymap.
			keymap = {
				preset = 'none',
				['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
				['<C-e>'] = { 'hide' },
				['<C-z>'] = { 'select_and_accept' },

				['<Up>'] = { 'select_prev', 'fallback' },
				['<Down>'] = { 'select_next', 'fallback' },
				['<C-p>'] = { 'select_prev', 'fallback' },
				['<C-n>'] = { 'select_next', 'fallback' },

				['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
				['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

				['<Tab>'] = { 'snippet_forward', 'fallback' },
				['<S-Tab>'] = { 'snippet_backward', 'fallback' },

				['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
			},

			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- will be removed in a future release
				use_nvim_cmp_as_default = false,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = 'mono',
			},

			-- Use luasnip as a snippet engine for now, because of weird highlighting issues with vim.snippet https://www.reddit.com/r/neovim/comments/1fj1gbl/highlighted_text_when_expanding_snippets_using/
			snippets = {
				preset = 'luasnip',
				expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
				active = function(filter)
					if filter and filter.direction then
						return require('luasnip').jumpable(filter.direction)
					end
					return require('luasnip').in_snippet()
				end,
				jump = function(direction) require('luasnip').jump(direction) end,
			},
			cmdline = {
				enabled = false,
			},
			sources = {
				default = { 'lsp', 'path', 'snippets', 'buffer' },
			},

			-- experimental auto-brackets support
			completion = {
				accept = {
					auto_brackets = { enabled = true }
				},
				menu = { border = 'rounded', min_width = 15, max_height = 20 },
				documentation = {
					auto_show = true,
					window = { border = 'rounded' },
				},
			},

			fuzzy = { implementation = "prefer_rust_with_warning" },

			-- experimental signature help support
			signature = { enabled = true, window = { border = 'rounded', show_documentation = true } },
		},
		-- allows extending the enabled_providers array elsewhere in your config
		-- without having to redefine it
		opts_extend = { "sources.default" }
	},

	-- better diagnostics list and others
	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle", "Trouble" },
		opts = {},
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Workspace Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
			{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                  desc = "Location List (Trouble)" },
			{ "<leader>xQ", "<cmd>Trouble quickfix toggle<cr>",                 desc = "Quickfix List (Trouble)" },
		},
	},

	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "BufEnter",
		opts = { signs = false },
		keys = {
			{ "<leader>pt", function() Snacks.picker.todo_comments() end,                                          desc = "Todo" },
			{ "<leader>pT", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },

		}
	},

	{
		"j-hui/fidget.nvim",
		opts = {
			-- options
			notification = {
				override_vim_notify = true,
			}
		},
	},
	{
		'stevearc/conform.nvim',
		version = "*",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				-- Customize or remove this keymap to your liking
				"<leader>fm",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		config = function()
			local util = require("conform.util")

			require("conform").setup({
				default_format_opts = {
					lsp_format = "fallback",
					stop_after_first = true,
				},
				-- Define your formatters
				formatters_by_ft = {
					javascript = { "biome", "prettierd" },
					typescript = { "biome", "prettierd" },
					typescriptreact = { "biome", "prettierd" },
					astro = { "prettierd" },
					yaml = { "prettierd" },
					json = { "biome", "prettierd" },
					html = { "prettierd" },
					php = { "php_cs_fixer" },
					css = { "prettierd" },
					less = { "prettierd" },
					scss = { "prettierd" },
					nix = { "nixfmt" },
					sql = { "sql_formatter" },
				},
				formatters = {
					php_cs_fixer = {
						cwd = util.root_file({ ".php-cs-fixer.dist.php", ".php-cs-fixer.php" }),
						require_cwd = true,
						env = {
							PHP_CS_FIXER_IGNORE_ENV = true,
						},
					},
					prettierd = {
						require_cwd = true,
						-- Remove package.json from prettierd definition
						cwd = util.root_file({
							".prettierrc",
							".prettierrc.json",
							".prettierrc.yml",
							".prettierrc.yaml",
							".prettierrc.json5",
							".prettierrc.js",
							".prettierrc.cjs",
							".prettierrc.mjs",
							".prettierrc.toml",
							"prettier.config.js",
							"prettier.config.cjs",
							"prettier.config.mjs"
						})
					},
					biome = {
						require_cwd = true,
					},
					nixfmt = {},
				},
			})
		end,
		init = function()
			-- If you want the formatexpr, here is the place to set it
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},

	--[[ TODO: use when double K issue ist resolved {
		"lewis6991/hover.nvim",
		config = function()
			require("hover").setup {
				init = function()
					-- Require providers
					require("hover.providers.lsp")
					require('hover.providers.gh')
					-- require('hover.providers.gh_user')
					-- require('hover.providers.jira')
					require('hover.providers.dap')
					-- require('hover.providers.man')
					-- require('hover.providers.dictionary')
				end,
				preview_opts = {
					border = 'rounded'
				},
				preview_window = false,
				title = true,
			}

			-- Setup keymaps
			vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
		end
	} ]]
	{
		"hedyhli/outline.nvim",
		cmd = { "Outline" },
		keys = {
			{ "<leader>o", "<cmd>Outline<CR>", desc = "Toggle Outline" },
		},
		config = function()
			require("outline").setup {
				-- Your setup opts here (leave empty to use defaults)
			}
		end,
	},
}