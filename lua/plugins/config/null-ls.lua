local present, null_ls = pcall(require, "null-ls")

if not present then return end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

local sources = {
  formatting.prettier,
  formatting.stylua,
  diagnostics.luacheck.with({ extra_args = { "--globals vim" } }),
}

null_ls.setup({ sources = sources })
