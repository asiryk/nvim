-- :Scratch — open a scratch buffer in a vertical split.

local counter = 0

-- Buffer names must be unique, so skip numbers already taken (e.g. by a
-- buffer the user named "Scratch2" by hand).
local function set_default_name(buf)
  repeat
    counter = counter + 1
  until pcall(vim.api.nvim_buf_set_name, buf, "Scratch" .. counter)
end

local function create_scratch_buf()
  local buf = vim.api.nvim_create_buf(true, true)
  vim.cmd("vsplit")
  vim.api.nvim_win_set_buf(0, buf)

  vim.ui.input({ prompt = "Enter scratch buffer name" }, function(input)
    -- nil when the prompt is cancelled.
    if input == nil or input == "" then
      set_default_name(buf)
      return
    end

    vim.api.nvim_buf_set_name(buf, input)
  end)
end

vim.api.nvim_create_user_command("Scratch", create_scratch_buf, { desc = "Create scratch buffer [User]" })
