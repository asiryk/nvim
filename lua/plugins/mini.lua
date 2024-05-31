local files = require("mini.files")

vim.keymap.set("n", "<C-n>", files.open, { desc = "Open files [Mini.files]" })
