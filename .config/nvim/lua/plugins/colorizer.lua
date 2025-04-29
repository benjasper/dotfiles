---
return {
	{
		"norcalli/nvim-colorizer.lua",
		event = "BufRead",
		ft = { "lua", "css" },
		config = function()
			require("colorizer").setup()
		end,
	}
}