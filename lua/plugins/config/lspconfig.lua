local nvim_lsp = require("lspconfig")

local on_attach = function(_, buffer)
   -- Enable completion triggered by <c-x><c-o>
   vim.api.nvim_buf_set_option(buffer, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local Lua = {
   runtime = { version = "LuaJIT", path = runtime_path },
   diagnostics = { globals = { "vim" } },
   workspace = { library = vim.api.nvim_get_runtime_file("", true) },
   telemetry = { enable = false },
}

local servers = { "pyright", "rust_analyzer", "tsserver", "sumneko_lua", "svelte" }
for _, lsp in ipairs(servers) do
   nvim_lsp[lsp].setup {
      on_attach = on_attach,
      flags = { debounce_text_changes = 150 },
      settings = { Lua = Lua },
   }
end

local signs = { Error = "", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
   local hl = "DiagnosticSign" .. type
   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "None" })
end

local autocmd = vim.api.nvim_create_autocmd
autocmd("BufWinEnter", { -- don't run lsp for large files
  pattern = "*",
  callback = function () vim.cmd([[if line2byte(line("$") + 1) > 1000000 | LspStop | endif]]) end
})

