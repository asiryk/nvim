local mason = require("mason")
local mason_registry = require("mason-registry")
local mason_api = require("mason.api.command")

mason.setup({
  max_concurrent_installers = 10,
})

local ensure_installed = {
  -- lsp
  "astro-language-server",
  "lua-language-server",
  "pyright",
  "svelte-language-server",
  "typescript-language-server",
  "clangd",
  "css-lsp",
  "html-lsp",
  "json-lsp",
  "eslint-lsp",

  -- dap
  -- "chrome-debug-adapter",

  -- other
  "prettierd",
  "stylua",
  "luacheck",
  "clang-format",
}

local function not_installed(packages)
  return vim.tbl_filter(
    function(package) return not mason_registry.is_installed(package) end,
    packages
  )
end

local function autoinstall(packages)
  vim.schedule(function()
    -- try close packer window if it is opened
    local opened_win = vim.api.nvim_get_current_win()
    pcall(vim.api.nvim_win_close, opened_win, true)

    mason_api.MasonInstall(packages)
  end)
end

local function prompt(packages, fn)
  local joined = table.concat(packages, "\n")
  local msg = "Do you want to autoinstall these packages? y/n: "
  local prompt_msg = string.format("%s\n%s", joined, msg)

  vim.ui.input(
    { prompt = prompt_msg },
    function(input) fn(input ~= nil and input:sub(1, 1) == "y") end
  )
end

local function execute(packages)
  if #packages > 0 then
    prompt(packages, function(should_install)
      if should_install then autoinstall(packages) end
    end)
  end
end

execute(not_installed(ensure_installed))
