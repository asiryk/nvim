-- original https://github.com/vague-theme/vague.nvim/tree/main
local F = {}

---@class VaguePalette
---@field bg string
---@field inactiveBg string
---@field fg string
---@field floatBorder string
---@field line string
---@field comment string
---@field builtin string
---@field func string
---@field string string
---@field number string
---@field property string
---@field constant string
---@field parameter string
---@field visual string
---@field error string
---@field warning string
---@field hint string
---@field operator string
---@field keyword string
---@field type string
---@field search string
---@field plus string
---@field delta string

---@return VaguePalette
function F.build_palette()
  return {
    bg = "#141415",
    inactiveBg = "#1c1c24",
    fg = "#cdcdcd",
    floatBorder = "#878787",
    line = "#252530",
    comment = "#606079",
    builtin = "#b4d4cf",
    func = "#c48282",
    string = "#e8b589",
    number = "#e0a363",
    property = "#c3c3d5",
    constant = "#aeaed1",
    parameter = "#bb9dbd",
    visual = "#333738",
    error = "#d8647e",
    warning = "#f3be7c",
    hint = "#7e98e8",
    operator = "#90a0b5",
    keyword = "#6e94b2",
    type = "#9bb4bc",
    search = "#405065",
    plus = "#7fa563",
    delta = "#f3be7c",
  }
end

---@param color string
local function color_to_rgb(color)
  local function byte(value, offset) return bit.band(bit.rshift(value, offset), 0xFF) end

  local new_color = vim.api.nvim_get_color_by_name(color)
  if new_color == -1 then new_color = vim.opt.background:get() == "dark" and 000 or 255255255 end

  return { byte(new_color, 16), byte(new_color, 8), byte(new_color, 0) }
end

