local luasnip = require("luasnip")
local cmp = require("cmp")

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- nvim-cmp setup
cmp.setup {
  completion = {
    autocomplete = true,
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = { -- :h ins-completion - there are classic keybindings such as <C-p> and <C-n>
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<c-y>"] = cmp.mapping(
        cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        },
        { "i", "c" }
    ),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  },
  sources = {
    { name = "nvim_lua" },
    { name = "nvim_lsp" },
    -- { name = "path" },
    { name = "luasnip" },
    -- { name = "buffer", keyword_length = 5 },
  },
  -- formatting = {
  --   format = function(arg1, arg2)
  --     print(1)
  --     return arg2
  --   end
  -- }
}
