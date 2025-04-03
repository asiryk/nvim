local F = {}
local S = (function()
  if not G.theme then G.theme = {
    added_highlights = {},
  } end
  return G.theme
end)()

---@class Palette
---@field black string
---@field bg0 string
---@field bg1 string
---@field bg2 string
---@field bg3 string
---@field bg_d string
---@field bg_blue string
---@field bg_yellow string
---@field fg string
---@field purple string
---@field green string
---@field orange string
---@field blue string
---@field yellow string
---@field cyan string
---@field red string
---@field grey string
---@field light_grey string
---@field dark_cyan string
---@field dark_red string
---@field dark_yellow string
---@field dark_purple string
---@field diff_add string
---@field diff_delete string
---@field diff_change string
---@field diff_text string

---@class Theme
---@field dark Palette
---@field light Palette

---@return Theme
function F.build_palette()
  local onedark = {
    dark = {
      black = "#0e1013",
      bg0 = "#1f2329",
      bg1 = "#282c34",
      bg2 = "#30363f",
      bg3 = "#323641",
      bg_d = "#181b20",
      bg_blue = "#61afef",
      bg_yellow = "#e8c88c",
      fg = "#a0a8b7",
      purple = "#bf68d9",
      green = "#8ebd6b",
      orange = "#cc9057",
      blue = "#4fa6ed",
      yellow = "#e2b86b",
      cyan = "#48b0bd",
      red = "#e55561",
      grey = "#535965",
      light_grey = "#7a818e",
      dark_cyan = "#266269",
      dark_red = "#8b3434",
      dark_yellow = "#835d1a",
      dark_purple = "#7e3992",
      diff_add = "#272e23",
      diff_delete = "#2d2223",
      diff_change = "#172a3a",
      diff_text = "#274964",
    },
    light = {
      black = "#101012",
      bg0 = "#fafafa",
      bg1 = "#f0f0f0",
      bg2 = "#e6e6e6",
      bg3 = "#dcdcdc",
      bg_d = "#c9c9c9",
      bg_blue = "#68aee8",
      bg_yellow = "#e2c792",
      fg = "#383a42",
      purple = "#a626a4",
      green = "#50a14f",
      orange = "#c18401",
      blue = "#4078f2",
      yellow = "#986801",
      cyan = "#0184bc",
      red = "#e45649",
      grey = "#a0a1a7",
      light_grey = "#818387",
      dark_cyan = "#2b5d63",
      dark_red = "#833b3b",
      dark_yellow = "#7c5c20",
      dark_purple = "#79428a",
      diff_add = "#e2fbe4",
      diff_delete = "#fce2e5",
      diff_change = "#e2ecfb",
      diff_text = "#cad3e0",
    },
  }

  return onedark
end

