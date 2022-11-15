require("core.defaults")
require("core.keymaps")

if not pcall(require, "packer") then
  require("plugins.packer").bootstrap()
else
  require("plugins.packer").startup(require("plugins"))
end

require("ui.colorscheme")

vim.cmd([[set guifont=Hack\ Nerd\ Font\ Mono:h14]])

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "css", "html", "javascript", "typescript" },
  command = "set shiftwidth=2",
})
