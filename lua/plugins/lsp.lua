local mason_cfg = { max_concurrent_installers = 10 }
require("mason").setup(mason_cfg)
require("mason-lspconfig").setup()
local lspconfig = require("lspconfig")

vim.diagnostic.config({
  virtual_lines = { current_line = true },
})

local function format()
  require("conform").format({ async = true })
end
vim.keymap.set({ "n", "v" }, "<Leader>lf", format, { desc = "Format [LSP], [Conform]" })

local function on_attach(_, buffer)
  local function set(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc }) end
  local function definition()
    vim.api.nvim_create_autocmd("CursorMoved", {
      once = true,
      callback = function() require("custom").utils.center_move()() end,
      desc = "Center move after async lsp definition jump"
    })
    vim.lsp.buf.definition()
  end

  set("n", "gd", definition, "Go to definition [LSP]")
  set("n", "<S-k>", function() vim.lsp.buf.hover({ border = "rounded" }) end, "Hover documentation [LSP]")
  set("i", "<C-k>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, "Hover signature help [LSP]")
  set("n", "<Leader>lr", vim.lsp.buf.rename, "Rename variable [LSP]")
  set("n", "<Leader>la", vim.lsp.buf.code_action, "Show actions [LSP]")
  set("n", "<Leader>lcr", vim.lsp.codelens.refresh, "Refresh codelens [LSP]")
  set("n", "<Leader>lh", function() vim.diagnostic.open_float({ border = "rounded" }) end, "Open vim diagnostic window [LSP]")
end

local config = {
  gopls = {},
  rust_analyzer = {},
  ts_ls = {},
  lua_ls = {
    on_attach = on_attach,
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        workspace = {
          checkThirdParty = false,
          library = {
            "${3rd}/luv/library",
            unpack(vim.api.nvim_get_runtime_file("", true)),
          },
        },
        completion = {
          keywordSnippet = "Disable",
          callSnippet = "Replace",
        },
        telemetry = { enable = false },
      },
    },
  },
  cssls = {},
  tailwindcss = {},
  clangd = {},
  dockerls = {},
  docker_compose_language_service = {},
  zls = {},
}

local default_config = {
  flags = { debounce_text_changes = 75 },
  on_attach = function(client, buffer)
    on_attach(client, buffer)
  end,
}

require("mason-tool-installer").setup({
  ensure_installed = vim.list_extend({
    "eslint_d",
    "prettierd",
    "stylua",
    "luacheck",
  }, vim.tbl_keys(config))
})

vim.lsp.set_log_level("off")
for server_name, server_config in pairs(config) do
  local cfg = vim.tbl_extend("force", default_config, server_config)
  lspconfig[server_name].setup(cfg)
end

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettierd" },
    typescript = { "prettierd" },
    typescriptreact = { "prettierd" },
    javascriptreact = { "prettierd" },
    json = { "prettierd" },
  }
})

-- TODO: see if without this everything is ok, and remove it.
-- local lsp_show_message = vim.lsp.handlers["window/showMessage"]
-- vim.lsp.handlers["window/showMessage"] = function(err, result, ctx, cfg)
--   -- Only show messages of warning severity
--   if result and result.type <= vim.lsp.protocol.MessageType.Warning then
--     lsp_show_message(err, result, ctx, cfg)
--   end
-- end