---@param theme Theme
---@param appearance "dark" | "light"
---@return table<string, vim.api.keyset.highlight>
function F.build_highlights(theme, appearance)
  local c = theme[appearance]

  local code_style = {
    comments = { italic = true },
    keywords = {},
    functions = {},
    strings = {},
    variables = {},
    constants = {},
  }

  --- @type table<string, vim.api.keyset.highlight>
  local hl = {}

  hl.common = {
    Normal = { fg = c.fg, bg = c.bg0 },
    Terminal = { fg = c.fg, bg = c.bg0 },
    EndOfBuffer = { fg = c.bg0, bg = c.bg0 },
    FoldColumn = { fg = c.fg, bg = c.bg1 },
    Folded = { fg = c.fg, bg = c.bg1 },
    SignColumn = { fg = c.fg, bg = c.bg0 },
    ToolbarLine = { fg = c.fg },
    Cursor = { reverse = true },
    vCursor = { reverse = true },
    iCursor = { reverse = true },
    lCursor = { reverse = true },
    CursorIM = { reverse = true },
    CursorColumn = { bg = c.bg1 },
    CursorLine = { bg = "none" },
    ColorColumn = { bg = c.bg1 },
    CursorLineNr = { fg = c.fg },
    LineNr = { fg = c.grey },
    Conceal = { fg = c.grey, bg = c.bg1 },
    Added = { fg = c.green },
    Removed = { fg = c.red },
    Changed = { fg = c.blue },
    DiffAdd = { fg = c.none, bg = c.diff_add },
    DiffChange = { fg = c.none, bg = c.diff_change },
    DiffDelete = { fg = c.none, bg = c.diff_delete },
    DiffText = { fg = c.none, bg = c.diff_text },
    DiffAdded = { fg = c.green },
    DiffChanged = { fg = c.blue },
    DiffRemoved = { fg = c.red },
    DiffDeleted = { fg = c.red },
    DiffFile = { fg = c.cyan },
    DiffIndexLine = { fg = c.grey },
    Directory = { fg = c.blue },
    ErrorMsg = { fg = c.red, bold = true },
    WarningMsg = { fg = c.yellow, bold = true },
    MoreMsg = { fg = c.blue, bold = true },
    CurSearch = { fg = c.bg0, bg = c.orange },
    IncSearch = { fg = c.bg0, bg = c.orange },
    Search = { fg = c.bg0, bg = c.bg_yellow },
    Substitute = { fg = c.bg0, bg = c.green },
    MatchParen = { fg = c.none, bg = c.grey },
    NonText = { fg = c.grey },
    Whitespace = { fg = c.grey },
    SpecialKey = { fg = c.grey },
    Pmenu = { fg = c.fg, bg = c.bg1 },
    PmenuSbar = { fg = c.none, bg = c.bg1 },
    PmenuSel = { fg = c.bg0, bg = c.bg_blue },
    WildMenu = { fg = c.bg0, bg = c.blue },
    PmenuThumb = { fg = c.none, bg = c.grey },
    Question = { fg = c.yellow },
    SpellBad = { fg = c.none, undercurl = true, sp = c.red },
    SpellCap = { fg = c.none, undercurl = true, sp = c.yellow },
    SpellLocal = { fg = c.none, undercurl = true, sp = c.blue },
    SpellRare = { fg = c.none, undercurl = true, sp = c.purple },
    StatusLine = { fg = c.fg, bg = c.bg2 },
    StatusLineTerm = { fg = c.fg, bg = c.bg2 },
    StatusLineNC = { fg = c.grey, bg = c.bg1 },
    StatusLineTermNC = { fg = c.grey, bg = c.bg1 },
    TabLine = { fg = c.fg, bg = c.bg1 },
    TabLineFill = { fg = c.grey, bg = c.bg1 },
    TabLineSel = { fg = c.bg0, bg = c.fg },
    WinSeparator = { fg = c.bg3 },
    Visual = { bg = c.bg3 },
    VisualNOS = { fg = c.none, bg = c.bg2, underline = true },
    QuickFixLine = { fg = c.blue, underline = true },
    Debug = { fg = c.yellow },
    debugPC = { fg = c.bg0, bg = c.green },
    debugBreakpoint = { fg = c.bg0, bg = c.red },
    ToolbarButton = { fg = c.bg0, bg = c.bg_blue },
    FloatBorder = { fg = c.fg, bg = "none" },
    NormalFloat = { fg = c.fg, bg = c.bg0 },
  }

  hl.syntax = {
    String = F.extend({ fg = c.green }, code_style.strings),
    Character = { fg = c.orange },
    Number = { fg = c.orange },
    Float = { fg = c.orange },
    Boolean = { fg = c.orange },
    Type = { fg = c.yellow },
    Structure = { fg = c.yellow },
    StorageClass = { fg = c.yellow },
    Identifier = F.extend({ fg = c.red }, code_style.variables),
    Constant = { fg = c.cyan },
    PreProc = { fg = c.purple },
    PreCondit = { fg = c.purple },
    Include = { fg = c.purple },
    Keyword = F.extend({ fg = c.purple }, code_style.keywords),
    Define = { fg = c.purple },
    Typedef = { fg = c.yellow },
    Exception = { fg = c.purple },
    Conditional = F.extend({ fg = c.purple }, code_style.keywords),
    Repeat = F.extend({ fg = c.purple }, code_style.keywords),
    Statement = { fg = c.purple },
    Macro = { fg = c.red },
    Error = { fg = c.purple },
    Label = { fg = c.purple },
    Special = { fg = c.red },
    SpecialChar = { fg = c.red },
    Function = F.extend({ fg = c.blue }, code_style.functions),
    Operator = { fg = c.purple },
    Title = { fg = c.cyan },
    Tag = { fg = c.green },
    Delimiter = { fg = c.lightGrey },
    Comment = F.extend({ fg = c.grey }, code_style.comments),
    SpecialComment = F.extend({ fg = c.grey }, code_style.comments),
    Todo = F.extend({ fg = c.red }, code_style.comments),
  }

  hl.treesitter = {
    ["@annotation"] = { fg = c.fg },
    ["@attribute"] = { fg = c.cyan },
    ["@attribute.typescript"] = { fg = c.blue },
    ["@boolean"] = { fg = c.orange },
    ["@character"] = { fg = c.orange },
    ["@comment"] = F.extend({ fg = c.grey }, code_style.comments),
    ["@comment.todo"] = F.extend({ fg = c.red }, code_style.comments),
    ["@comment.todo.unchecked"] = F.extend({ fg = c.red }, code_style.comments),
    ["@comment.todo.checked"] = F.extend({ fg = c.green }, code_style.comments),
    ["@constant"] = F.extend({ fg = c.orange }, code_style.constants),
    ["@constant.builtin"] = F.extend({ fg = c.orange }, code_style.constants),
    ["@constant.macro"] = F.extend({ fg = c.orange }, code_style.constants),
    ["@constructor"] = { fg = c.yellow, bold = true },
    ["@diff.add"] = hl.common["DiffAdded"],
    ["@diff.delete"] = hl.common["DiffDeleted"],
    ["@diff.plus"] = hl.common["DiffAdded"],
    ["@diff.minus"] = hl.common["DiffDeleted"],
    ["@diff.delta"] = hl.common["DiffChanged"],
    ["@error"] = { fg = c.fg },
    ["@function"] = F.extend({ fg = c.blue }, code_style.functions),
    ["@function.builtin"] = F.extend({ fg = c.cyan }, code_style.functions),
    ["@function.macro"] = F.extend({ fg = c.cyan }, code_style.functions),
    ["@function.method"] = F.extend({ fg = c.blue }, code_style.functions),
    ["@keyword"] = F.extend({ fg = c.purple }, code_style.keywords),
    ["@keyword.conditional"] = F.extend({ fg = c.purple }, code_style.keywords),
    ["@keyword.directive"] = { fg = c.purple },
    ["@keyword.exception"] = { fg = c.purple },
    ["@keyword.function"] = F.extend({ fg = c.purple }, code_style.functions),
    ["@keyword.import"] = { fg = c.purple },
    ["@keyword.operator"] = F.extend({ fg = c.purple }, code_style.keywords),
    ["@keyword.repeat"] = F.extend({ fg = c.purple }, code_style.keywords),
    ["@label"] = { fg = c.red },
    ["@markup.emphasis"] = { fg = c.fg, italic = true },
    ["@markup.environment"] = { fg = c.fg },
    ["@markup.environment.name"] = { fg = c.fg },
    ["@markup.heading"] = { fg = c.orange, bold = true },
    ["@markup.link"] = { fg = c.blue },
    ["@markup.link.url"] = { fg = c.cyan, underline = true },
    ["@markup.list"] = { fg = c.red },
    ["@markup.math"] = { fg = c.fg },
    ["@markup.raw"] = { fg = c.green },
    ["@markup.strike"] = { fg = c.fg, strikethrough = true },
    ["@markup.strong"] = { fg = c.fg, bold = true },
    ["@markup.underline"] = { fg = c.fg, underline = true },
    ["@module"] = { fg = c.yellow },
    ["@none"] = { fg = c.fg },
    ["@number"] = { fg = c.orange },
    ["@number.float"] = { fg = c.orange },
    ["@operator"] = { fg = c.fg },
    ["@parameter.reference"] = { fg = c.fg },
    ["@property"] = { fg = c.cyan },
    ["@punctuation.delimiter"] = { fg = c.lightGrey },
    ["@punctuation.bracket"] = { fg = c.lightGrey },
    ["@string"] = F.extend({ fg = c.green }, code_style.strings),
    ["@string.regexp"] = F.extend({ fg = c.orange }, code_style.strings),
    ["@string.escape"] = F.extend({ fg = c.red }, code_style.strings),
    ["@string.special.symbol"] = { fg = c.cyan },
    ["@tag"] = { fg = c.purple },
    ["@tag.attribute"] = { fg = c.yellow },
    ["@tag.delimiter"] = { fg = c.purple },
    ["@text"] = { fg = c.fg },
    ["@note"] = { fg = c.fg },
    ["@warning"] = { fg = c.fg },
    ["@danger"] = { fg = c.fg },
    ["@type"] = { fg = c.yellow },
    ["@type.builtin"] = { fg = c.orange },
    ["@variable"] = F.extend({ fg = c.fg }, code_style.variables),
    ["@variable.builtin"] = F.extend({ fg = c.red }, code_style.variables),
    ["@variable.member"] = { fg = c.cyan },
    ["@variable.parameter"] = { fg = c.red },
    ["@markup.heading.1.markdown"] = { fg = c.red, bold = true },
    ["@markup.heading.2.markdown"] = { fg = c.purple, bold = true },
    ["@markup.heading.3.markdown"] = { fg = c.orange, bold = true },
    ["@markup.heading.4.markdown"] = { fg = c.red, bold = true },
    ["@markup.heading.5.markdown"] = { fg = c.purple, bold = true },
    ["@markup.heading.6.markdown"] = { fg = c.orange, bold = true },
    ["@markup.heading.1.marker.markdown"] = { fg = c.red, bold = true },
    ["@markup.heading.2.marker.markdown"] = { fg = c.purple, bold = true },
    ["@markup.heading.3.marker.markdown"] = { fg = c.orange, bold = true },
    ["@markup.heading.4.marker.markdown"] = { fg = c.red, bold = true },
    ["@markup.heading.5.marker.markdown"] = { fg = c.purple, bold = true },
    ["@markup.heading.6.marker.markdown"] = { fg = c.orange, bold = true },
  }

  hl.lsp = {
    ["@lsp.type.comment"] = hl.treesitter["@comment"],
    ["@lsp.type.enum"] = hl.treesitter["@type"],
    ["@lsp.type.enumMember"] = hl.treesitter["@constant.builtin"],
    ["@lsp.type.interface"] = hl.treesitter["@type"],
    ["@lsp.type.typeParameter"] = hl.treesitter["@type"],
    ["@lsp.type.keyword"] = hl.treesitter["@keyword"],
    ["@lsp.type.namespace"] = hl.treesitter["@module"],
    ["@lsp.type.parameter"] = hl.treesitter["@variable.parameter"],
    ["@lsp.type.property"] = hl.treesitter["@property"],
    ["@lsp.type.variable"] = hl.treesitter["@variable"],
    ["@lsp.type.macro"] = hl.treesitter["@function.macro"],
    ["@lsp.type.method"] = hl.treesitter["@function.method"],
    ["@lsp.type.number"] = hl.treesitter["@number"],
    ["@lsp.type.generic"] = hl.treesitter["@text"],
    ["@lsp.type.builtinType"] = hl.treesitter["@type.builtin"],
    ["@lsp.typemod.method.defaultLibrary"] = hl.treesitter["@function"],
    ["@lsp.typemod.function.defaultLibrary"] = hl.treesitter["@function"],
    ["@lsp.typemod.operator.injected"] = hl.treesitter["@operator"],
    ["@lsp.typemod.string.injected"] = hl.treesitter["@string"],
    ["@lsp.typemod.variable.defaultLibrary"] = hl.treesitter["@variable.builtin"],
    ["@lsp.typemod.variable.injected"] = hl.treesitter["@variable"],
    ["@lsp.typemod.variable.static"] = hl.treesitter["@constant"],

    LspReferenceText = { bg = c.bg2 },
    LspReferenceWrite = { bg = c.bg2 },
    LspReferenceRead = { bg = c.bg2 },

    LspCodeLens = F.extend({ fg = c.grey }, code_style.comments),
    LspCodeLensSeparator = { fg = c.grey },
  }

  hl.diagnostic = {
    DiagnosticError = { fg = c.red },
    DiagnosticHint = { fg = c.purple },
    DiagnosticInfo = { fg = c.cyan },
    DiagnosticWarn = { fg = c.yellow },

    DiagnosticVirtualTextError = { bg = c.none, fg = c.dark_red },
    DiagnosticVirtualTextWarn = { bg = c.none, fg = c.dark_yellow },
    DiagnosticVirtualTextInfo = { bg = c.none, fg = c.dark_cyan },
    DiagnosticVirtualTextHint = { bg = c.none, fg = c.dark_purple },

    DiagnosticUnderlineError = { sp = c.red, undercurl = true },
    DiagnosticUnderlineHint = { sp = c.purple, undercurl = true },
    DiagnosticUnderlineInfo = { sp = c.blue, undercurl = true },
    DiagnosticUnderlineWarn = { sp = c.yellow, undercurl = true },
  }

  return hl
