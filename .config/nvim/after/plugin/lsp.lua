local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp_zero.default_keymaps({ buffer = bufnr })
	vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)
	vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)
	vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
end)

local prettier = require('efmls-configs.formatters.prettier_d')
local efm_languages = {
	typescript = { prettier },
	typescriptreact = { prettier },
	javascript = { prettier },
	javascriptreact = { prettier },
}

require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = {
		'tsserver', 'rust_analyzer', 'gopls', 'phpactor', 'tailwindcss', 'astro', 'cssls', 'efm', 'eslint', 'html'
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
