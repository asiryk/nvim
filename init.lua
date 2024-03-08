G = {}
G.plugin_hl = {} -- array of functions to be applied by colorscheme

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "css",
    "javascript",
    -- "typescript"
  },
  command = "set shiftwidth=4",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "html", "astro", "glsl", "typescript", "xml", "lua" },
  command = "set shiftwidth=2",
})

require("core.defaults")
require("core.keymaps")
require("plugins").load()
require("ui.colorscheme")
