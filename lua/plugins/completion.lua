do -- set up luasnip
  local luasnip = require("luasnip")
  local options = {
    history = true,
    updateevents = "TextChanged,TextChangedI",
  }
  luasnip.config.set_config(options)

  vim.keymap.set({"i", "s"}, "<C-l>", function()
    if luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    end
  end, { silent = true, desc = "Jump next item [LuaSnip]" })

  vim.keymap.set({"i", "s"}, "<C-h>", function()
    if luasnip.jumpable(-1) then
      luasnip.jump(-1)
    end
  end, { silent = true, desc = "Jump prev item [LuaSnip]" })
end

local cmp = require("cmp")
local luasnip = require("luasnip")
local icons = require("colorscheme.icons").lspkind

vim.opt.completeopt = "menuone,noselect"

local function window()
  local hl_name = "CmpBorder"
  return {
    border = {
      { "╭", hl_name },
      { "─", hl_name },
      { "╮", hl_name },
      { "│", hl_name },
      { "╯", hl_name },
      { "─", hl_name },
      { "╰", hl_name },
      { "│", hl_name },
    },
    winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None"
  }
end

local src_map = {
  luasnip = "LuaSnip",
  nvim_lsp = "LSP",
  path = "Path",
  buffer = "Buffer",
  supermaven = "AI",
  conjure = "Conjure",
}

local options = {
  window = {
    completion = window(),
    documentation = window(),
  },
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  formatting = {
    format = function(e, vim_item)
      local src = src_map[e.source.name]
      if src == nil then src = e.source.name end
      vim_item.kind = string.format("%s %s [%s]", icons[vim_item.kind], vim_item.kind, src)
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
    { name = "conjure", priority = 200 },
    { name = "nvim_lsp", priority = 100 },
    { name = "path", priority = 4 },
    { name = "buffer", priority = 5 },
  },
}

local function open()
  if not cmp.visible() then
    cmp.complete()
  end
end
vim.keymap.set("i", "<C-p>", open, { desc = "Open completion window [Cmp]" })
vim.keymap.set("i", "<C-n>", open, { desc = "Open completion window [Cmp]" })

cmp.setup(options)
