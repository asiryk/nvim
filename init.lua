-- Notes
-- <C-^> - Toggle between 2 recent files


G = {}
G.plugin_hl = {} -- array of functions to be applied by colorscheme
G.const = {
  default_winblend = 15,
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "css",
    "javascript",
    -- "typescript"
  },
  command = "set shiftwidth=4",
})

require("core.defaults")
require("core.keymaps")
require("plugins").load()
require("ui.colorscheme")
