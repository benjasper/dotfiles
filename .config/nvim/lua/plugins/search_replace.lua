--- @type LazySpec
return {
	'MagicDuck/grug-far.nvim',
	keys = { {
		'<leader>sr',
		function()
			require('grug-far').grug_far()
		end,
		'Search Replace'
	} },
	event = 'VeryLazy',
	config = function()
		require('grug-far').setup({});
	end
}