---@param color string Color to blend
---@param base_color string Base color to blend on
---@param alpha number Between 0 (background) and 1 (foreground)
---@return string
local function blend(color, base_color, alpha)
  local fg_rgb = color_to_rgb(color)
  local bg_rgb = color_to_rgb(base_color)

  local function blend_channel(i)
    local ret = (alpha * fg_rgb[i] + ((1 - alpha) * bg_rgb[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string.format("#%02X%02X%02X", blend_channel(1), blend_channel(2), blend_channel(3))
end

---@return table<string, vim.api.keyset.highlight>
function F.build_highlights()
  local c = F.build_palette()

  local code_style = {
    comments = { italic = true },
    keywords = {},
    functions = {},
    strings = { italic = true },
    variables = {},
    constants = {},
  }

  ---@type table<string, vim.api.keyset.highlight>
  local hl = {}

  hl.common = {
    Normal = { fg = c.fg, bg = c.bg },
    Terminal = { fg = c.fg, bg = c.bg },
    EndOfBuffer = { fg = c.comment, bg = c.bg },
    FoldColumn = { fg = c.comment, bg = c.bg },
    Folded = { fg = c.comment, bg = c.line },
    SignColumn = { fg = c.fg, bg = c.bg },
    ToolbarLine = { fg = c.fg },
    Cursor = { reverse = true },
    vCursor = { reverse = true },
    iCursor = { reverse = true },
    lCursor = { reverse = true },
    CursorIM = { reverse = true },
    CursorColumn = { bg = c.line },
    CursorLine = { bg = c.line },
    ColorColumn = { bg = c.line },
    CursorLineNr = { fg = c.fg },
    LineNr = { fg = c.comment },
    Conceal = { fg = c.func },
    Added = { fg = c.plus },
    Removed = { fg = c.error },
    Changed = { fg = c.delta },
    DiffAdd = { bg = blend(c.plus, c.bg, 0.2) },
    DiffChange = { bg = blend(c.delta, c.bg, 0.2) },
    DiffDelete = { bg = blend(c.error, c.bg, 0.2) },
    DiffText = { bg = blend(c.delta, c.bg, 0.4) },
    DiffAdded = { fg = c.plus },
    DiffChanged = { fg = c.delta },
    DiffRemoved = { fg = c.error },
    DiffDeleted = { fg = c.error },
    DiffFile = { fg = c.keyword },
    DiffIndexLine = { fg = c.comment },
    Directory = { fg = c.hint },
    ErrorMsg = { fg = c.error, bold = true },
    WarningMsg = { fg = c.warning, bold = true },
    MoreMsg = { fg = c.func, bold = true },
    CurSearch = { fg = c.fg, bg = c.search },
    IncSearch = { fg = c.bg, bg = c.search },
    Search = { fg = c.fg, bg = c.search },
    Substitute = { fg = c.type, bg = c.visual },
    MatchParen = { fg = c.fg, bg = c.visual },
    NonText = { fg = c.comment },
    Whitespace = { fg = c.line },
    SpecialKey = { fg = c.comment },
    Pmenu = { fg = c.fg },
    PmenuSbar = { bg = c.line },
    PmenuSel = { fg = c.constant, bg = c.line },
    WildMenu = { fg = c.bg, bg = c.func },
    PmenuThumb = { bg = c.comment },
    Question = { fg = c.constant },
    SpellBad = { undercurl = true },
    SpellCap = { undercurl = true },
    SpellLocal = { undercurl = true },
    SpellRare = { undercurl = true },
    StatusLine = { fg = c.fg, bg = c.inactiveBg },
    StatusLineTerm = { fg = c.fg, bg = c.inactiveBg },
    StatusLineNC = { fg = c.comment },
    StatusLineTermNC = { fg = c.comment },
    TabLine = { fg = c.fg, bg = c.line },
    TabLineFill = { fg = c.comment, bg = c.line },
    TabLineSel = { fg = c.bg, bg = c.fg },
    WinSeparator = { fg = c.floatBorder },
    Visual = { bg = c.visual },
    VisualNOS = { bg = c.comment, underline = true },
    QuickFixLine = { fg = c.func, underline = true },
    Debug = { fg = c.constant },
    debugPC = { fg = c.bg, bg = c.fg },
    debugBreakpoint = { fg = c.bg, bg = c.operator },
    ToolbarButton = { fg = c.bg, bg = c.visual },
    FloatBorder = { fg = c.floatBorder, bg = "none" },
    NormalFloat = { fg = c.fg, bg = c.bg },
  }

  hl.syntax = {
    String = F.extend({ fg = c.string }, code_style.strings),
    Character = { fg = c.string },
    Number = { fg = c.number },
    Float = { fg = c.number },
    Boolean = { fg = c.number, bold = true },
    Type = { fg = c.type },
    Structure = { fg = c.constant },
    StorageClass = { fg = c.constant },
    Identifier = F.extend({ fg = c.constant }, code_style.variables),
    Constant = { fg = c.constant },
    PreProc = { fg = c.constant },
    PreCondit = { fg = c.comment },
    Include = { fg = c.keyword },
    Keyword = F.extend({ fg = c.keyword }, code_style.keywords),
    Define = { fg = c.comment },
    Typedef = { fg = c.constant },
    Exception = { fg = c.keyword },
    Conditional = F.extend({ fg = c.keyword }, code_style.keywords),
    Repeat = F.extend({ fg = c.keyword }, code_style.keywords),
    Statement = { fg = c.keyword },
    Macro = { fg = c.constant },
    Error = { fg = c.error, bold = true },
    Label = { fg = c.keyword },
    Special = { fg = c.builtin },
    SpecialChar = { fg = c.keyword },
    Function = F.extend({ fg = c.func }, code_style.functions),
    Operator = { fg = c.operator },
    Title = { fg = c.property },
    Tag = { fg = c.builtin },
    Delimiter = { fg = c.fg },
    Comment = F.extend({ fg = c.comment }, code_style.comments),
    SpecialComment = { fg = c.keyword },
    Todo = F.extend({ fg = c.func }, code_style.comments),
  }

  hl.treesitter = {
    ["@annotation"] = { fg = c.fg },
    ["@attribute"] = hl.syntax["Constant"],
    ["@attribute.typescript"] = { fg = c.hint },
    ["@boolean"] = hl.syntax["Boolean"],
    ["@character"] = hl.syntax["String"],
    ["@character.special"] = hl.syntax["SpecialChar"],
    ["@comment"] = F.extend({ fg = c.comment }, code_style.comments),
    ["@comment.todo"] = F.extend({ fg = c.func }, code_style.comments),
    ["@comment.todo.unchecked"] = F.extend({ fg = c.func }, code_style.comments),
    ["@comment.todo.checked"] = F.extend({ fg = c.plus }, code_style.comments),
    ["@constant"] = hl.syntax["Constant"],
    ["@constant.builtin"] = { fg = c.number, bold = true },
    ["@constant.macro"] = { fg = c.number },
    ["@constructor"] = { fg = c.constant },
    ["@constructor.lua"] = { fg = c.type },
    ["@diff.add"] = hl.common["DiffAdded"],
    ["@diff.delete"] = hl.common["DiffDeleted"],
    ["@diff.plus"] = hl.common["DiffAdded"],
    ["@diff.minus"] = hl.common["DiffDeleted"],
    ["@diff.delta"] = hl.common["DiffChanged"],
    ["@error"] = { fg = c.fg },
    ["@function"] = F.extend({ fg = c.func }, code_style.functions),
    ["@function.builtin"] = { fg = c.func },
    ["@function.call"] = { fg = c.parameter },
    ["@function.macro"] = hl.syntax["Macro"],
    ["@function.method"] = F.extend({ fg = c.func }, code_style.functions),
    ["@function.method.call"] = { fg = c.type },
    ["@keyword"] = F.extend({ fg = c.keyword }, code_style.keywords),
    ["@keyword.conditional"] = F.extend({ fg = c.keyword }, code_style.keywords),
    ["@keyword.directive"] = { fg = c.keyword },
    ["@keyword.exception"] = hl.syntax["Exception"],
    ["@keyword.function"] = F.extend({ fg = c.keyword }, code_style.functions),
    ["@keyword.import"] = hl.syntax["PreProc"],
    ["@keyword.operator"] = { fg = c.keyword },
    ["@keyword.repeat"] = F.extend({ fg = c.keyword }, code_style.keywords),
    ["@keyword.return"] = { fg = c.keyword, italic = true },
    ["@label"] = hl.syntax["Label"],
    ["@markup"] = { fg = c.fg },
    ["@markup.emphasis"] = { fg = c.fg, italic = true },
    ["@markup.environment"] = { fg = c.fg },
    ["@markup.environment.name"] = { fg = c.fg },
    ["@markup.heading"] = { fg = c.keyword, bold = true },
    ["@markup.italic"] = { fg = c.fg, italic = true },
    ["@markup.link"] = { fg = c.string },
    ["@markup.link.url"] = { fg = c.string, underline = true },
    ["@markup.list"] = { fg = c.func },
    ["@markup.math"] = { fg = c.string },
    ["@markup.quote.markdown"] = { fg = c.comment },
    ["@markup.raw"] = { fg = c.constant },
    ["@markup.strike"] = { fg = c.comment, strikethrough = true },
    ["@markup.strong"] = { fg = c.fg, bold = true },
    ["@markup.underline"] = { fg = c.fg, underline = true },
    ["@module"] = hl.syntax["Constant"],
    ["@none"] = { fg = c.fg },
    ["@number"] = hl.syntax["Number"],
    ["@number.float"] = hl.syntax["Float"],
    ["@operator"] = hl.syntax["Operator"],
    ["@parameter.reference"] = { fg = c.fg },
    ["@property"] = { fg = c.property },
    ["@punctuation.delimiter"] = { fg = c.fg },
    ["@punctuation.bracket"] = { fg = c.fg },
    ["@punctuation.special"] = hl.syntax["SpecialChar"],
    ["@string"] = F.extend({ fg = c.string }, code_style.strings),
    ["@string.regexp"] = hl.syntax["SpecialChar"],
    ["@string.escape"] = hl.syntax["SpecialChar"],
    ["@string.special.symbol"] = hl.syntax["Identifier"],
    ["@string.special.url"] = { fg = c.func },
    ["@tag"] = { fg = c.keyword },
    ["@tag.attribute"] = hl.syntax["Identifier"],
    ["@tag.delimiter"] = { fg = c.fg },
    ["@text"] = { fg = c.fg },
    ["@note"] = { fg = c.fg },
    ["@warning"] = { fg = c.fg },
    ["@danger"] = { fg = c.fg },
    ["@type"] = hl.syntax["Type"],
    ["@type.builtin"] = { fg = c.builtin, bold = true },
    ["@type.declaration"] = { fg = c.constant },
    ["@type.definition"] = hl.syntax["Typedef"],
    ["@variable"] = F.extend({ fg = c.fg }, code_style.variables),
    ["@variable.builtin"] = { fg = c.builtin },
    ["@variable.member"] = { fg = c.builtin },
    ["@variable.parameter"] = { fg = c.parameter },
    ["@markup.heading.1.markdown"] = { fg = c.error, bold = true },
    ["@markup.heading.2.markdown"] = { fg = c.keyword, bold = true },
    ["@markup.heading.3.markdown"] = { fg = c.number, bold = true },
    ["@markup.heading.4.markdown"] = { fg = c.error, bold = true },
    ["@markup.heading.5.markdown"] = { fg = c.keyword, bold = true },
    ["@markup.heading.6.markdown"] = { fg = c.number, bold = true },
    ["@markup.heading.1.marker.markdown"] = { fg = c.error, bold = true },
    ["@markup.heading.2.marker.markdown"] = { fg = c.keyword, bold = true },
    ["@markup.heading.3.marker.markdown"] = { fg = c.number, bold = true },
    ["@markup.heading.4.marker.markdown"] = { fg = c.error, bold = true },
    ["@markup.heading.5.marker.markdown"] = { fg = c.keyword, bold = true },
    ["@markup.heading.6.marker.markdown"] = { fg = c.number, bold = true },
  }

  hl.lsp = {
    ["@lsp.type.comment"] = hl.treesitter["@comment"],
    ["@lsp.type.enum"] = hl.syntax["Structure"],
    ["@lsp.type.enumMember"] = hl.treesitter["@variable.member"],
    ["@lsp.type.interface"] = hl.syntax["Structure"],
    ["@lsp.type.typeParameter"] = hl.syntax["Typedef"],
    ["@lsp.type.keyword"] = hl.treesitter["@keyword"],
    ["@lsp.type.namespace"] = hl.treesitter["@module"],
    ["@lsp.type.parameter"] = hl.treesitter["@variable.parameter"],
    ["@lsp.type.property"] = hl.treesitter["@type"],
    ["@lsp.type.variable"] = hl.treesitter["@constant"],
    ["@lsp.type.macro"] = hl.syntax["Macro"],
    ["@lsp.type.method"] = hl.treesitter["@function.method"],
    ["@lsp.type.number"] = hl.treesitter["@number"],
    ["@lsp.type.generic"] = hl.treesitter["@type"],
    ["@lsp.type.builtinType"] = hl.treesitter["@type.builtin"],
    ["@lsp.type.builtinConstant"] = hl.treesitter["@constant.builtin"],
    ["@lsp.type.class"] = hl.syntax["Structure"],
    ["@lsp.type.function"] = hl.treesitter["@function.call"],
    ["@lsp.type.selfParameter"] = hl.syntax["Special"],
    ["@lsp.typemod.method.defaultLibrary"] = hl.treesitter["@function.builtin"],
    ["@lsp.typemod.function.defaultLibrary"] = hl.treesitter["@function.builtin"],
    ["@lsp.typemod.function.builtin"] = hl.treesitter["@function.builtin"],
    ["@lsp.typemod.function.definition"] = hl.treesitter["@function"],
    ["@lsp.typemod.function"] = hl.treesitter["@function.call"],
    ["@lsp.typemod.operator.injected"] = hl.treesitter["@operator"],
    ["@lsp.typemod.string.injected"] = hl.treesitter["@string"],
    ["@lsp.typemod.variable.defaultLibrary"] = hl.treesitter["@constant.builtin"],
    ["@lsp.typemod.variable.injected"] = hl.treesitter["@variable"],
    ["@lsp.typemod.variable.static"] = hl.treesitter["@constant"],
    ["@lsp.typemod.variable.definition"] = hl.treesitter["@property"],

    LspReferenceText = { bg = c.comment },
    LspReferenceWrite = { bg = c.comment },
    LspReferenceRead = { bg = c.comment },

    LspCodeLens = F.extend({ fg = c.comment }, code_style.comments),
    LspCodeLensSeparator = { fg = c.comment },
  }

  hl.diagnostic = {
    DiagnosticError = { fg = c.error, bold = true },
    DiagnosticHint = { fg = c.hint },
    DiagnosticInfo = { fg = c.constant, italic = true },
    DiagnosticWarn = { fg = c.warning, bold = true },
    DiagnosticOk = { fg = c.plus },

    DiagnosticVirtualTextError = { fg = c.error, bold = true },
    DiagnosticVirtualTextWarn = { fg = c.warning, bold = true },
    DiagnosticVirtualTextInfo = { fg = c.constant, italic = true },
    DiagnosticVirtualTextHint = { fg = c.hint },
    DiagnosticVirtualTextOk = { fg = c.plus },

    DiagnosticUnderlineError = { sp = c.error, undercurl = true },
    DiagnosticUnderlineHint = { sp = c.hint, undercurl = true },
    DiagnosticUnderlineInfo = { sp = c.constant, undercurl = true },
    DiagnosticUnderlineWarn = { sp = c.delta, undercurl = true },
    DiagnosticUnderlineOk = { sp = c.plus, undercurl = true },
  }

  return hl
end

---@param ... table Two or more tables
---@return table table Merged table
function F.extend(...) return vim.tbl_extend("force", ...) end

return {
  build_palette = F.build_palette,
  build_highlights = F.build_highlights,
}
