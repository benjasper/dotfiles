return {
	"folke/sidekick.nvim",
	version = "*",
	opts = {
		cli = {
			win = {
				keys = {
					hide_n = { "q", "hide", mode = "n" },
					hide_ctrl_dot = false
				}
			},
		}
	},
	keys = {
		{
			"<leader>ai",
			function() require("sidekick.cli").toggle() end,
			desc = "Sidekick Toggle CLI",
		},
		{
			"<leader>at",
			function() require("sidekick.cli").send({ msg = "{this}" }) end,
			mode = { "x", "n" },
			desc = "Send This",
		},
		{
			"<leader>av",
			function() require("sidekick.cli").send({ msg = "{selection}" }) end,
			mode = { "x" },
			desc = "Send Visual Selection",
		},
		{
			"<leader>ap",
			function() require("sidekick.cli").prompt() end,
			mode = { "n", "x" },
			desc = "Sidekick Select Prompt",
		},
		{
			"<c-.>",
			function() require("sidekick.cli").focus() end,
			mode = { "n", "x", "i", "t" },
			desc = "Sidekick Switch Focus",
		},
		{
			"<leader>ac",
			function() require("sidekick.cli").toggle({ name = "cursor", focus = true }) end,
			desc = "Sidekick Toggle Claude",
		},
	},
}