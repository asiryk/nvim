require("core.defaults")
require("core.keymaps")

if not pcall(require, "packer") then
  require("plugins.packer").bootstrap()
else
  require("plugins.packer").startup(require("plugins"))
end

local function dbg()
  local set = function(lhs, rhs) vim.keymap.set("n", lhs, rhs) end

  set("<leader>pc", ":PackerCompile<cr>")
  set("<leader>ps", ":PackerSync<cr>")
end

dbg()
