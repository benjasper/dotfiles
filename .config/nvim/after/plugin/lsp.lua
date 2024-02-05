local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp_zero.default_keymaps({ buffer = bufnr })
	vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)
	vim.keymap.set('n', '<leader>fm', vim.lsp.buf.format)
	vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)

	vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help)
end)

lsp_zero.set_sign_icons({
	error = '✘',
	warn = '▲',
	hint = '⚑',
	info = '»'
})

local prettier = require('efmls-configs.formatters.prettier_d')
local efm_languages = {
	typescript = { prettier },
	typescriptreact = { prettier },
	javascript = { prettier },
	javascriptreact = { prettier },
	css = { prettier },
	scss = { prettier },
	less = { prettier },
	html = { prettier },
	yaml = { prettier },
	json = { prettier },
}

require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = {
		'tsserver', 'rust_analyzer', 'gopls', 'phpactor', 'tailwindcss', 'astro', 'cssls', 'efm', 'eslint', 'html',
		'lua_ls'
	},
	handlers = {
		lsp_zero.default_setup,
		tsserver = function()
			require('lspconfig').tsserver.setup({
				on_init = function(client)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentFormattingRangeProvider = false
				end
			})
		end,
		efm = function()
			require "lspconfig".efm.setup({
				filetypes = vim.tbl_keys(efm_languages),
				init_options = {
					documentFormatting = true,
					documentRangeFormatting = true
				},
				settings = {
					rootMarkers = { ".git/" },
					languages = efm_languages
				}
			})
		end,
	},
})

require('mason-tool-installer').setup {
	ensure_installed = {
		'prettierd'
	}
}

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
	-- preselect first item
	preselect = 'item',
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	completion = {
		completeopt = 'menu,menuone,noinsert'
	},
	mapping = cmp.mapping.preset.insert({
		-- `Enter` key to confirm completion
		['<CR>'] = cmp.mapping.confirm({ select = false }),

		-- Ctrl+Space to trigger completion menu
		['<C-Space>'] = cmp.mapping.complete(),

		-- Navigate between snippet placeholder
		['<C-f>'] = cmp_action.luasnip_jump_forward(),
		['<C-b>'] = cmp_action.luasnip_jump_backward(),

		-- Scroll up and down in the completion documentation
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),
	})
})

require 'todo-comments'.setup()

require('trouble').setup {}

vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)
vim.keymap.set("n", "gI", function() require("trouble").toggle("lsp_implementations") end)
