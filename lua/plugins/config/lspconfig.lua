local lspconfig = require("lspconfig")

local servers = { "pyright", "rust_analyzer", "tsserver", "sumneko_lua", "svelte", "html" }

local config = {
  default = {
    flags = { debounce_text_changes = 150 },
    format = false,
  },
  sumneko_lua = {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        telemetry = { enable = false },
      },
    },
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