end

---@param ... table Two or more tables
---@return table table Merged table
function F.extend(...) return vim.tbl_extend("force", ...) end

function F.once(fn)
  local called = false
  return function()
    if not called then
      fn()
      called = true
    end
  end
end

function F.apply_highlight(highlight)
  for group, hl in pairs(highlight) do
    vim.api.nvim_set_hl(0, group, hl)
  end
end

function F.init_autocmds()
  local group = vim.api.nvim_create_augroup("theme", {})

  -- Highilight yanked text for a short time
  vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    group = group,
    callback = function()
      -- Only highlight in normal mode, not in visual
      local mode = vim.api.nvim_get_mode()["mode"]
      if mode == "no" then
        vim.highlight.on_yank({
          higroup = "Visual",
          timeout = 75,
        })
      end
    end,
  })

  S.autocmds_loaded = true
end

function F.apply_theme()
  local theme = F.build_palette()
  local hl = F.build_highlights(theme, vim.o.background)
  for _, highlight in pairs(hl) do
    F.apply_highlight(highlight)
  end
  for _, highlight_fn in pairs(S.added_highlights) do
    local _, highlights = highlight_fn(theme[vim.o.background])
    F.apply_highlight(highlights)
  end
  vim.g.colors_name = "theme"
end

--- Add custom highlights and apply them immediately
---@param fn fun(palette: Palette): (string, table<string, vim.api.keyset.highlight>)
function F.add_highlights(fn)
  local theme = F.build_palette()
  local scope, highlights = fn(theme[vim.o.background])
  F.apply_highlight(highlights)
  S.added_highlights[scope] = fn
end

function F.setup()
  F.init_autocmds()
  -- Set cursorline (highlights set up to highlight only line number)
  vim.o.cursorline = true
end

return {
  setup = F.once(F.setup),
  apply_theme = F.apply_theme,
  add_highlights = F.add_highlights,
}
