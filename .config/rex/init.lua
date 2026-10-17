rex.bind("ctrl+v", "pane.split", { direction = "right" })
rex.bind("ctrl+s", "pane.split", { direction = "down" })

rex.bind("ctrl+h", "pane.focus", { direction = "left" })
rex.bind("ctrl+j", "pane.focus", { direction = "down" })
rex.bind("ctrl+k", "pane.focus", { direction = "up" })
rex.bind("ctrl+l", "pane.focus", { direction = "right" })

rex.bind("ctrl+q", "pane.close")

rex.bind("cmd+n", "session.new")
