-- Bytecode cache for Lua modules. lazy.nvim used to enable this implicitly;
-- with vim.pack nothing does, and it is worth ~25ms of startup here.
vim.loader.enable()

require("custom")
require("defaults")
require("fold")
require("keymaps")
require("menu")
vim.cmd.colorscheme("custom")
require("plugins.pack")
require("statusline")
require("winbar")
require("tabline")
require("claudecode")
require("diffhl")
require("preview")
require("scratch")
