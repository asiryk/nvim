local lspconfig = require("lspconfig")

local servers = {
  "pyright",
  "rust_analyzer",
  "tsserver",
  "sumneko_lua",
  "svelte",
  "html",
  "jsonls",
  "eslint",
  "cssls",
  "clangd",
  "bashls",
}

local function disable_formatting(client)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end

local function on_attach(_, buffer)
  local function set(lhs, rhs) vim.keymap.set("n", lhs, rhs, { buffer = buffer }) end

  -- TODO: center async goto definition with use of :h lsp-handler
  -- https://www.reddit.com/r/neovim/comments/r756ur/how_can_you_center_the_cursor_when_going_to/
  set("gd", vim.lsp.buf.definition)
  set("<S-K>", vim.lsp.buf.hover)
  set("<Leader>lf", function() vim.lsp.buf.format({ async = true }) end)
  set("<Leader>lr", vim.lsp.buf.rename)
  set("<Leader>la", vim.lsp.buf.code_action)
  set("<Leader>lcr", vim.lsp.codelens.refresh)
end

local config = {
  default = {
    flags = { debounce_text_changes = 150 },
    on_attach = function(client, buffer)
      disable_formatting(client)
      on_attach(client, buffer)
    end,
  },
  sumneko_lua = {
    on_attach = on_attach,
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        telemetry = { enable = false },
      },
    },
  },
  tsserver = {
    on_attach = function(client, buffer)
      disable_formatting(client)
      on_attach(client, buffer)
    end,
  },
}

for _, server_name in ipairs(servers) do
  local default_config = config.default
  local specific_config = config[server_name]
  if specific_config == nil then
    lspconfig[server_name].setup(default_config)
  else
    lspconfig[server_name].setup(vim.tbl_extend("force", default_config, specific_config))
  end
end

local signs = { Error = "", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "None" })
end

local autocmd = vim.api.nvim_create_autocmd
autocmd("BufWinEnter", { -- Don't run LSP for large files.
  pattern = "*",
  callback = function() vim.cmd([[if line2byte(line("$") + 1) > 1000000 | LspStop | endif]]) end,
})
