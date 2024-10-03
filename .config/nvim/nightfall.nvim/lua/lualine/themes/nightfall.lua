local colors = require('nightfall.colors')
return {
  normal = {
    a = {bg = colors.lightBlue, fg = colors.background1, gui = 'bold'},
    b = {bg = colors.backgroundFloat, fg = colors.lightBlue},
    c = {bg = colors.background1, fg = colors.lightBlue},
  },
  insert = {
    a = {bg = colors.text, fg = colors.background1, gui = 'bold'},
    b = {bg = colors.backgroundFloat, fg = colors.lightBlue},
    c = {bg = colors.background1, fg = colors.lightBlue},
  },
  visual = {
    a = {bg = colors.text, fg = colors.background1, gui = 'bold'},
    b = {bg = colors.backgroundFloat, fg = colors.lightBlue},
    c = {bg = colors.background1, fg = colors.lightBlue},
  },
  replace = {
    a = {bg = colors.lightBlue, fg = colors.background1, gui = 'bold'},
    b = {bg = colors.backgroundFloat, fg = colors.lightBlue},
    c = {bg = colors.background1, fg = colors.lightBlue},
  },
  command = {
    a = {bg = colors.orange, fg = colors.background1, gui = 'bold'},
    b = {bg = colors.backgroundFloat, fg = colors.lightBlue},
    c = {bg = colors.background1, fg = colors.lightBlue},
  },
  inactive = {
    a = {bg = colors.background1, fg = colors.backgroundFloat, gui = 'bold'},
    b = {bg = colors.background1, fg = colors.lightBlue},
    c = {bg = colors.background1, fg = colors.lightBlue},
  }
}