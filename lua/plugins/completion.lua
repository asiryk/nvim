vim.opt.completeopt = "menuone,noselect"

do -- set up luasnip
  local luasnip = require("luasnip")
  local options = {
    history = true,
    updateevents = "TextChanged,TextChangedI",
  }
  luasnip.config.set_config(options)

  vim.keymap.set({ "i", "s" }, "<C-l>", function()
    if luasnip.expand_or_jumpable() then luasnip.expand_or_jump() end
  end, { silent = true, desc = "Jump next item [LuaSnip]" })

  vim.keymap.set({ "i", "s" }, "<C-h>", function()
    if luasnip.jumpable(-1) then luasnip.jump(-1) end
  end, { silent = true, desc = "Jump prev item [LuaSnip]" })
end

local function make_cmp_config()
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  local icons = require("icons").lspkind

  local src_map = {
    luasnip = "LuaSnip",
    nvim_lsp = "LSP",
    path = "Path",
    buffer = "Buffer",
    supermaven = "AI",
  }

  local window_cfg = {
    border = G.config.window.border,
    winhighlight = "NormalFloat:Normal,FloatBorder:Normal,CursorLine:PmenuSel,Search:None",
  }

  local options = {
    window = {
      completion = window_cfg,
      documentation = window_cfg,
    },
    snippet = {
      expand = function(args) luasnip.lsp_expand(args.body) end,
    },
    formatting = {
      format = function(e, vim_item)
        local src = src_map[e.source.name]
        vim_item.kind =
          string.format("%s %s [%s]", icons[vim_item.kind], vim_item.kind, src)
        return vim_item
      end,
    },
    mapping = {
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-y>"] = cmp.mapping.confirm(),
      ["<C-d>"] = cmp.mapping.scroll_docs(4),
      ["<C-u>"] = cmp.mapping.scroll_docs(-4),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = false, -- Enter only explicitly selected item
      }),
    },
    sources = {
      { name = "luasnip", priority = 1 },
      { name = "nvim_lsp", priority = 100 },
      { name = "path", priority = 4 },
      {
        name = "buffer",
        priority = 5,
        option = {
          get_bufnrs = function()
            local bufs = vim.api.nvim_list_bufs()
            local small_bufs = {}
            for _, buf in pairs(bufs) do
              local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
              local one_mib = 1024 * 1024
              if byte_size < one_mib then
                table.insert(small_bufs, buf)
              end
            end

            return small_bufs
          end
        },
      },
    },
  }

  return options
end

local function setup_cmp()
  local cmp = require("cmp")

  local function open()
    if not cmp.visible() then cmp.complete() end
  end
  vim.keymap.set("i", "<C-p>", open, { desc = "Open completion window [Cmp]" })
  vim.keymap.set("i", "<C-n>", open, { desc = "Open completion window [Cmp]" })

  cmp.setup(make_cmp_config())
end

setup_cmp()
