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

local function make_window_config()
  local winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None"
  local borders = {
    single = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
    double = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
    rounded = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
  }

  local function make(style)
    local b = borders[style]
    if b == nil then return { border = style } end
    local cfg = {
      border = vim.tbl_map(
        function(v) return { v, "CmpBorder" } end,
        b
      ),
      winhighlight = winhighlight,
    }

    return cfg
  end

  return {
    none = make("none"),
    single = make("single"),
    double = make("double"),
    rounded = make("rounded"),
    solid = make("solid"),
    shadow = make("shadow"),
  }
end

local function make_cmp_config()
  local src_map = {
    luasnip = "LuaSnip",
    nvim_lsp = "LSP",
    path = "Path",
    buffer = "Buffer",
    supermaven = "AI",
  }

  local window_cfg = make_window_config()
  local options = {
    window = {
      completion = window_cfg[G.config.window.border],
      documentation = window_cfg[G.config.window.border],
    },
    snippet = {
      expand = function(args) luasnip.lsp_expand(args.body) end,
    },
    formatting = {
      format = function(e, vim_item)
        local src = src_map[e.source.name]
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
      { name = "nvim_lsp", priority = 100 },
      { name = "path", priority = 4 },
      { name = "buffer", priority = 5 },
    },
  }

  return options
end

local function open()
  if not cmp.visible() then
    cmp.complete()
  end
end
vim.keymap.set("i", "<C-p>", open, { desc = "Open completion window [Cmp]" })
vim.keymap.set("i", "<C-n>", open, { desc = "Open completion window [Cmp]" })

cmp.setup(make_cmp_config())

local cmp_augroup = vim.api.nvim_create_augroup("cmp", {})
vim.api.nvim_create_autocmd("User", {
  pattern = "ReloadConfig",
  group = cmp_augroup,
  callback = function()
    cmp.setup(make_cmp_config())
  end,
})
