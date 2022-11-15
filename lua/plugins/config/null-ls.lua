local null_ls = require("null-ls")

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

table.insert(formatting.prettierd.filetypes, "astro")

local sources = {
  formatting.prettierd,
  formatting.stylua,
  formatting.clang_format,
  diagnostics.luacheck.with({ extra_args = { "--globals vim" } }),
}

null_ls.setup({ sources = sources })
