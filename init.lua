require("core.defaults")
require("core.keymaps")

require("plugins").load()

require("ui.colorscheme")

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "css", "html", "javascript", "typescript" },
  command = "set shiftwidth=2",
})
