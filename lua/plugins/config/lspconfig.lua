local nvim_lsp = require("lspconfig")

-- will be called when language server attaches to the current buffer
local on_attach = function(_, buffer)
   local options = { buffer = buffer }
   local lsp_buf = vim.lsp.buf
   local lsp_diagnostic = vim.lsp.diagnostic

   -- Enable completion triggered by <c-x><c-o>
   vim.api.nvim_buf_set_option(buffer, "omnifunc", "v:lua.vim.lsp.omnifunc")

   -- See `:help vim.lsp.*` for documentation on any of the below functions
   vim.keymap.set("n", "gD", lsp_buf.declaration, options)
   vim.keymap.set("n", "gd", lsp_buf.definition, options)
   vim.keymap.set("n", "K", lsp_buf.hover, options)
   vim.keymap.set("n", "gi", lsp_buf.implementation, options)
   vim.keymap.set("n", "<C-k>", lsp_buf.signature_help, options)
   vim.keymap.set("n", "<Leader>wa", lsp_buf.add_workspace_folder, options)
   vim.keymap.set("n", "<Leader>wr", lsp_buf.remove_workspace_folder, options)
   vim.keymap.set("n", "<Leader>wl", function() vim.pretty_print(vim.lsp.buf.list_workspace_folders()) end, options)
   vim.keymap.set("n", "<Leader>D", lsp_buf.type_definition, options)
   vim.keymap.set("n", "<Leader>rn", lsp_buf.rename, options)
   vim.keymap.set("n", "<Leader>ca", lsp_buf.code_action, options)
   vim.keymap.set("n", "gr", lsp_buf.references, options)
   vim.keymap.set("n", "<Leader>f", lsp_buf.formatting, options)

   vim.keymap.set("n", "<Leader>e", lsp_diagnostic.show_line_diagnostics, options)
   vim.keymap.set("n", "[d", lsp_diagnostic.goto_prev, options)
   vim.keymap.set("n", "]d", lsp_diagnostic.goto_next, options)
   vim.keymap.set("n", "<Leader>q", lsp_diagnostic.set_loclist, options)
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

-- Use a loop to conveniently call "setup" on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "pyright", "rust_analyzer", "tsserver", "sumneko_lua", "clangd", "svelte" }
for _, lsp in ipairs(servers) do
   nvim_lsp[lsp].setup {
      on_attach = on_attach,
      flags = { debounce_text_changes = 150 },
      settings = {
         Lua = Lua,
      },
   }
end
