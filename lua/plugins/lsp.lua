require("mason").setup({ max_concurrent_installers = 10 })
require("mason-lspconfig").setup()
local lspconfig = require("lspconfig")

local function open_float_diagnostics()
  local function open_generic(style, is_set_hl)
    return function()
      local opts = {
        border = style,
        focusable = false,
      }

      local _, win_id = vim.diagnostic.open_float(nil, opts)
      if is_set_hl and type(win_id) == "number" then
        vim.api.nvim_set_option_value("winhl", "NormalFloat:None,FloatBorder:CmpBorder", { win = win_id })
      end
    end
  end

  local window_cfg = {
    none = open_generic("none", false),
    single = open_generic("single", true),
    double = open_generic("double", true),
    rounded = open_generic("rounded", true),
    solid = open_generic("solid", false),
    shadow = open_generic("shadow", false),
  }

  window_cfg[G.config.window.border]()
end

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
  set("n", "gr", vim.lsp.buf.references, "Find references [LSP]")
  set("n", "<S-k>", vim.lsp.buf.hover, "Hover documentation [LSP]")
  set("i", "<C-k>", vim.lsp.buf.signature_help, "Hover signature help [LSP]")
  set("n", "<Leader>lr", vim.lsp.buf.rename, "Rename variable [LSP]")
  set("n", "<Leader>la", vim.lsp.buf.code_action, "Show actions [LSP]")
  set("n", "<Leader>lcr", vim.lsp.codelens.refresh, "Refresh codelens [LSP]")
  set("n", "<Leader>lh", open_float_diagnostics, "Open vim diagnostic window [LSP]")
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
  flags = { debounce_text_changes = 150 },
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

local signs = { Error = "", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "None" })
end

local function style_window(lsp_handler)
  local function open_generic(style, is_set_hl)
    return function(err, result, ctx, cfg)
      cfg = cfg or {}
      cfg.border = style
      local _, winid = lsp_handler(err, result, ctx, cfg)
      if is_set_hl and type(winid) == "number" then
        vim.api.nvim_set_option_value("winhl", "NormalFloat:None,FloatBorder:CmpBorder", { win = winid })
      end
    end
  end

  local window_cfg = {
    none = open_generic("none", false),
    single = open_generic("single", true),
    double = open_generic("double", true),
    rounded = open_generic("rounded", true),
    solid = open_generic("solid", false),
    shadow = open_generic("shadow", false),
  }

  return function(err, result, ctx, cfg)
    window_cfg[G.config.window.border](err, result, ctx, cfg)
  end
end

vim.lsp.handlers["textDocument/hover"] = style_window(vim.lsp.handlers["textDocument/hover"])
vim.lsp.handlers["textDocument/signatureHelp"] = style_window(vim.lsp.handlers["textDocument/signatureHelp"])

local lsp_show_message = vim.lsp.handlers["window/showMessage"]
vim.lsp.handlers["window/showMessage"] = function(err, result, ctx, cfg)
  -- Only show messages of warning severity
  if result and result.type <= vim.lsp.protocol.MessageType.Warning then
    lsp_show_message(err, result, ctx, cfg)
  end
end

-- local autocmd = vim.api.nvim_create_autocmd
-- autocmd("BufWinEnter", { -- Don't run LSP for large files.
--   pattern = "*",
--   callback = function() vim.cmd([[if line2byte(line("$") + 1) > 1000000 | LspStop | endif]]) end,
--
