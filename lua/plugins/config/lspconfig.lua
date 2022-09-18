local lspconfig = require("lspconfig")

-- TODO: center async goto definition with use of :h lsp-handler
-- https://www.reddit.com/r/neovim/comments/r756ur/how_can_you_center_the_cursor_when_going_to/
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "<S-K>", vim.lsp.buf.hover)
vim.keymap.set("n", "<Leader>lf", vim.lsp.buf.formatting)
vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename)
vim.keymap.set("n", "<Leader>la", vim.lsp.buf.code_action)
vim.keymap.set("n", "<Leader>lcr", vim.lsp.codelens.refresh)

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
  tsserver = {
    root_dir = function(filename, buf)
      local root_func
      if string.find(filename, "ne-slots") then
        -- root - where .git is located. otherwise works bad with monorepo
        root_func = lspconfig.util.root_pattern(".git")
      else
        root_func = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")
      end
      return root_func(filename, buf)
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
