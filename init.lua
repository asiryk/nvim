-- Notes
-- <C-^> - Toggle between 2 recent files


G = {}
G.plugin_hl = {} -- array of functions to be applied by colorscheme
G.const = {
  default_winblend = 15,
}
G.utils = require("core.utils")
G.bufnr = vim.api.nvim_get_current_buf
G.log = function (msg)
  vim.notify(vim.inspect(msg), vim.log.levels.DEBUG)
end

require("core.defaults")
require("core.keymaps")
require("plugins").load()
require("ui.colorscheme")
