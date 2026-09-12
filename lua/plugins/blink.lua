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
      path = {
        opts = {
          -- Claude Code prompt files live in $TMPDIR, so complete `./` against
          -- the project (cwd) there; elsewhere keep blink's file-relative default.
          get_cwd = function(context)
            if vim.api.nvim_buf_get_name(context.bufnr):match("/claude%-prompt%-[^/]*%.md$") then
              return vim.fn.getcwd()
            end
            return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
          end,
        },
      },
    },
  },
  fuzzy = { implementation = "prefer_rust_with_warning" },
  snippets = { preset = "luasnip" },
})

