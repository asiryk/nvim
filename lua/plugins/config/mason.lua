local mason = require("mason")
local mason_registry = require("mason-registry")
local mason_api = require("mason.api.command")

local ensure_installed = {
  -- lsp
  "lua-language-server",
  "pyright",
  "svelte-language-server",
  "typescript-language-server",

  -- other
  "eslint_d",
  "prettierd",
  "stylua",
}

local not_installed = vim.tbl_filter(
  function(package) return not mason_registry.is_installed(package) end,
  ensure_installed
)

if #not_installed ~= 0 then
  local fn = function()
    -- close packer window
    local opened_win = vim.api.nvim_get_current_win()
    pcall(vim.api.nvim_win_close, opened_win, true)
    mason_api.MasonInstall(not_installed)
  end
  vim.schedule(fn)
end

mason.setup({
  max_concurrent_installers = 10,
})
