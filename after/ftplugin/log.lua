vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = "nvic"

vim.cmd([[syntax match AnsiEscape /\e\[[0-9;]*[a-zA-Z]/ conceal]])
