require("blink.cmp").setup({
  cmdline = { enabled = false },
  appearance = {
    -- Adds gap " " to icons, so blend = 0 option works
    nerd_font_variant = "normal",
    kind_icons = require("icons").lspkind,
  },
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 0,
    },
    menu = {
      auto_show = true,
      max_height = 20,
      winblend = vim.o.pumblend,
      draw = {
        columns = {
          { "label", "label_description", gap = 1 },
          { "kind_icon", "kind", "source_name", gap = 1 }
        },
        components = {
          source_name = {
            text = function(ctx)
              return string.format(" [%s]", ctx.item.source_name)
            end,
          },
        },
      }
    },
  },
  keymap = {
    preset = "default",
    ["<C-l>"] = { "snippet_forward", "fallback" },
    ["<C-h>"] = { "snippet_backward", "fallback" },
    ["<C-k>"] = { "show_signature", "fallback" },
  },
  sources = {
    providers = {
      -- By default, the buffer source will only show when the LSP source is disabled or returns no items. Always show the buffer source via:
      lsp = { fallbacks = {} }
    },
  },
  fuzzy = { implementation = "prefer_rust_with_warning" },
  snippets = { preset = "luasnip" },
})

vim.api.nvim_set_hl(0, "BlinkCmpMenu", { link = "NormalFloat" })
vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { link = "FloatBorder" })
vim.api.nvim_set_hl(0, "BlinkCmpSource", { link = "NonText" })

require("theme").add_highlights(function(c)
  local lsp_kind_icons_color = {
    Default = c.purple,
    Array = c.yellow,
    Boolean = c.orange,
    Class = c.yellow,
    Color = c.green,
    Constant = c.orange,
    Constructor = c.blue,
    Enum = c.purple,
    EnumMember = c.yellow,
    Event = c.yellow,
    Field = c.purple,
    File = c.blue,
    Folder = c.orange,
    Function = c.blue,
    Interface = c.green,
    Key = c.cyan,
    Keyword = c.cyan,
    Method = c.blue,
    Module = c.orange,
    Namespace = c.red,
    Null = c.grey,
    Number = c.orange,
    Object = c.red,
    Operator = c.red,
    Package = c.yellow,
    Property = c.cyan,
    Reference = c.orange,
    Snippet = c.red,
    String = c.green,
    Struct = c.purple,
    Text = c.light_grey,
    TypeParameter = c.red,
    Unit = c.green,
    Value = c.orange,
    Variable = c.purple,
  }

  local highlights = {}
  for kind, color in pairs(lsp_kind_icons_color) do
    highlights["BlinkCmpKind" .. kind] = { fg = color, blend = 0 }
  end

  return "blink", highlights
end)
