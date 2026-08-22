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
require("qfpersist")
require("statusline")
require("winbar")
require("tabline")
require("claudecode")
require("diffhl")
require("preview")

local function create_scratch_buf()
  local buf = vim.api.nvim_create_buf(true, true)
  vim.cmd("vsplit")
  vim.api.nvim_win_set_buf(0, buf)

  vim.ui.input({ prompt = "Enter scratch buffer name" }, function(input)
    if input == "" then return end

    vim.api.nvim_buf_set_name(buf, input)
  end)
end


vim.api.nvim_create_user_command("Scratch", function()
  create_scratch_buf()
end, { desc = "Create scratch buffer [User]" })
