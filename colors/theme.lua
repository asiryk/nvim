local M = {}

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
function M.init_theme()
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
  }

  return onedark
end

---@param theme Theme
function M.init_highlights(theme)
  local c = theme[vim.o.background]

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
    CursorLine = { bg = c.bg1 },
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
    FloatBorder = { fg = c.grey, bg = c.bg1 },
    NormalFloat = { fg = c.fg, bg = c.bg1 },
  }

  hl.syntax = {
    String = M.extend({ fg = c.green }, code_style.strings),
    Character = { fg = c.orange },
    Number = { fg = c.orange },
    Float = { fg = c.orange },
    Boolean = { fg = c.orange },
    Type = { fg = c.yellow },
    Structure = { fg = c.yellow },
    StorageClass = { fg = c.yellow },
    Identifier = M.extend({ fg = c.red }, code_style.variables),
    Constant = { fg = c.cyan },
    PreProc = { fg = c.purple },
    PreCondit = { fg = c.purple },
    Include = { fg = c.purple },
    Keyword = M.extend({ fg = c.purple }, code_style.keywords),
    Define = { fg = c.purple },
    Typedef = { fg = c.yellow },
    Exception = { fg = c.purple },
    Conditional = M.extend({ fg = c.purple }, code_style.keywords),
    Repeat = M.extend({ fg = c.purple }, code_style.keywords),
    Statement = { fg = c.purple },
    Macro = { fg = c.red },
    Error = { fg = c.purple },
    Label = { fg = c.purple },
    Special = { fg = c.red },
    SpecialChar = { fg = c.red },
    Function = M.extend({ fg = c.blue }, code_style.functions),
    Operator = { fg = c.purple },
    Title = { fg = c.cyan },
    Tag = { fg = c.green },
    Delimiter = { fg = c.lightGrey },
    Comment = M.extend({ fg = c.grey }, code_style.comments),
    SpecialComment = M.extend({ fg = c.grey }, code_style.comments),
    Todo = M.extend({ fg = c.red }, code_style.comments),
  }

  hl.treesitter = {
    ["@annotation"] = { fg = c.fg },
    ["@attribute"] = { fg = c.cyan },
    ["@attribute.typescript"] = { fg = c.blue },
    ["@boolean"] = { fg = c.orange },
    ["@character"] = { fg = c.orange },
    ["@comment"] = M.extend({ fg = c.grey }, code_style.comments),
    ["@comment.todo"] = M.extend({ fg = c.red }, code_style.comments),
    ["@comment.todo.unchecked"] = M.extend({ fg = c.red }, code_style.comments),
    ["@comment.todo.checked"] = M.extend({ fg = c.green }, code_style.comments),
    ["@constant"] = M.extend({ fg = c.orange }, code_style.constants),
    ["@constant.builtin"] = M.extend({ fg = c.orange }, code_style.constants),
    ["@constant.macro"] = M.extend({ fg = c.orange }, code_style.constants),
    ["@constructor"] = { fg = c.yellow, bold = true },
    ["@diff.add"] = hl.common["DiffAdded"],
    ["@diff.delete"] = hl.common["DiffDeleted"],
    ["@diff.plus"] = hl.common["DiffAdded"],
    ["@diff.minus"] = hl.common["DiffDeleted"],
    ["@diff.delta"] = hl.common["DiffChanged"],
    ["@error"] = { fg = c.fg },
    ["@function"] = M.extend({ fg = c.blue }, code_style.functions),
    ["@function.builtin"] = M.extend({ fg = c.cyan }, code_style.functions),
    ["@function.macro"] = M.extend({ fg = c.cyan }, code_style.functions),
    ["@function.method"] = M.extend({ fg = c.blue }, code_style.functions),
    ["@keyword"] = M.extend({ fg = c.purple }, code_style.keywords),
    ["@keyword.conditional"] = M.extend({ fg = c.purple }, code_style.keywords),
    ["@keyword.directive"] = { fg = c.purple },
    ["@keyword.exception"] = { fg = c.purple },
    ["@keyword.function"] = M.extend({ fg = c.purple }, code_style.functions),
    ["@keyword.import"] = { fg = c.purple },
    ["@keyword.operator"] = M.extend({ fg = c.purple }, code_style.keywords),
    ["@keyword.repeat"] = M.extend({ fg = c.purple }, code_style.keywords),
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
    ["@string"] = M.extend({ fg = c.green }, code_style.strings),
    ["@string.regexp"] = M.extend({ fg = c.orange }, code_style.strings),
    ["@string.escape"] = M.extend({ fg = c.red }, code_style.strings),
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
    ["@variable"] = M.extend({ fg = c.fg }, code_style.variables),
    ["@variable.builtin"] = M.extend({ fg = c.red }, code_style.variables),
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
  }

  return hl
end

---@param ... table Two or more tables
---@return table table Merged table
function M.extend(...) return vim.tbl_extend("force", ...) end

function M.apply_highlight(highlight)
  for group, hl in pairs(highlight) do
    vim.api.nvim_set_hl(0, group, hl)
  end
end

function M.setup()
  local theme = M.init_theme()
  local hl = M.init_highlights(theme)

  for _, highlight in pairs(hl) do
    M.apply_highlight(highlight)
  end
end

M.setup()
