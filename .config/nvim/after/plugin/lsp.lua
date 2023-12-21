local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
		-- see :help lsp-zero-keybindings
		-- to learn the available actions
		lsp_zero.default_keymaps({buffer = bufnr})
        vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)
        vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)
        vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action)
end)

require('mason').setup({})
require('mason-lspconfig').setup({
		ensure_installed = {'tsserver', 'rust_analyzer', 'gopls', 'phpactor', 'tailwindcss', 'astro'},
		handlers = {
				lsp_zero.default_setup,
                tsserver = function ()
                       require('lspconfig').tsserver.setup({
                               on_init = function(client)
                                       client.server_capabilities.documentFormattingProvider = false
                                       client.server_capabilities.documentFormattingRangeProvider = false
                               end
                       })
                end,
		},
})

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
		-- preselect first item
		preselect = 'item',
		completion = {
				completeopt = 'menu,menuone,noinsert'
		},
		mapping = cmp.mapping.preset.insert({
				-- `Enter` key to confirm completion
				['<CR>'] = cmp.mapping.confirm({select = false}),

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
