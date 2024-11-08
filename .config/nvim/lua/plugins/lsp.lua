---@type LazySpec[]
return {
	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {},
		config = function()
			-- Disable logging, switch to debug when needed
			vim.lsp.set_log_level("off")

			vim.fn.sign_define("DiagnosticSignError",
				{ text = " ", texthl = "DiagnosticSignError" })
			vim.fn.sign_define("DiagnosticSignWarn",
				{ text = " ", texthl = "DiagnosticSignWarn" })
			vim.fn.sign_define("DiagnosticSignInfo",
				{ text = " ", texthl = "DiagnosticSignInfo" })
			vim.fn.sign_define("DiagnosticSignHint",
				{ text = "󰌵", texthl = "DiagnosticSignHint" })

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Jump to the definition of the word under your cursor.
					--  This is where a variable was first declared, or where a function is defined, etc.
					--  To jump back, press <C-T>.
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

					-- Find references for the word under your cursor.
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

					-- Jump to the implementation of the word under your cursor.
					--  Useful when your language has ways of declaring types without an actual implementation.
					map("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

					-- Jump to the type of the word under your cursor.
					--  Useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					map("gt", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					--
					-- This is not Goto Definition, this is Goto Declaration.
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

					-- Rename the variable under your cursor
					--  Most Language Servers support renaming across files, etc.
					map("<leader>r", vim.lsp.buf.rename, "[R]e[n]ame")

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

					-- Opens a popup that displays documentation about the word under your cursor
					--  See `:help K` for why this keymap
					map("K", vim.lsp.buf.hover, "Hover Documentation")

					-- Show signature help
					map("gk", vim.lsp.buf.signature_help, "Show signature help")
					vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help)

					-- Highlight usages of the symbol under your cursor
					map("gh", vim.lsp.buf.document_highlight, "Highlight usages")
				end,
			})

			-- Add borders to floats
			vim.diagnostic.config({
				float = { border = 'rounded', sources = { 'always' } },
			})

			vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
				vim.lsp.handlers.hover,
				{ border = 'rounded' }
			)

			vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
				vim.lsp.handlers.signature_help,
				{ border = 'rounded' }
			)

			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				clangd = {},
				gopls = {},
				rust_analyzer = {},
				ts_ls = {},
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								-- Tells lua_ls where to find all the Lua files that you have loaded
								-- for your neovim configuration.
								library = {
									"${3rd}/luv/library",
									unpack(vim.api.nvim_get_runtime_file("", true)),
								},
								-- If lua_ls is really slow on your computer, you can try this instead:
								-- library = { vim.env.VIMRUNTIME },
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
				intelephense = {
					init_options = {
						-- NOTE: Enter licenceKey for intelephense here when on new machine
						licenceKey = "xxx",
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
				gitlab_ci_ls = {},
				nil_ls = {},
			}

			-- Register language servers with lspconfig
			local lspconfig = require("lspconfig")
			for server_name, server in pairs(servers) do
				server.capabilities = require('blink.cmp').get_lsp_capabilities(server.capabilities)
				lspconfig[server_name].setup(server)
			end
		end,
	},

	{
		'saghen/blink.cmp',
		lazy = false, -- lazy loading handled internally
		-- optional: provides snippets for the snippet source
		dependencies = 'rafamadriz/friendly-snippets',

		-- use a release tag to download pre-built binaries
		version = 'v0.*',
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
			keymap = { preset = 'enter' },

			highlight = {
				-- sets the fallback highlight groups to nvim-cmp's highlight groups
				-- useful for when your theme doesn't support blink.cmp
				-- will be removed in a future release, assuming themes add support
				use_nvim_cmp_as_default = false,
			},
			windows = {
				autocomplete = {
					max_height = 15,
					min_width = 20,
					border = 'rounded',
				},

				documentation = {
					border = 'rounded',
					auto_show = true,
				},

				signature_help = {
					border = 'rounded',
				},
			},

			-- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- adjusts spacing to ensure icons are aligned
			nerd_font_variant = 'mono',

			-- experimental auto-brackets support
			accept = { auto_brackets = { enabled = true } },

			-- experimental signature help support
			trigger = { signature_help = { enabled = true } }
		}
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
			{
				"[q",
				function()
					if require("trouble").is_open() then
						require("trouble").previous({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cprev)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = "Previous trouble/quickfix item",
			},
			{
				"]q",
				function()
					if require("trouble").is_open() then
						require("trouble").next({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cnext)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = "Next trouble/quickfix item",
			},
		},
	},

	-- Highlight todo, notes, etc in comments
	{ "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = { signs = false } },

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
				},
				formatters = {
					php_cs_fixer = {
						cwd = util.root_file({ ".php-cs-fixer.dist.php", ".php-cs-fixer.php" }),
						require_cwd = true
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