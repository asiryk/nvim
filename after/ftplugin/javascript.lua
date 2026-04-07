vim.opt.shiftwidth = 2

require("js_common").setup("javascript")

-- set this highlight group to function since
-- lsp highlight gruop highlights methods for some reason
vim.api.nvim_set_hl(0, "@lsp.type.class", { link = "@function" })
