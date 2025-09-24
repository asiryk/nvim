-- TODO: remove local storage and colorscheme/ dir
require("custom")
require("defaults")
require("keymaps")
require("menu")
vim.cmd.colorscheme("custom")
require("plugin_spec")
require("statusline")

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
