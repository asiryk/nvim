vim.api.nvim_create_user_command(
  "AIStart",
  function() require("supermaven-nvim").setup({}) end,
  { desc = "Manually turn on AI completion [User]" }
)
