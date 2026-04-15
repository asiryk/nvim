-- stylua: ignore start

-- Single source of truth for all base Neovim highlights.
--
-- Shape per group:
--   PerPalette:  { vague = { <spec> }, onedark = { <spec> } }
--     - Both keys are required (drift assert in theme.lua enforces it).
--     - String values that match a palette key are resolved to that color;
--       anything else ("none", "#aabbcc", true, numbers, links) passes through.
--     - Shared traits (italic/bold) are duplicated in both halves explicitly.
--   PaletteAgnostic: any table without `vague` or `onedark` keys, e.g.
--     { reverse = true } or { link = "Search" }. Applied as-is.
--
-- Clusters below are alphabetical; groups inside each cluster are alphabetical.
-- Plugin-specific highlights live next to their plugin via theme.add_highlights().
--
--@alias VagueColor
---| "bg" | "inactiveBg" | "fg" | "floatBorder" | "line" | "comment"
---| "builtin" | "func" | "string" | "number" | "property" | "constant"
---| "parameter" | "visual" | "error" | "warning" | "hint" | "operator"
---| "keyword" | "type" | "search" | "plus" | "delta"
--
--@alias OneDarkColor
---| "black" | "bg0" | "bg1" | "bg2" | "bg3" | "bg_d" | "bg_hl"
---| "bg_blue" | "bg_yellow" | "fg" | "purple" | "green" | "orange"
---| "blue" | "yellow" | "cyan" | "red" | "grey" | "light_grey"
---| "dark_cyan" | "dark_red" | "dark_yellow" | "dark_purple"
---| "diff_add" | "diff_delete" | "diff_change" | "diff_text"

