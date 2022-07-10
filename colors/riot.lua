local NAME = "riot"
local BG = vim.o.background
local COLORS = {
  dark = {
    primary = "#191919",
    secondary = "#C5C8C6",
    keyword = "#E3AE2D",
    literal_str = "#4d8b31",
    literal_num = "#6897BB",
    literal_bool = "#62BEC1",
    parentheses = "#E3AE2D",
    comment = "#80A0FF",
    todo = "Red",
    test = "blue",
  }
}
local COLORSCHEME = {
  -- common
  StatusLine = {fg = COLORS[BG].primary, bg = COLORS[BG].secondary, bold = true},
  -- syntax
  String = { fg = COLORS[BG].literal_str },
  -- Character = { fg = COLORS[BG].todo }, -- TODO
  Number = { fg = COLORS[BG].literal_num },
  Float = { fg = COLORS[BG].literal_num },
  Boolean = { fg = COLORS[BG].literal_bool },
  Type = { fg = COLORS[BG].keyword }, -- primitive types, generics
  Structure = { fg = COLORS[BG].keyword }, -- usually curly braces around objects
  -- StorageClass = { fg = COLORS[BG].todo }, -- TODO
  Identifier = { fg = COLORS[BG].keyword }, -- "let", "const" keywords; type names
  Constant = { fg = COLORS[BG].literal_bool }, -- in Lua boolean
  PreProc = { fg = COLORS[BG].secondary }, -- in TS fn parameter names
  -- PreCondit = { fg = COLORS[BG].todo }, -- TODO
  -- Include = { fg = COLORS[BG].todo }, -- TODO
  Keyword = { fg = COLORS[BG].keyword }, -- most of the keywords
  -- Define = { fg = COLORS[BG].todo }, -- TODO
  -- Typedef = { fg = COLORS[BG].todo }, -- TODO
  Exception = { fg = COLORS[BG].keyword }, -- JS "throw"
  Conditional = { fg = COLORS[BG].keyword }, -- "if", "else"
  Repeat = { fg = COLORS[BG].keyword }, -- loops: "while", "for", etc..
  Statement = { fg = COLORS[BG].keyword }, -- "return", keywords e.g. "local", "end"
  -- Macro = { fg = COLORS[BG].todo }, -- TODO
  -- Error = { fg = COLORS[BG].todo },
  Label = { fg = COLORS[BG].secondary }, -- in TS object fields
  Special = { fg = COLORS[BG].keyword }, -- import, export
  -- SpecialChar = { fg = COLORS[BG].todo },
  Function = { fg = COLORS[BG].secondary }, -- works weird
  Operator = { fg = COLORS[BG].keyword }, -- works weird: in Lua "in" in TS "=", "," in types
  -- Title = { fg = COLORS[BG].todo },
  -- Tag = { fg = COLORS[BG].todo }, -- TODO
  -- Delimiter = { fg = COLORS[BG].todo }, -- TODO
  Comment = { fg = COLORS[BG].comment },
  -- SpecialComment = { fg = COLORS[BG].todo },
  Todo = { fg = "#aa6294" },

  -- treesitter
  TSAnnotation = { fg = COLORS[BG].todo },
  TSAttribute = { fg = COLORS[BG].todo },
  TSBoolean = { fg = COLORS[BG].todo },
  TSCharacter = { fg = COLORS[BG].todo },
  TSComment = { fg = COLORS[BG].todo },
  TSConditional = { fg = COLORS[BG].todo },
  TSConstant = { fg = COLORS[BG].todo },
  TSConstBuiltin = { fg = COLORS[BG].todo },
  TSConstMacro = { fg = COLORS[BG].todo },
  TSConstructor = { fg = COLORS[BG].todo },
  TSError = { fg = COLORS[BG].todo },
  TSException = { fg = COLORS[BG].todo },
  TSField = { fg = COLORS[BG].todo },
  TSFloat = { fg = COLORS[BG].todo },
  TSFunction = { fg = COLORS[BG].todo },
  TSFuncBuiltin = { fg = COLORS[BG].todo },
  TSFuncMacro = { fg = COLORS[BG].todo },
  TSInclude = { fg = COLORS[BG].todo },
  TSKeyword = { fg = COLORS[BG].todo },
  TSKeywordFunction = { fg = COLORS[BG].todo },
  TSKeywordOperator = { fg = COLORS[BG].todo },
  TSLabel = { fg = COLORS[BG].todo },
  TSMethod = { fg = COLORS[BG].todo },
  TSNamespace = { fg = COLORS[BG].todo },
  TSNone = { fg = COLORS[BG].todo },
  TSNumber = { fg = COLORS[BG].todo },
  TSOperator = { fg = COLORS[BG].todo },
  TSParameter = { fg = COLORS[BG].todo },
  TSParameterReference = { fg = COLORS[BG].todo },
  TSProperty = { fg = COLORS[BG].todo },
  TSPunctDelimiter = { fg = COLORS[BG].todo },
  TSPunctBracket = { fg = COLORS[BG].todo },
  TSPunctSpecial = { fg = COLORS[BG].todo },
  TSRepeat = { fg = COLORS[BG].todo },
  TSString = { fg = COLORS[BG].todo },
  TSStringRegex = { fg = COLORS[BG].todo },
  TSStringEscape = { fg = COLORS[BG].todo },
  TSSymbol = { fg = COLORS[BG].todo },
  TSTag = { fg = COLORS[BG].todo },
  TSTagDelimiter = { fg = COLORS[BG].todo },
  TSText = { fg = COLORS[BG].todo },
  TSStrong = { fg = COLORS[BG].todo },
  TSEmphasis = { fg = COLORS[BG].todo },
  TSUnderline = { fg = COLORS[BG].todo },
  TSStrike = { fg = COLORS[BG].todo },
  TSTitle = { fg = COLORS[BG].todo },
  TSLiteral = { fg = COLORS[BG].todo },
  TSURI = { fg = COLORS[BG].todo },
  TSMath = { fg = COLORS[BG].todo },
  TSTextReference = { fg = COLORS[BG].todo },
  TSEnviroment = { fg = COLORS[BG].todo },
  TSEnviromentName = { fg = COLORS[BG].todo },
  TSNote = { fg = COLORS[BG].todo },
  TSWarning = { fg = COLORS[BG].todo },
  TSDanger = { fg = COLORS[BG].todo },
  TSType = { fg = COLORS[BG].todo },
  TSTypeBuiltin = { fg = COLORS[BG].todo },
  TSVariable = { fg = COLORS[BG].todo },
  TSVariableBuiltin = { fg = COLORS[BG].todo },
  -- plugins
}

local function set_colorscheme()
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") then vim.cmd("syntax reset") end
  vim.g.colors_name = NAME
  for hi_group, value in pairs(COLORSCHEME) do
    vim.api.nvim_set_hl(0, hi_group, value)
  end
end

set_colorscheme()
print("riot color scheme")
-- vim.pretty_print(vim.api.nvim_get_hl_by_name("StatusLine", true))
