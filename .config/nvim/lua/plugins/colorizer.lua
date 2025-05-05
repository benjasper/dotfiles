---
return {
	{
		"norcalli/nvim-colorizer.lua",
		ft = { "lua", "css" },
		config = function()
			require("colorizer").setup()
		end,
	}
}