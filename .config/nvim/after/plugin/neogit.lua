local neogit = require('neogit')
neogit.setup {}

vim.keymap.set("n", "<leader>gs", function () neogit.open({ kind = "split_above" }) end);

