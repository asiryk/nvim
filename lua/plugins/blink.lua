require("blink.cmp").setup({
  cmdline = { enabled = false },
  appearance = {
    nerd_font_variant = "mono",
    kind_icons = require("icons").lspkind,
  },
  completion = {
    accept = { auto_brackets = { enabled = false } },
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
          { "kind_icon", "kind", "source_name", gap = 0 },
        },
        components = {
          source_name = {
            text = function(ctx) return " " .. ctx.item.source_name end,
          },
          kind_icon = {
            text = function(ctx) return ctx.kind_icon .. " " end,
          },
        },
      },
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
      lsp = { fallbacks = {} },
    },
  },
  fuzzy = { implementation = "prefer_rust_with_warning" },
  snippets = { preset = "luasnip" },
})

vim.api.nvim_set_hl(0, "BlinkCmpMenu", { link = "NormalFloat" })
vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { link = "FloatBorder" })
vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { link = "FloatBorder" })

require("theme").add_highlights(function()
  return "blink",
    {
      ---@param c VaguePalette
      vague = function(c)
        local lsp_kind_icons_color = {
          Default = c.property,
          Array = c.constant,
          Boolean = c.number,
          Class = c.constant,
          Color = c.constant,
          Constant = c.number,
          Constructor = c.constant,
          Enum = c.property,
          EnumMember = c.string,
          Event = c.string,
          Field = c.property,
          File = c.constant,
          Folder = c.number,
          Function = c.func,
          Interface = c.constant,
          Key = c.keyword,
          Keyword = c.keyword,
          Method = c.func,
          Module = c.number,
          Namespace = c.operator,
          Null = c.fg,
          Number = c.number,
          Object = c.operator,
          Operator = c.operator,
          Package = c.constant,
          Property = c.property,
          Reference = c.number,
          Snippet = c.operator,
          String = c.constant,
          Struct = c.property,
          Text = c.floatBorder,
          TypeParameter = c.operator,
          Unit = c.constant,
          Value = c.number,
          Variable = c.property,
        }

        local highlights = {}
        for kind, color in pairs(lsp_kind_icons_color) do
          highlights["BlinkCmpKind" .. kind] = { fg = color, blend = 0 }
        end

        highlights["BlinkCmpSource"] = { fg = c.floatBorder, italic = true }
        return highlights
      end,
      ---@param c OneDarkPalette
      onedark = function(c)
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

        highlights["BlinkCmpSource"] = { fg = c.bg3, italic = true }
        return highlights
      end,
    }
end)
