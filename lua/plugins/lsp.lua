do -- set up mason
  local mason = require("mason")
  local mason_registry = require("mason-registry")
  local mason_api = require("mason.api.command")

  mason.setup({
    max_concurrent_installers = 10,
  })

  local ensure_installed = {
    -- lsp
    "lua-language-server",
    "typescript-language-server",
    "clangd",
    "css-lsp",
    "html-lsp",
    "json-lsp",
    "eslint-lsp",
    "docker-compose-language-service",
    "dockerfile-language-server",

    -- other
    "prettierd", -- todo prettierd
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
end

do -- set up lspconfig
  local lspconfig = require("lspconfig")

  local servers = {
    "rust_analyzer",
    "tsserver",
    "lua_ls",
    -- "html",
    -- "jsonls",
    "eslint",
    -- "cssls",
    "clangd",
    "csharp_ls",
    "dockerls",
    "docker_compose_language_service",
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
    set("gr", vim.lsp.buf.references)
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
        on_attach(client, buffer)
      end,
    },
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
            callSnippet = "Replace",
          },
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

  vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, cfg)
    -- make lsp documentation window with rounded borders
    cfg = cfg or {}
    cfg.border = "rounded"
    local _, winid = vim.lsp.handlers.hover(err, result, ctx, cfg)
    if winid ~= nil then
      vim.api.nvim_win_set_option(winid, "winhl", "NormalFloat:None,FloatBorder:CmpBorder")
    end
  end

  -- local autocmd = vim.api.nvim_create_autocmd
  -- autocmd("BufWinEnter", { -- Don't run LSP for large files.
  --   pattern = "*",
  --   callback = function() vim.cmd([[if line2byte(line("$") + 1) > 1000000 | LspStop | endif]]) end,
  -- })
end