return {
  -- ─────────────────────────── Base UI ───────────────────────────

  ColorColumn      = { vague = { bg = "line" },                        onedark = { bg = "bg1" } },
  Conceal          = { vague = { fg = "func" },                        onedark = { fg = "grey" } },
  Cursor           = { reverse = true },
  CursorColumn     = { vague = { bg = "line" },                        onedark = { bg = "bg1" } },
  CursorIM         = { reverse = true },
  CursorLine       = { vague = { bg = "none" },                        onedark = { bg = "none" } },
  CursorLineNr     = { vague = { fg = "fg" },                          onedark = { fg = "fg" } },
  Debug            = { vague = { fg = "constant" },                    onedark = { fg = "yellow" } },
  Directory        = { vague = { fg = "hint" },                        onedark = { fg = "blue" } },
  EndOfBuffer      = { vague = { fg = "comment", bg = "bg" },          onedark = { fg = "bg0", bg = "bg0" } },
  ErrorMsg         = { vague = { fg = "error", bold = true },          onedark = { fg = "red", bold = true } },
  FoldColumn       = { vague = { fg = "comment", bg = "bg" },          onedark = { fg = "fg", bg = "bg1" } },
  Folded           = { vague = { fg = "comment", bg = "line" },        onedark = { fg = "fg", bg = "bg1" } },
  LineNr           = { vague = { fg = "comment" },                     onedark = { fg = "grey" } },
  MoreMsg          = { vague = { fg = "func", bold = true },           onedark = { fg = "blue", bold = true } },
  NonText          = { vague = { fg = "comment" },                     onedark = { fg = "grey" } },
  Normal           = { vague = { fg = "fg", bg = "bg" },               onedark = { fg = "fg", bg = "bg0" } },
  Question         = { vague = { fg = "constant" },                    onedark = { fg = "yellow" } },
  QuickFixLine     = { vague = { fg = "func", underline = true },      onedark = { fg = "blue", underline = true } },
  SignColumn       = { vague = { fg = "fg", bg = "bg" },               onedark = { fg = "fg", bg = "bg0" } },
  SpecialKey       = { vague = { fg = "comment" },                     onedark = { fg = "grey" } },
  Terminal         = { vague = { fg = "fg", bg = "bg" },               onedark = { fg = "fg", bg = "bg0" } },
  ToolbarButton    = { vague = { fg = "bg", bg = "visual" },           onedark = { fg = "bg0", bg = "bg_blue" } },
  ToolbarLine      = { vague = { fg = "fg" },                          onedark = { fg = "fg" } },
  Visual           = { vague = { bg = "visual" },                      onedark = { bg = "bg3" } },
  VisualNOS        = { vague = { bg = "comment", underline = true },   onedark = { fg = "none", bg = "bg2", underline = true } },
  WarningMsg       = { vague = { fg = "warning", bold = true },        onedark = { fg = "yellow", bold = true } },
  Whitespace       = { vague = { fg = "line" },                        onedark = { fg = "grey" } },
  WinSeparator     = { vague = { fg = "floatBorder" },                 onedark = { fg = "bg3" } },
  debugBreakpoint  = { vague = { fg = "bg", bg = "operator" },         onedark = { fg = "bg0", bg = "red" } },
  debugPC          = { vague = { fg = "bg", bg = "fg" },               onedark = { fg = "bg0", bg = "green" } },
  iCursor          = { reverse = true },
  lCursor          = { reverse = true },
  vCursor          = { reverse = true },

  -- ───────────────────────── Diagnostic ──────────────────────────

  DiagnosticError             = { vague = { fg = "error", bold = true },                onedark = { fg = "red" } },
  DiagnosticHint              = { vague = { fg = "hint" },                              onedark = { fg = "purple" } },
  DiagnosticInfo              = { vague = { fg = "constant", italic = true },           onedark = { fg = "cyan" } },
  DiagnosticOk                = { vague = { fg = "plus" },                              onedark = { fg = "green" } },
  DiagnosticWarn              = { vague = { fg = "warning", bold = true },              onedark = { fg = "yellow" } },

  DiagnosticUnderlineError    = { vague = { sp = "error", undercurl = true },           onedark = { sp = "red", undercurl = true } },
  DiagnosticUnderlineHint     = { vague = { sp = "hint", undercurl = true },            onedark = { sp = "purple", undercurl = true } },
  DiagnosticUnderlineInfo     = { vague = { sp = "constant", undercurl = true },        onedark = { sp = "blue", undercurl = true } },
  DiagnosticUnderlineOk       = { vague = { sp = "plus", undercurl = true },            onedark = { sp = "green", undercurl = true } },
  DiagnosticUnderlineWarn     = { vague = { sp = "delta", undercurl = true },           onedark = { sp = "yellow", undercurl = true } },

  DiagnosticVirtualTextError  = { vague = { fg = "error", bold = true },                onedark = { bg = "none", fg = "dark_red" } },
  DiagnosticVirtualTextHint   = { vague = { fg = "hint" },                              onedark = { bg = "none", fg = "dark_purple" } },
  DiagnosticVirtualTextInfo   = { vague = { fg = "constant", italic = true },           onedark = { bg = "none", fg = "dark_cyan" } },
  DiagnosticVirtualTextOk     = { vague = { fg = "plus" },                              onedark = { bg = "none", fg = "green" } },
  DiagnosticVirtualTextWarn   = { vague = { fg = "warning", bold = true },              onedark = { bg = "none", fg = "dark_yellow" } },

  -- ───────────────────────── Diff / VCS ──────────────────────────
  -- vague Diff* backgrounds are pre-blended:
  --   DiffAdd    = blend(plus,  bg, 0.2) = #293125
  --   DiffChange = blend(delta, bg, 0.2) = #262E34
  --   DiffDelete = blend(error, bg, 0.2) = #3B242A
  --   DiffText   = blend(delta, bg, 0.4) = #384754

  Added         = { vague = { fg = "plus" },                     onedark = { fg = "green" } },
  Changed       = { vague = { fg = "delta" },                    onedark = { fg = "blue" } },
  DiffAdd       = { vague = { bg = "#293125" },                  onedark = { fg = "none", bg = "diff_add" } },
  DiffAdded     = { vague = { fg = "plus" },                     onedark = { fg = "green" } },
  DiffChange    = { vague = { bg = "#262E34" },                  onedark = { fg = "none", bg = "diff_change" } },
  DiffChanged   = { vague = { fg = "delta" },                    onedark = { fg = "blue" } },
  DiffDelete    = { vague = { bg = "#3B242A" },                  onedark = { fg = "none", bg = "diff_delete" } },
  DiffDeleted   = { vague = { fg = "error" },                    onedark = { fg = "red" } },
  DiffFile      = { vague = { fg = "keyword" },                  onedark = { fg = "cyan" } },
  DiffIndexLine = { vague = { fg = "comment" },                  onedark = { fg = "grey" } },
  DiffRemoved   = { vague = { fg = "error" },                    onedark = { fg = "red" } },
  DiffText      = { vague = { bg = "#384754" },                  onedark = { fg = "none", bg = "diff_text" } },
  Removed       = { vague = { fg = "error" },                    onedark = { fg = "red" } },

  -- ──────────────────── Float / Popup / Menu ─────────────────────

  FloatBorder = { vague = { fg = "floatBorder", bg = "none" },   onedark = { fg = "fg", bg = "none" } },
  NormalFloat = { vague = { fg = "fg", bg = "bg" },              onedark = { fg = "fg", bg = "bg0" } },
  Pmenu       = { vague = { fg = "fg" },                         onedark = { fg = "fg", bg = "bg1" } },
  PmenuSbar   = { vague = { bg = "line" },                       onedark = { fg = "none", bg = "bg1" } },
  PmenuSel    = { vague = { fg = "constant", bg = "line" },      onedark = { fg = "bg0", bg = "bg_blue" } },
  PmenuThumb  = { vague = { bg = "comment" },                    onedark = { fg = "none", bg = "grey" } },
  WildMenu    = { vague = { fg = "bg", bg = "func" },            onedark = { fg = "bg0", bg = "blue" } },

  -- ─────────────────────────── LSP ───────────────────────────────

  LspCodeLens          = { vague = { fg = "comment", italic = true },   onedark = { fg = "grey", italic = true } },
  LspCodeLensSeparator = { vague = { fg = "comment" },                  onedark = { fg = "grey" } },
  LspReferenceRead     = { vague = { bg = "comment" },                  onedark = { bg = "bg2" } },
  LspReferenceTarget   = { vague = { bg = "search" },                   onedark = { bg = "diff_text" } },
  LspReferenceText     = { vague = { bg = "comment" },                  onedark = { bg = "bg2" } },
  LspReferenceWrite    = { vague = { bg = "comment" },                  onedark = { bg = "bg2" } },

  ["@lsp.type.builtinType"]              = { vague = { fg = "builtin", bold = true },   onedark = { fg = "orange" } },
  ["@lsp.type.comment"]                  = { vague = { fg = "comment", italic = true }, onedark = { fg = "grey", italic = true } },
  ["@lsp.type.enum"]                     = { vague = { fg = "constant" },               onedark = { fg = "yellow" } },
  ["@lsp.type.enumMember"]               = { vague = { fg = "builtin" },                onedark = { fg = "orange" } },
  ["@lsp.type.generic"]                  = { vague = { fg = "builtin" },                onedark = { fg = "fg" } },
  ["@lsp.type.interface"]                = { vague = { fg = "constant" },               onedark = { fg = "yellow" } },
  ["@lsp.type.keyword"]                  = { vague = { fg = "keyword" },                onedark = { fg = "purple" } },
  ["@lsp.type.macro"]                    = { vague = { fg = "constant" },               onedark = { fg = "cyan" } },
  ["@lsp.type.method"]                   = { vague = { fg = "func" },                   onedark = { fg = "blue" } },
  ["@lsp.type.namespace"]                = { vague = { fg = "constant" },               onedark = { fg = "yellow" } },
  ["@lsp.type.number"]                   = { vague = { fg = "number" },                 onedark = { fg = "orange" } },
  ["@lsp.type.parameter"]                = { vague = { fg = "parameter" },              onedark = { fg = "red" } },
  ["@lsp.type.property"]                 = { vague = { fg = "builtin" },                onedark = { fg = "cyan" } },
  ["@lsp.type.typeParameter"]            = { vague = { fg = "constant" },               onedark = { fg = "yellow" } },
  ["@lsp.type.variable"]                 = { vague = { fg = "fg" },                     onedark = { fg = "fg" } },

  ["@lsp.typemod.function.defaultLibrary"] = { vague = { fg = "func" },                 onedark = { fg = "blue" } },
  ["@lsp.typemod.method.defaultLibrary"]   = { vague = { fg = "func" },                 onedark = { fg = "blue" } },
  ["@lsp.typemod.operator.injected"]       = { vague = { fg = "operator" },             onedark = { fg = "fg" } },
  ["@lsp.typemod.string.injected"]         = { vague = { fg = "string", italic = true },onedark = { fg = "green" } },
  ["@lsp.typemod.variable.defaultLibrary"] = { vague = { fg = "number", bold = true },  onedark = { fg = "red" } },
  ["@lsp.typemod.variable.injected"]       = { vague = { fg = "fg" },                   onedark = { fg = "fg" } },
  ["@lsp.typemod.variable.static"]         = { vague = { fg = "constant" },             onedark = { fg = "orange" } },

  -- ───────────────────────── Search / Match ──────────────────────

  CurSearch  = { vague = { fg = "fg", bg = "search" },       onedark = { fg = "bg0", bg = "orange" } },
  IncSearch  = { vague = { fg = "bg", bg = "search" },       onedark = { fg = "bg0", bg = "orange" } },
  MatchParen = { vague = { fg = "fg", bg = "visual" },       onedark = { fg = "none", bg = "grey" } },
  Search     = { vague = { fg = "fg", bg = "search" },       onedark = { fg = "bg0", bg = "bg_yellow" } },
  Substitute = { vague = { fg = "type", bg = "visual" },     onedark = { fg = "bg0", bg = "green" } },

  -- ─────────────────────────── Spell ─────────────────────────────

  SpellBad   = { vague = { undercurl = true },   onedark = { fg = "none", undercurl = true, sp = "red" } },
  SpellCap   = { vague = { undercurl = true },   onedark = { fg = "none", undercurl = true, sp = "yellow" } },
  SpellLocal = { vague = { undercurl = true },   onedark = { fg = "none", undercurl = true, sp = "blue" } },
  SpellRare  = { vague = { undercurl = true },   onedark = { fg = "none", undercurl = true, sp = "purple" } },

  -- ─────────────────── Statusline / Tabline ──────────────────────

  StatusLine       = { vague = { fg = "fg", bg = "inactiveBg" },      onedark = { fg = "fg", bg = "bg2" } },
  StatusLineNC     = { vague = { fg = "comment" },                    onedark = { fg = "grey", bg = "bg1" } },
  StatusLineTerm   = { vague = { fg = "fg", bg = "inactiveBg" },      onedark = { fg = "fg", bg = "bg2" } },
  StatusLineTermNC = { vague = { fg = "comment" },                    onedark = { fg = "grey", bg = "bg1" } },
  TabLine          = { vague = { fg = "fg", bg = "line" },            onedark = { fg = "fg", bg = "bg1" } },
  TabLineFill      = { vague = { fg = "comment", bg = "line" },       onedark = { fg = "grey", bg = "bg1" } },
  TabLineSel       = { vague = { fg = "bg", bg = "fg" },              onedark = { fg = "bg0", bg = "fg" } },

  -- ─────────────────────── Syntax (vim-native) ───────────────────

  Boolean        = { vague = { fg = "number", bold = true },         onedark = { fg = "orange" } },
  Character      = { vague = { fg = "string" },                      onedark = { fg = "orange" } },
  Comment        = { vague = { fg = "comment", italic = true },      onedark = { fg = "grey", italic = true } },
  Conditional    = { vague = { fg = "keyword" },                     onedark = { fg = "purple" } },
  Constant       = { vague = { fg = "constant" },                    onedark = { fg = "cyan" } },
  Define         = { vague = { fg = "comment" },                     onedark = { fg = "purple" } },
  Delimiter      = { vague = { fg = "fg" },                          onedark = { fg = "light_grey" } },
  Error          = { vague = { fg = "error", bold = true },          onedark = { fg = "purple" } },
  Exception      = { vague = { fg = "keyword" },                     onedark = { fg = "purple" } },
  Float          = { vague = { fg = "number" },                      onedark = { fg = "orange" } },
  Function       = { vague = { fg = "func" },                        onedark = { fg = "blue" } },
  Identifier     = { vague = { fg = "constant" },                    onedark = { fg = "red" } },
  Include        = { vague = { fg = "keyword" },                     onedark = { fg = "purple" } },
  Keyword        = { vague = { fg = "keyword" },                     onedark = { fg = "purple" } },
  Label          = { vague = { fg = "keyword" },                     onedark = { fg = "purple" } },
  Macro          = { vague = { fg = "constant" },                    onedark = { fg = "red" } },
  Number         = { vague = { fg = "number" },                      onedark = { fg = "orange" } },
  Operator       = { vague = { fg = "operator" },                    onedark = { fg = "purple" } },
  PreCondit      = { vague = { fg = "comment" },                     onedark = { fg = "purple" } },
  PreProc        = { vague = { fg = "constant" },                    onedark = { fg = "purple" } },
  Repeat         = { vague = { fg = "keyword" },                     onedark = { fg = "purple" } },
  Special        = { vague = { fg = "builtin" },                     onedark = { fg = "red" } },
  SpecialChar    = { vague = { fg = "keyword" },                     onedark = { fg = "red" } },
  SpecialComment = { vague = { fg = "keyword" },                     onedark = { fg = "grey", italic = true } },
  Statement      = { vague = { fg = "keyword" },                     onedark = { fg = "purple" } },
  StorageClass   = { vague = { fg = "constant" },                    onedark = { fg = "yellow" } },
  String         = { vague = { fg = "string", italic = true },       onedark = { fg = "green" } },
  Structure      = { vague = { fg = "constant" },                    onedark = { fg = "yellow" } },
  Tag            = { vague = { fg = "builtin" },                     onedark = { fg = "green" } },
  Title          = { vague = { fg = "property" },                    onedark = { fg = "cyan" } },
  Todo           = { vague = { fg = "func", italic = true },         onedark = { fg = "red", italic = true } },
  Type           = { vague = { fg = "type" },                        onedark = { fg = "yellow" } },
  Typedef        = { vague = { fg = "constant" },                    onedark = { fg = "yellow" } },

  -- ───────────────────────── Treesitter ──────────────────────────

  ["@annotation"]                 = { vague = { fg = "fg" },                          onedark = { fg = "fg" } },
  ["@attribute"]                  = { vague = { fg = "constant" },                    onedark = { fg = "cyan" } },
  ["@attribute.typescript"]       = { vague = { fg = "hint" },                        onedark = { fg = "blue" } },
  ["@boolean"]                    = { vague = { fg = "number", bold = true },         onedark = { fg = "orange" } },
  ["@character"]                  = { vague = { fg = "string", italic = true },       onedark = { fg = "orange" } },
  ["@character.special"]          = { vague = { fg = "keyword" },                     onedark = { fg = "red" } },
  ["@comment"]                    = { vague = { fg = "comment", italic = true },      onedark = { fg = "grey", italic = true } },
  ["@comment.todo"]               = { vague = { fg = "func", italic = true },         onedark = { fg = "red", italic = true } },
  ["@comment.todo.checked"]       = { vague = { fg = "plus", italic = true },         onedark = { fg = "green", italic = true } },
  ["@comment.todo.unchecked"]     = { vague = { fg = "func", italic = true },         onedark = { fg = "red", italic = true } },
  ["@constant"]                   = { vague = { fg = "constant" },                    onedark = { fg = "orange" } },
  ["@constant.builtin"]           = { vague = { fg = "number", bold = true },         onedark = { fg = "orange" } },
  ["@constant.macro"]             = { vague = { fg = "number" },                      onedark = { fg = "orange" } },
  ["@constructor"]                = { vague = { fg = "constant" },                    onedark = { fg = "yellow", bold = true } },
  ["@constructor.lua"]            = { vague = { fg = "type" },                        onedark = { fg = "light_grey" } },
  ["@danger"]                     = { vague = { fg = "fg" },                          onedark = { fg = "fg" } },
  ["@diff.add"]                   = { vague = { fg = "plus" },                        onedark = { fg = "green" } },
  ["@diff.delete"]                = { vague = { fg = "error" },                       onedark = { fg = "red" } },
  ["@diff.delta"]                 = { vague = { fg = "delta" },                       onedark = { fg = "blue" } },
  ["@diff.minus"]                 = { vague = { fg = "error" },                       onedark = { fg = "red" } },
  ["@diff.plus"]                  = { vague = { fg = "plus" },                        onedark = { fg = "green" } },
  ["@error"]                      = { vague = { fg = "fg" },                          onedark = { fg = "fg" } },
  ["@function"]                   = { vague = { fg = "func" },                        onedark = { fg = "blue" } },
  ["@function.builtin"]           = { vague = { fg = "func" },                        onedark = { fg = "cyan" } },
  ["@function.call"]              = { vague = { fg = "parameter" },                   onedark = { fg = "blue" } },
  ["@function.macro"]             = { vague = { fg = "constant" },                    onedark = { fg = "cyan" } },
  ["@function.method"]            = { vague = { fg = "func" },                        onedark = { fg = "blue" } },
  ["@function.method.call"]       = { vague = { fg = "func" },                        onedark = { fg = "blue" } },
  ["@keyword"]                    = { vague = { fg = "keyword" },                     onedark = { fg = "purple" } },
  ["@keyword.conditional"]        = { vague = { fg = "keyword" },                     onedark = { fg = "purple" } },
  ["@keyword.directive"]          = { vague = { fg = "keyword" },                     onedark = { fg = "purple" } },
  ["@keyword.exception"]          = { vague = { fg = "keyword" },                     onedark = { fg = "purple" } },
  ["@keyword.function"]           = { vague = { fg = "keyword" },                     onedark = { fg = "purple" } },
  ["@keyword.import"]             = { vague = { fg = "constant" },                    onedark = { fg = "purple" } },
  ["@keyword.operator"]           = { vague = { fg = "keyword" },                     onedark = { fg = "purple" } },
  ["@keyword.repeat"]             = { vague = { fg = "keyword" },                     onedark = { fg = "purple" } },
  ["@keyword.return"]             = { vague = { fg = "keyword", italic = true },      onedark = { fg = "purple" } },
  ["@label"]                      = { vague = { fg = "keyword" },                     onedark = { fg = "red" } },
  ["@markup"]                     = { vague = { fg = "fg" },                          onedark = { fg = "fg" } },
  ["@markup.emphasis"]            = { vague = { fg = "fg", italic = true },           onedark = { fg = "fg", italic = true } },
  ["@markup.environment"]         = { vague = { fg = "fg" },                          onedark = { fg = "fg" } },
  ["@markup.environment.name"]    = { vague = { fg = "fg" },                          onedark = { fg = "fg" } },
  ["@markup.heading"]             = { vague = { fg = "keyword", bold = true },        onedark = { fg = "orange", bold = true } },
  ["@markup.heading.1.markdown"]  = { vague = { fg = "error", bold = true },          onedark = { fg = "red", bold = true } },
  ["@markup.heading.2.markdown"]  = { vague = { fg = "keyword", bold = true },        onedark = { fg = "purple", bold = true } },
  ["@markup.heading.3.markdown"]  = { vague = { fg = "number", bold = true },         onedark = { fg = "orange", bold = true } },
  ["@markup.heading.4.markdown"]  = { vague = { fg = "error", bold = true },          onedark = { fg = "red", bold = true } },
  ["@markup.heading.5.markdown"]  = { vague = { fg = "keyword", bold = true },        onedark = { fg = "purple", bold = true } },
  ["@markup.heading.6.markdown"]  = { vague = { fg = "number", bold = true },         onedark = { fg = "orange", bold = true } },
  ["@markup.heading.1.marker.markdown"] = { vague = { fg = "error", bold = true },    onedark = { fg = "red", bold = true } },
  ["@markup.heading.2.marker.markdown"] = { vague = { fg = "keyword", bold = true },  onedark = { fg = "purple", bold = true } },
  ["@markup.heading.3.marker.markdown"] = { vague = { fg = "number", bold = true },   onedark = { fg = "orange", bold = true } },
  ["@markup.heading.4.marker.markdown"] = { vague = { fg = "error", bold = true },    onedark = { fg = "red", bold = true } },
  ["@markup.heading.5.marker.markdown"] = { vague = { fg = "keyword", bold = true },  onedark = { fg = "purple", bold = true } },
  ["@markup.heading.6.marker.markdown"] = { vague = { fg = "number", bold = true },   onedark = { fg = "orange", bold = true } },
  ["@markup.italic"]              = { vague = { fg = "fg", italic = true },           onedark = { fg = "fg", italic = true } },
  ["@markup.link"]                = { vague = { fg = "string" },                      onedark = { fg = "blue" } },
  ["@markup.link.url"]            = { vague = { fg = "string", underline = true },    onedark = { fg = "cyan", underline = true } },
  ["@markup.list"]                = { vague = { fg = "func" },                        onedark = { fg = "red" } },
  ["@markup.math"]                = { vague = { fg = "string" },                      onedark = { fg = "fg" } },
  ["@markup.quote.markdown"]      = { vague = { fg = "comment" },                     onedark = { fg = "grey" } },
  ["@markup.raw"]                 = { vague = { fg = "constant" },                    onedark = { fg = "green" } },
  ["@markup.strike"]              = { vague = { fg = "comment", strikethrough = true }, onedark = { fg = "fg", strikethrough = true } },
  ["@markup.strong"]              = { vague = { fg = "fg", bold = true },             onedark = { fg = "fg", bold = true } },
  ["@markup.underline"]           = { vague = { fg = "fg", underline = true },        onedark = { fg = "fg", underline = true } },
  ["@module"]                     = { vague = { fg = "constant" },                    onedark = { fg = "yellow" } },
  ["@none"]                       = { vague = { fg = "fg" },                          onedark = { fg = "fg" } },
  ["@note"]                       = { vague = { fg = "fg" },                          onedark = { fg = "fg" } },
  ["@number"]                     = { vague = { fg = "number" },                      onedark = { fg = "orange" } },
  ["@number.float"]               = { vague = { fg = "number" },                      onedark = { fg = "orange" } },
  ["@operator"]                   = { vague = { fg = "operator" },                    onedark = { fg = "fg" } },
  ["@parameter.reference"]        = { vague = { fg = "fg" },                          onedark = { fg = "fg" } },
  ["@property"]                   = { vague = { fg = "property" },                    onedark = { fg = "cyan" } },
  ["@punctuation.bracket"]        = { vague = { fg = "fg" },                          onedark = { fg = "light_grey" } },
  ["@punctuation.delimiter"]      = { vague = { fg = "fg" },                          onedark = { fg = "light_grey" } },
  ["@punctuation.special"]        = { vague = { fg = "keyword" },                     onedark = { fg = "red" } },
  ["@string"]                     = { vague = { fg = "string", italic = true },       onedark = { fg = "green" } },
  ["@string.escape"]              = { vague = { fg = "keyword" },                     onedark = { fg = "red" } },
  ["@string.regexp"]              = { vague = { fg = "keyword" },                     onedark = { fg = "orange" } },
  ["@string.special.symbol"]      = { vague = { fg = "constant" },                    onedark = { fg = "cyan" } },
  ["@string.special.url"]         = { vague = { fg = "func" },                        onedark = { fg = "cyan", underline = true } },
  ["@tag"]                        = { vague = { fg = "keyword" },                     onedark = { fg = "purple" } },
  ["@tag.attribute"]              = { vague = { fg = "constant" },                    onedark = { fg = "yellow" } },
  ["@tag.delimiter"]              = { vague = { fg = "fg" },                          onedark = { fg = "purple" } },
  ["@text"]                       = { vague = { fg = "fg" },                          onedark = { fg = "fg" } },
  ["@type"]                       = { vague = { fg = "builtin" },                     onedark = { fg = "yellow" } },
  ["@type.builtin"]               = { vague = { fg = "builtin", bold = true },        onedark = { fg = "orange" } },
  ["@type.declaration"]           = { vague = { fg = "constant" },                    onedark = { fg = "yellow" } },
  ["@type.definition"]            = { vague = { fg = "constant" },                    onedark = { fg = "yellow" } },
  ["@variable"]                   = { vague = { fg = "fg" },                          onedark = { fg = "fg" } },
  ["@variable.builtin"]           = { vague = { fg = "builtin", italic = true },      onedark = { fg = "red" } },
  ["@variable.member"]            = { vague = { fg = "builtin" },                     onedark = { fg = "cyan" } },
  ["@variable.parameter"]         = { vague = { fg = "parameter" },                   onedark = { fg = "red" } },
  ["@warning"]                    = { vague = { fg = "fg" },                          onedark = { fg = "fg" } },
}
