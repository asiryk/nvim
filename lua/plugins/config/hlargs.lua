local hlargs = require("hlargs")

vim.cmd([[
  hi clear Hlargs
  hi link Hlargs @parameter
]]) -- use default ts parameter color for hlargs

hlargs.setup({})
