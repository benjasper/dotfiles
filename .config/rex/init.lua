rex.bind("ctrl+v", "pane.split", { direction = "right" })
rex.bind("ctrl+s", "pane.split", { direction = "down" })

rex.bind("ctrl+h", "pane.focus", { direction = "left" })
rex.bind("ctrl+j", "pane.focus", { direction = "down" })
rex.bind("ctrl+k", "pane.focus", { direction = "up" })
rex.bind("ctrl+l", "pane.focus", { direction = "right" })

rex.bind("ctrl+q", "pane.close")

rex.bind("cmd+w", "client.tab.close")
rex.bind("cmd+n", "session.new")

rex.bind("ctrl+left", "pane.resize", { direction = "left" })
rex.bind("ctrl+right", "pane.resize", { direction = "right" })
rex.bind("ctrl+up", "pane.resize", { direction = "up" })
rex.bind("ctrl+down", "pane.resize", { direction = "down" })

rex.bind("cmd+l", "dev_layout")

rex.action {
	name  = "dev_layout",
	title = "Open Dev Layout",
	args  = { ratio = "number?" },
	run   = function(ctx, args)
		local split, err = rex.session.new_split {
			direction = "vertical",
			side      = "after",
			focus     = false,
			ratio     = 0.9,
			layout    = rex.layout.block {
				flavor = "com.superlogical.terminal.shell",
			},
		}

		local split, err = rex.session.new_split {
			direction = "horizontal",
			side      = "after",
			focus     = false,
			ratio     = 0.8,
			layout    = rex.layout.block {
				flavor = "com.superlogical.terminal.shell",
			},
		}
		if err ~= nil then error(err, 0) end
	end,
}
