local mason_cfg = { max_concurrent_installers = 10 }
require("mason").setup(mason_cfg)
require("mason-lspconfig").setup()

do
  --- @type vim.diagnostic.Opts
  local diagnostic_config = {
    virtual_text = true,
  }

  vim.diagnostic.config(diagnostic_config)

  vim.keymap.set("n", "<Leader>le", function()
    if diagnostic_config.virtual_lines then
      diagnostic_config = {
        virtual_text = true,
        virtual_lines = false,
      }
    else
      diagnostic_config = {
        virtual_text = false,
        virtual_lines = true,
      }
    end
    vim.diagnostic.config(diagnostic_config)
  end, { desc = "Toggle error virtual lines [LSP]" })
end

local function toggle_codelens_fn()
  local open = false
  return function ()
    vim.lsp.codelens.enable(not open)
    open = not open
  end
end

local function format()
  require("conform").format({ async = true })
end
vim.keymap.set({ "n", "v" }, "<Leader>lf", format, { desc = "Format [LSP], [Conform]" })

local function on_attach(client, buffer)
  -- Stop nvim from requesting document colors from this server — it paints
  -- hex strings with LspDocumentColor_* highlights; mini.hipatterns handles
  -- them instead.
  client.server_capabilities.colorProvider = nil

  local function set(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
  end
  local function definition()
    vim.api.nvim_create_autocmd("CursorMoved", {
      once = true,
      callback = function() require("custom").utils.center_move()() end,
      desc = "Center move after async lsp definition jump",
    })
    -- ts_ls returns both the class declaration and its constructor for a
    -- class; dedupe by filename (earliest line wins) so we jump straight
    -- to the class instead of getting a quickfix list.
    vim.lsp.buf.definition({
      on_list = function(list)
        local seen = {}
        local items = {}
        for _, item in ipairs(list.items) do
          local prev = seen[item.filename]
          if not prev then
            seen[item.filename] = #items + 1
            table.insert(items, item)
          elseif item.lnum < items[prev].lnum then
            items[prev] = item
          end
        end
        if #items == 1 then
          vim.cmd.normal({ "m'", bang = true })
          local item = items[1]
          vim.cmd.edit(vim.fn.fnameescape(item.filename))
          vim.api.nvim_win_set_cursor(0, { item.lnum, item.col - 1 })
        else
          vim.fn.setqflist({}, " ", { title = list.title, items = items })
          vim.cmd("botright copen")
        end
      end,
    })
  end

  set("n", "gd", definition, "Go to definition [LSP]")
  set(
    "n",
    "<S-k>",
    function() vim.lsp.buf.hover() end,
    "Hover documentation [LSP]"
  )
  set(
    "i",
    "<C-k>",
    function() vim.lsp.buf.signature_help() end,
    "Hover signature help [LSP]"
  )
  set("n", "<Leader>lr", vim.lsp.buf.rename, "Rename variable [LSP]")
  set("n", "<Leader>la", vim.lsp.buf.code_action, "Show actions [LSP]")
  set("n", "<Leader>lcr", toggle_codelens_fn(), "Refresh codelens [LSP]")
  set(
    "n",
    "<Leader>lh",
    function() vim.diagnostic.open_float() end,
    "Open vim diagnostic window [LSP]"
  )
end

local config = {
  gopls = {},
  rust_analyzer = {},
  ts_ls = {},
  -- tsgo = {},
  lua_ls = {
    on_init = function(client)
      -- Skip configuration if there is a luarc file in the project
      local path
      if client.workspace_folders then
        path = client.workspace_folders[1].name
        if
          path ~= vim.fn.stdpath("config")
          and (
            vim.uv.fs_stat(path .. "/.luarc.json")
            or vim.uv.fs_stat(path .. "/.luarc.jsonc")
          )
        then
          return
        end
      end

      local library = {
        vim.env.VIMRUNTIME,
        "${3rd}/luv/library",
        "${3rd}/busted/library",
      }
      -- Add plugins as library only if it's opened in neovim config dir.
      if path == vim.fn.stdpath("config") then
        vim.list_extend(library, vim.api.nvim_get_runtime_file("", true))
      end

      local nvim_config = {
        runtime = { version = "LuaJIT" },
        workspace = {
          checkThirdParty = false,
          library = library,
        },
        completion = {
          keywordSnippet = "Disable",
          callSnippet = "Replace",
        },
        telemetry = { enable = false },
      }

      client.config.settings.Lua =
        vim.tbl_deep_extend("force", client.config.settings.Lua, nvim_config)
    end,
    on_attach = on_attach,
    settings = { Lua = {} },
  },
  -- cssls = {},
  -- tailwindcss = {},
  clangd = {},
  bashls = {},
  -- dockerls = {},
  -- docker_compose_language_service = {},
  zls = {},
  jsonls = {
    filetypes = { "json", "jsonc" },
    single_file_support = true,
  },
}

local default_config = {
  flags = { debounce_text_changes = 75 },
  on_attach = function(client, buffer) on_attach(client, buffer) end,
}

require("mason-tool-installer").setup({
  ensure_installed = vim.list_extend({
    "prettierd",
    "stylua",
    -- "luacheck",
  }, vim.tbl_keys(config)),
})

vim.lsp.log.set_level("off")
vim.lsp.enable(vim.tbl_keys(config))
for server_name, server_config in pairs(config) do
  vim.lsp.config(server_name, vim.tbl_extend("force", default_config, server_config))
end

local function biome_or_prettier(bufnr)
  local found = vim.fs.find({ "biome.json", "biome.jsonc" }, {
    upward = true,
    path = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)),
    stop = vim.uv.os_homedir(),
  })
  return #found > 0 and { "biome" } or { "prettierd" }
end

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = biome_or_prettier,
    typescript = biome_or_prettier,
    typescriptreact = biome_or_prettier,
    javascriptreact = biome_or_prettier,
    json = biome_or_prettier,
    xml = { "xmllint" },
  },
})
