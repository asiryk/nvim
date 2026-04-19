-- stylua: ignore start

-- Single source of truth for all base Neovim highlights.
--
-- Shape per group:
--   PerPalette:  { vague = {...}, onedark = {...}, sonokai_shusia = {...}, grey = {...} }
--     - All four keys are required (drift assert in theme.lua enforces it).
--     - String values that match a palette key are resolved to that color;
--       anything else ("none", "#aabbcc", true, numbers, links) passes through.
--     - Shared traits (italic/bold) are duplicated across all halves explicitly.
--   PaletteAgnostic: any table without palette keys, e.g. { reverse = true } or
--     { link = "Search" }. Applied as-is.
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
--
--@alias SonokaiShusiaColor
---| "black" | "bg_dim" | "bg0" | "bg1" | "bg2" | "bg3" | "bg4"
---| "bg_red" | "bg_yellow" | "bg_green" | "bg_blue" | "bg_purple"
---| "filled_red" | "filled_green" | "filled_blue"
---| "fg" | "red" | "orange" | "yellow" | "green" | "blue" | "purple"
---| "grey" | "grey_dim" | "diff_text"
--
--@alias GreyColor
---| "background" | "grey_bg_light" | "black" | "blue" | "light_blue" | "green"
---| "light_green" | "light_red" | "red" | "grey" | "light_grey" | "visual" | "diff_text"
---| "border" | "highlight" | "dark_yellow" | "yellow" | "light_yellow"
---| "orange" | "purple" | "white" | "cyan"

return {
  -- ─────────────────────────── Base UI ───────────────────────────

  ColorColumn      = { vague = { bg = "line" },                        onedark = { bg = "bg1" },                                             sonokai_shusia = { bg = "bg1" },                                             grey = { bg = "highlight" } },
  Conceal          = { vague = { fg = "func" },                        onedark = { fg = "grey" },                                            sonokai_shusia = { fg = "grey" },                                            grey = { fg = "grey" } },
  Cursor           = { reverse = true },
  CursorColumn     = { vague = { bg = "line" },                        onedark = { bg = "bg1" },                                             sonokai_shusia = { bg = "bg1" },                                             grey = { bg = "highlight" } },
  CursorIM         = { reverse = true },
  CursorLine       = { vague = { bg = "none" },                        onedark = { bg = "none" },                                            sonokai_shusia = { bg = "none" },                                            grey = { bg = "none" } },
  CursorLineNr     = { vague = { fg = "fg" },                          onedark = { fg = "fg" },                                              sonokai_shusia = { fg = "fg" },                                              grey = { fg = "black", bold = true } },
  Debug            = { vague = { fg = "constant" },                    onedark = { fg = "yellow" },                                          sonokai_shusia = { fg = "yellow" },                                          grey = { fg = "dark_yellow" } },
  Directory        = { vague = { fg = "hint" },                        onedark = { fg = "blue" },                                            sonokai_shusia = { fg = "blue" },                                            grey = { fg = "purple" } },
  EndOfBuffer      = { vague = { fg = "comment", bg = "bg" },          onedark = { fg = "bg0", bg = "bg0" },                                 sonokai_shusia = { fg = "bg0", bg = "bg0" },                                 grey = { fg = "background", bg = "background" } },
  ErrorMsg         = { vague = { fg = "error", bold = true },          onedark = { fg = "red", bold = true },                                sonokai_shusia = { fg = "red", bold = true },                                grey = { fg = "red", bold = true } },
  FoldColumn       = { vague = { fg = "comment", bg = "bg" },          onedark = { fg = "fg", bg = "bg1" },                                  sonokai_shusia = { fg = "fg", bg = "bg1" },                                  grey = { fg = "grey" } },
  Folded           = { vague = { fg = "comment", bg = "line" },        onedark = { fg = "fg", bg = "bg1" },                                  sonokai_shusia = { fg = "fg", bg = "bg1" },                                  grey = { fg = "grey" } },
  LineNr           = { vague = { fg = "comment" },                     onedark = { fg = "grey" },                                            sonokai_shusia = { fg = "grey" },                                            grey = { fg = "grey" } },
  MoreMsg          = { vague = { fg = "func", bold = true },           onedark = { fg = "blue", bold = true },                               sonokai_shusia = { fg = "blue", bold = true },                               grey = { fg = "black" } },
  NonText          = { vague = { fg = "comment" },                     onedark = { fg = "grey" },                                            sonokai_shusia = { fg = "grey" },                                            grey = { fg = "grey" } },
  Normal           = { vague = { fg = "fg", bg = "bg" },               onedark = { fg = "fg", bg = "bg0" },                                  sonokai_shusia = { fg = "fg", bg = "bg0" },                                  grey = { fg = "black", bg = "background" } },
  Question         = { vague = { fg = "constant" },                    onedark = { fg = "yellow" },                                          sonokai_shusia = { fg = "yellow" },                                          grey = { fg = "black" } },
  QuickFixLine     = { vague = { fg = "func", underline = true },      onedark = { fg = "blue", underline = true },                          sonokai_shusia = { fg = "blue", underline = true },                          grey = { bg = "highlight", bold = true } },
  SignColumn       = { vague = { fg = "fg", bg = "bg" },               onedark = { fg = "fg", bg = "bg0" },                                  sonokai_shusia = { fg = "fg", bg = "bg0" },                                  grey = { fg = "grey" } },
  SpecialKey       = { vague = { fg = "comment" },                     onedark = { fg = "grey" },                                            sonokai_shusia = { fg = "grey" },                                            grey = { fg = "blue" } },
  Terminal         = { vague = { fg = "fg", bg = "bg" },               onedark = { fg = "fg", bg = "bg0" },                                  sonokai_shusia = { fg = "fg", bg = "bg0" },                                  grey = { fg = "black", bg = "background" } },
  ToolbarButton    = { vague = { fg = "bg", bg = "visual" },           onedark = { fg = "bg0", bg = "bg_blue" },                             sonokai_shusia = { fg = "bg0", bg = "bg_blue" },                             grey = { fg = "white", bg = "blue" } },
  ToolbarLine      = { vague = { fg = "fg" },                          onedark = { fg = "fg" },                                              sonokai_shusia = { fg = "fg" },                                              grey = { fg = "black" } },
  Visual           = { vague = { bg = "visual" },                      onedark = { bg = "bg3" },                                             sonokai_shusia = { bg = "bg3" },                                             grey = { bg = "visual" } },
  VisualNOS        = { vague = { bg = "comment", underline = true },   onedark = { fg = "none", bg = "bg2", underline = true },              sonokai_shusia = { fg = "none", bg = "bg2", underline = true },              grey = { bg = "visual", underline = true } },
  WarningMsg       = { vague = { fg = "warning", bold = true },        onedark = { fg = "yellow", bold = true },                             sonokai_shusia = { fg = "yellow", bold = true },                             grey = { fg = "dark_yellow", bold = true } },
  Whitespace       = { vague = { fg = "line" },                        onedark = { fg = "grey" },                                            sonokai_shusia = { fg = "grey" },                                            grey = { fg = "border" } },
  WinSeparator     = { vague = { fg = "floatBorder" },                 onedark = { fg = "bg3" },                                             sonokai_shusia = { fg = "bg3" },                                             grey = { fg = "border" } },
  debugBreakpoint  = { vague = { fg = "bg", bg = "operator" },         onedark = { fg = "bg0", bg = "red" },                                 sonokai_shusia = { fg = "bg0", bg = "red" },                                 grey = { fg = "white", bg = "red" } },
  debugPC          = { vague = { fg = "bg", bg = "fg" },               onedark = { fg = "bg0", bg = "green" },                               sonokai_shusia = { fg = "bg0", bg = "green" },                               grey = { fg = "white", bg = "green" } },
  iCursor          = { reverse = true },
  lCursor          = { reverse = true },
  vCursor          = { reverse = true },

  -- ───────────────────────── Diagnostic ──────────────────────────

  DiagnosticError             = { vague = { fg = "error", bold = true },                onedark = { fg = "red" },                         sonokai_shusia = { fg = "red" },                         grey = { fg = "red", bold = true } },
  DiagnosticHint              = { vague = { fg = "hint" },                              onedark = { fg = "purple" },                      sonokai_shusia = { fg = "purple" },                      grey = { fg = "grey", bold = true } },
  DiagnosticInfo              = { vague = { fg = "constant", italic = true },           onedark = { fg = "cyan" },                        sonokai_shusia = { fg = "blue" },                        grey = { fg = "blue", bold = true } },
  DiagnosticOk                = { vague = { fg = "plus" },                              onedark = { fg = "green" },                       sonokai_shusia = { fg = "green" },                       grey = { fg = "green", bold = true } },
  DiagnosticWarn              = { vague = { fg = "warning", bold = true },              onedark = { fg = "yellow" },                      sonokai_shusia = { fg = "yellow" },                      grey = { fg = "dark_yellow", bold = true } },

  DiagnosticUnderlineError    = { vague = { sp = "error", undercurl = true },           onedark = { sp = "red", undercurl = true },       sonokai_shusia = { sp = "red", undercurl = true },       grey = { sp = "red", underline = true } },
  DiagnosticUnderlineHint     = { vague = { sp = "hint", undercurl = true },            onedark = { sp = "purple", undercurl = true },    sonokai_shusia = { sp = "purple", undercurl = true },    grey = { sp = "purple", underline = true } },
  DiagnosticUnderlineInfo     = { vague = { sp = "constant", undercurl = true },        onedark = { sp = "blue", undercurl = true },      sonokai_shusia = { sp = "blue", undercurl = true },      grey = { sp = "blue", underline = true } },
  DiagnosticUnderlineOk       = { vague = { sp = "plus", undercurl = true },            onedark = { sp = "green", undercurl = true },     sonokai_shusia = { sp = "green", undercurl = true },     grey = { sp = "green", underline = true } },
  DiagnosticUnderlineWarn     = { vague = { sp = "delta", undercurl = true },           onedark = { sp = "yellow", undercurl = true },    sonokai_shusia = { sp = "yellow", undercurl = true },    grey = { sp = "dark_yellow", underline = true } },

  DiagnosticVirtualTextError  = { vague = { fg = "error", bold = true },                onedark = { bg = "none", fg = "dark_red" },       sonokai_shusia = { bg = "none", fg = "bg_red" },         grey = { fg = "red", bold = true } },
  DiagnosticVirtualTextHint   = { vague = { fg = "hint" },                              onedark = { bg = "none", fg = "dark_purple" },    sonokai_shusia = { bg = "none", fg = "bg_purple" },      grey = { fg = "black", bold = true } },
  DiagnosticVirtualTextInfo   = { vague = { fg = "constant", italic = true },           onedark = { bg = "none", fg = "dark_cyan" },      sonokai_shusia = { bg = "none", fg = "bg_blue" },        grey = { fg = "blue", bold = true } },
  DiagnosticVirtualTextOk     = { vague = { fg = "plus" },                              onedark = { bg = "none", fg = "green" },          sonokai_shusia = { bg = "none", fg = "green" },          grey = { fg = "green" } },
  DiagnosticVirtualTextWarn   = { vague = { fg = "warning", bold = true },              onedark = { bg = "none", fg = "dark_yellow" },    sonokai_shusia = { bg = "none", fg = "bg_yellow" },      grey = { fg = "dark_yellow", bold = true } },

  -- ───────────────────────── Diff / VCS ──────────────────────────
  -- vague Diff* backgrounds are pre-blended:
  --   DiffAdd    = blend(plus,  bg, 0.2) = #293125
  --   DiffChange = blend(delta, bg, 0.2) = #262E34
  --   DiffDelete = blend(error, bg, 0.2) = #3B242A
  --   DiffText   = blend(delta, bg, 0.4) = #384754

  Added         = { vague = { fg = "plus" },                     onedark = { fg = "green" },                             sonokai_shusia = { fg = "green" },                             grey = { fg = "green" } },
  Changed       = { vague = { fg = "delta" },                    onedark = { fg = "blue" },                              sonokai_shusia = { fg = "blue" },                              grey = { fg = "blue" } },
  DiffAdd       = { vague = { bg = "#293125" },                  onedark = { fg = "none", bg = "diff_add" },             sonokai_shusia = { fg = "none", bg = "bg_green" },             grey = { bg = "light_green" } },
  DiffAdded     = { vague = { fg = "plus" },                     onedark = { fg = "green" },                             sonokai_shusia = { fg = "green" },                             grey = { fg = "green" } },
  DiffChange    = { vague = { bg = "#262E34" },                  onedark = { fg = "none", bg = "diff_change" },          sonokai_shusia = { fg = "none", bg = "bg_blue" },              grey = { bg = "light_blue" } },
  DiffChanged   = { vague = { fg = "delta" },                    onedark = { fg = "blue" },                              sonokai_shusia = { fg = "blue" },                              grey = { fg = "blue" } },
  DiffDelete    = { vague = { bg = "#3B242A" },                  onedark = { fg = "none", bg = "diff_delete" },          sonokai_shusia = { fg = "none", bg = "bg_red" },               grey = { fg = "red" } },
  DiffDeleted   = { vague = { fg = "error" },                    onedark = { fg = "red" },                               sonokai_shusia = { fg = "red" },                               grey = { fg = "red" } },
  DiffFile      = { vague = { fg = "keyword" },                  onedark = { fg = "cyan" },                              sonokai_shusia = { fg = "blue" },                              grey = { fg = "black", bold = true } },
  DiffIndexLine = { vague = { fg = "comment" },                  onedark = { fg = "grey" },                              sonokai_shusia = { fg = "grey" },                              grey = { fg = "blue" } },
  DiffRemoved   = { vague = { fg = "error" },                    onedark = { fg = "red" },                               sonokai_shusia = { fg = "red" },                               grey = { fg = "red" } },
  DiffText      = { vague = { bg = "#384754" },                  onedark = { fg = "none", bg = "diff_text" },            sonokai_shusia = { fg = "none", bg = "diff_text" },            grey = { bg = "diff_text" } },
  Removed       = { vague = { fg = "error" },                    onedark = { fg = "red" },                               sonokai_shusia = { fg = "red" },                               grey = { fg = "red" } },

  -- ──────────────────── Float / Popup / Menu ─────────────────────

  FloatBorder = { vague = { fg = "floatBorder", bg = "none" },   onedark = { fg = "fg", bg = "none" },                   sonokai_shusia = { fg = "fg", bg = "none" },                   grey = { fg = "border" } },
  NormalFloat = { vague = { fg = "fg", bg = "bg" },              onedark = { fg = "fg", bg = "bg0" },                    sonokai_shusia = { fg = "fg", bg = "bg0" },                    grey = { fg = "black" } },
  Pmenu       = { vague = { fg = "fg" },                         onedark = { fg = "fg", bg = "bg1" },                    sonokai_shusia = { fg = "fg", bg = "bg1" },                    grey = { fg = "black", bg = "grey_bg_light" } },
  PmenuSbar   = { vague = { bg = "line" },                       onedark = { fg = "none", bg = "bg1" },                  sonokai_shusia = { fg = "none", bg = "bg1" },                  grey = { bg = "grey_bg_light" } },
  PmenuSel    = { vague = { fg = "constant", bg = "line" },      onedark = { fg = "bg0", bg = "bg_blue" },               sonokai_shusia = { fg = "bg0", bg = "bg_blue" },               grey = { bg = "light_grey", bold = true } },
  PmenuThumb  = { vague = { bg = "comment" },                    onedark = { fg = "none", bg = "grey" },                 sonokai_shusia = { fg = "none", bg = "grey" },                 grey = { bg = "light_grey" } },
  WildMenu    = { vague = { fg = "bg", bg = "func" },            onedark = { fg = "bg0", bg = "blue" },                  sonokai_shusia = { fg = "bg0", bg = "blue" },                  grey = { bg = "light_grey", bold = true } },

  -- ─────────────────────────── LSP ───────────────────────────────

  LspCodeLens          = { vague = { fg = "comment", italic = true },   onedark = { fg = "grey", italic = true },         sonokai_shusia = { fg = "grey", italic = true },         grey = { fg = "grey", italic = true } },
  LspCodeLensSeparator = { vague = { fg = "comment" },                  onedark = { fg = "grey" },                        sonokai_shusia = { fg = "grey" },                        grey = { fg = "grey" } },
  LspReferenceRead     = { vague = { bg = "comment" },                  onedark = { bg = "bg2" },                         sonokai_shusia = { bg = "bg2" },                         grey = { bg = "light_grey" } },
  LspReferenceTarget   = { vague = { bg = "search" },                   onedark = { bg = "diff_text" },                   sonokai_shusia = { bg = "bg_purple" },                   grey = { bg = "visual" } },
  LspReferenceText     = { vague = { bg = "comment" },                  onedark = { bg = "bg2" },                         sonokai_shusia = { bg = "bg2" },                         grey = { bg = "light_grey" } },
  LspReferenceWrite    = { vague = { bg = "comment" },                  onedark = { bg = "bg2" },                         sonokai_shusia = { bg = "bg2" },                         grey = { bg = "light_grey" } },

  ["@lsp.type.builtinType"]              = { vague = { fg = "builtin", bold = true },   onedark = { fg = "orange" },       sonokai_shusia = { fg = "orange" },       grey = { fg = "black", bold = true } },
  ["@lsp.type.comment"]                  = { vague = { fg = "comment", italic = true }, onedark = { fg = "grey", italic = true }, sonokai_shusia = { fg = "grey", italic = true }, grey = { fg = "grey", italic = true } },
  ["@lsp.type.enum"]                     = { vague = { fg = "constant" },               onedark = { fg = "yellow" },       sonokai_shusia = { fg = "yellow" },       grey = { fg = "black" } },
  ["@lsp.type.enumMember"]               = { vague = { fg = "builtin" },                onedark = { fg = "orange" },       sonokai_shusia = { fg = "orange" },       grey = { fg = "purple" } },
  ["@lsp.type.generic"]                  = { vague = { fg = "builtin" },                onedark = { fg = "fg" },           sonokai_shusia = { fg = "fg" },           grey = { fg = "black" } },
  ["@lsp.type.interface"]                = { vague = { fg = "constant" },               onedark = { fg = "yellow" },       sonokai_shusia = { fg = "yellow" },       grey = { fg = "black" } },
  ["@lsp.type.keyword"]                  = { vague = { fg = "keyword" },                onedark = { fg = "purple" },       sonokai_shusia = { fg = "purple" },       grey = { fg = "black", bold = true } },
  ["@lsp.type.macro"]                    = { vague = { fg = "constant" },               onedark = { fg = "cyan" },         sonokai_shusia = { fg = "blue" },         grey = { fg = "orange" } },
  ["@lsp.type.method"]                   = { vague = { fg = "func" },                   onedark = { fg = "blue" },         sonokai_shusia = { fg = "blue" },         grey = { fg = "black" } },
  ["@lsp.type.namespace"]                = { vague = { fg = "constant" },               onedark = { fg = "yellow" },       sonokai_shusia = { fg = "yellow" },       grey = { fg = "black" } },
  ["@lsp.type.number"]                   = { vague = { fg = "number" },                 onedark = { fg = "orange" },       sonokai_shusia = { fg = "orange" },       grey = { fg = "blue" } },
  ["@lsp.type.parameter"]                = { vague = { fg = "parameter" },              onedark = { fg = "red" },          sonokai_shusia = { fg = "red" },          grey = { fg = "orange" } },
  ["@lsp.type.property"]                 = { vague = { fg = "builtin" },                onedark = { fg = "cyan" },         sonokai_shusia = { fg = "blue" },         grey = { fg = "black" } },
  ["@lsp.type.typeParameter"]            = { vague = { fg = "constant" },               onedark = { fg = "yellow" },       sonokai_shusia = { fg = "yellow" },       grey = { fg = "black" } },
  ["@lsp.type.variable"]                 = { vague = { fg = "fg" },                     onedark = { fg = "fg" },           sonokai_shusia = { fg = "fg" },           grey = { fg = "black" } },

  ["@lsp.typemod.function.defaultLibrary"] = { vague = { fg = "func" },                 onedark = { fg = "blue" },         sonokai_shusia = { fg = "blue" },         grey = { fg = "black" } },
  ["@lsp.typemod.method.defaultLibrary"]   = { vague = { fg = "func" },                 onedark = { fg = "blue" },         sonokai_shusia = { fg = "blue" },         grey = { fg = "black" } },
  ["@lsp.typemod.operator.injected"]       = { vague = { fg = "operator" },             onedark = { fg = "fg" },           sonokai_shusia = { fg = "fg" },           grey = { fg = "black" } },
  ["@lsp.typemod.string.injected"]         = { vague = { fg = "string", italic = true },onedark = { fg = "green" },        sonokai_shusia = { fg = "green" },        grey = { fg = "green" } },
  ["@lsp.typemod.variable.defaultLibrary"] = { vague = { fg = "number", bold = true },  onedark = { fg = "red" },          sonokai_shusia = { fg = "red" },          grey = { fg = "black", bold = true } },
  ["@lsp.typemod.variable.injected"]       = { vague = { fg = "fg" },                   onedark = { fg = "fg" },           sonokai_shusia = { fg = "fg" },           grey = { fg = "black" } },
  ["@lsp.typemod.variable.static"]         = { vague = { fg = "constant" },             onedark = { fg = "orange" },       sonokai_shusia = { fg = "orange" },       grey = { fg = "black" } },

  -- ───────────────────────── Search / Match ──────────────────────

  CurSearch  = { vague = { fg = "fg", bg = "search" },       onedark = { fg = "bg0", bg = "orange" },      sonokai_shusia = { fg = "bg0", bg = "orange" },      grey = { bg = "light_yellow" } },
  IncSearch  = { vague = { fg = "bg", bg = "search" },       onedark = { fg = "bg0", bg = "orange" },      sonokai_shusia = { fg = "bg0", bg = "orange" },      grey = { bg = "light_yellow" } },
  MatchParen = { vague = { fg = "fg", bg = "visual" },       onedark = { fg = "none", bg = "grey" },       sonokai_shusia = { fg = "none", bg = "grey" },       grey = { bold = true } },
  Search     = { vague = { fg = "fg", bg = "search" },       onedark = { fg = "bg0", bg = "bg_yellow" },   sonokai_shusia = { fg = "bg0", bg = "bg_yellow" },   grey = { bg = "light_yellow" } },
  Substitute = { vague = { fg = "type", bg = "visual" },     onedark = { fg = "bg0", bg = "green" },       sonokai_shusia = { fg = "bg0", bg = "green" },       grey = { bg = "light_green" } },

  -- ─────────────────────────── Spell ─────────────────────────────

  SpellBad   = { vague = { undercurl = true },   onedark = { fg = "none", undercurl = true, sp = "red" },      sonokai_shusia = { fg = "none", undercurl = true, sp = "red" },      grey = { sp = "red", underline = true } },
  SpellCap   = { vague = { undercurl = true },   onedark = { fg = "none", undercurl = true, sp = "yellow" },   sonokai_shusia = { fg = "none", undercurl = true, sp = "yellow" },   grey = { sp = "dark_yellow", underline = true } },
  SpellLocal = { vague = { undercurl = true },   onedark = { fg = "none", undercurl = true, sp = "blue" },     sonokai_shusia = { fg = "none", undercurl = true, sp = "blue" },     grey = { sp = "blue", underline = true } },
  SpellRare  = { vague = { undercurl = true },   onedark = { fg = "none", undercurl = true, sp = "purple" },   sonokai_shusia = { fg = "none", undercurl = true, sp = "purple" },   grey = { sp = "purple", underline = true } },

  -- ─────────────────── Statusline / Tabline ──────────────────────

  StatusLine       = { vague = { fg = "fg", bg = "inactiveBg" },      onedark = { fg = "fg", bg = "bg2" },           sonokai_shusia = { fg = "fg", bg = "bg2" },           grey = { fg = "black", bg = "background" } },
  StatusLineNC     = { vague = { fg = "comment" },                    onedark = { fg = "grey", bg = "bg1" },         sonokai_shusia = { fg = "grey", bg = "bg1" },         grey = { fg = "black", bg = "grey_bg_light" } },
  StatusLineTerm   = { vague = { fg = "fg", bg = "inactiveBg" },      onedark = { fg = "fg", bg = "bg2" },           sonokai_shusia = { fg = "fg", bg = "bg2" },           grey = { fg = "black", bg = "background" } },
  StatusLineTermNC = { vague = { fg = "comment" },                    onedark = { fg = "grey", bg = "bg1" },         sonokai_shusia = { fg = "grey", bg = "bg1" },         grey = { fg = "black", bg = "grey_bg_light" } },
  TabLine          = { vague = { fg = "fg", bg = "line" },            onedark = { fg = "fg", bg = "bg1" },           sonokai_shusia = { fg = "fg", bg = "bg1" },           grey = { fg = "black", bg = "light_grey" } },
  TabLineFill      = { vague = { fg = "comment", bg = "line" },       onedark = { fg = "grey", bg = "bg1" },         sonokai_shusia = { fg = "grey", bg = "bg1" },         grey = { fg = "black", bg = "light_grey" } },
  TabLineSel       = { vague = { fg = "bg", bg = "fg" },              onedark = { fg = "bg0", bg = "fg" },           sonokai_shusia = { fg = "bg0", bg = "fg" },           grey = { fg = "black", bg = "background", bold = true } },

  -- ─────────────────────── Syntax (vim-native) ───────────────────

  Boolean        = { vague = { fg = "number", bold = true },         onedark = { fg = "orange" },                    sonokai_shusia = { fg = "orange" },                    grey = { fg = "black", bold = true } },
  Character      = { vague = { fg = "string" },                      onedark = { fg = "orange" },                    sonokai_shusia = { fg = "orange" },                    grey = { fg = "green" } },
  Comment        = { vague = { fg = "comment", italic = true },      onedark = { fg = "grey", italic = true },       sonokai_shusia = { fg = "grey", italic = true },       grey = { fg = "grey" } },
  Conditional    = { vague = { fg = "keyword" },                     onedark = { fg = "purple" },                    sonokai_shusia = { fg = "purple" },                    grey = { fg = "black", bold = true } },
  Constant       = { vague = { fg = "constant" },                    onedark = { fg = "cyan" },                      sonokai_shusia = { fg = "blue" },                      grey = { fg = "black" } },
  Define         = { vague = { fg = "comment" },                     onedark = { fg = "purple" },                    sonokai_shusia = { fg = "purple" },                    grey = { fg = "black", bold = true } },
  Delimiter      = { vague = { fg = "fg" },                          onedark = { fg = "light_grey" },                sonokai_shusia = { fg = "grey_dim" },                  grey = { fg = "black" } },
  Error          = { vague = { fg = "error", bold = true },          onedark = { fg = "purple" },                    sonokai_shusia = { fg = "purple" },                    grey = { fg = "red", bold = true } },
  Exception      = { vague = { fg = "keyword" },                     onedark = { fg = "purple" },                    sonokai_shusia = { fg = "purple" },                    grey = { fg = "black", bold = true } },
  Float          = { vague = { fg = "number" },                      onedark = { fg = "orange" },                    sonokai_shusia = { fg = "orange" },                    grey = { fg = "blue" } },
  Function       = { vague = { fg = "func" },                        onedark = { fg = "blue" },                      sonokai_shusia = { fg = "blue" },                      grey = { fg = "black" } },
  Identifier     = { vague = { fg = "constant" },                    onedark = { fg = "red" },                       sonokai_shusia = { fg = "red" },                       grey = { fg = "black" } },
  Include        = { vague = { fg = "keyword" },                     onedark = { fg = "purple" },                    sonokai_shusia = { fg = "purple" },                    grey = { fg = "black", bold = true } },
  Keyword        = { vague = { fg = "keyword" },                     onedark = { fg = "purple" },                    sonokai_shusia = { fg = "purple" },                    grey = { fg = "black", bold = true } },
  Label          = { vague = { fg = "keyword" },                     onedark = { fg = "purple" },                    sonokai_shusia = { fg = "purple" },                    grey = { fg = "black", bold = true } },
  Macro          = { vague = { fg = "constant" },                    onedark = { fg = "red" },                       sonokai_shusia = { fg = "red" },                       grey = { fg = "orange" } },
  Number         = { vague = { fg = "number" },                      onedark = { fg = "orange" },                    sonokai_shusia = { fg = "orange" },                    grey = { fg = "blue" } },
  Operator       = { vague = { fg = "operator" },                    onedark = { fg = "purple" },                    sonokai_shusia = { fg = "purple" },                    grey = { fg = "black" } },
  PreCondit      = { vague = { fg = "comment" },                     onedark = { fg = "purple" },                    sonokai_shusia = { fg = "purple" },                    grey = { fg = "orange" } },
  PreProc        = { vague = { fg = "constant" },                    onedark = { fg = "purple" },                    sonokai_shusia = { fg = "purple" },                    grey = { fg = "black" } },
  Repeat         = { vague = { fg = "keyword" },                     onedark = { fg = "purple" },                    sonokai_shusia = { fg = "purple" },                    grey = { fg = "black", bold = true } },
  Special        = { vague = { fg = "builtin" },                     onedark = { fg = "red" },                       sonokai_shusia = { fg = "red" },                       grey = { fg = "black" } },
  SpecialChar    = { vague = { fg = "keyword" },                     onedark = { fg = "red" },                       sonokai_shusia = { fg = "red" },                       grey = { fg = "black" } },
  SpecialComment = { vague = { fg = "keyword" },                     onedark = { fg = "grey", italic = true },       sonokai_shusia = { fg = "grey", italic = true },       grey = { fg = "grey" } },
  Statement      = { vague = { fg = "keyword" },                     onedark = { fg = "purple" },                    sonokai_shusia = { fg = "purple" },                    grey = { fg = "black", bold = true } },
  StorageClass   = { vague = { fg = "constant" },                    onedark = { fg = "yellow" },                    sonokai_shusia = { fg = "yellow" },                    grey = { fg = "black", bold = true } },
  String         = { vague = { fg = "string", italic = true },       onedark = { fg = "green" },                     sonokai_shusia = { fg = "green" },                     grey = { fg = "green" } },
  Structure      = { vague = { fg = "constant" },                    onedark = { fg = "yellow" },                    sonokai_shusia = { fg = "yellow" },                    grey = { fg = "black", bold = true } },
  Tag            = { vague = { fg = "builtin" },                     onedark = { fg = "green" },                     sonokai_shusia = { fg = "green" },                     grey = { fg = "black", bold = true } },
  Title          = { vague = { fg = "property" },                    onedark = { fg = "cyan" },                      sonokai_shusia = { fg = "blue" },                      grey = { fg = "black", bold = true } },
  Todo           = { vague = { fg = "func", italic = true },         onedark = { fg = "red", italic = true },        sonokai_shusia = { fg = "red", italic = true },        grey = { fg = "grey", bold = true } },
  Type           = { vague = { fg = "type" },                        onedark = { fg = "yellow" },                    sonokai_shusia = { fg = "yellow" },                    grey = { fg = "black" } },
  Typedef        = { vague = { fg = "constant" },                    onedark = { fg = "yellow" },                    sonokai_shusia = { fg = "yellow" },                    grey = { fg = "black", bold = true } },

  -- ───────────────────────── Treesitter ──────────────────────────

  ["@annotation"]                 = { vague = { fg = "fg" },                          onedark = { fg = "fg" },                          sonokai_shusia = { fg = "fg" },                          grey = { fg = "black" } },
  ["@attribute"]                  = { vague = { fg = "constant" },                    onedark = { fg = "cyan" },                        sonokai_shusia = { fg = "blue" },                        grey = { fg = "black" } },
  ["@attribute.typescript"]       = { vague = { fg = "hint" },                        onedark = { fg = "blue" },                        sonokai_shusia = { fg = "blue" },                        grey = { fg = "purple" } },
  ["@boolean"]                    = { vague = { fg = "number", bold = true },         onedark = { fg = "orange" },                      sonokai_shusia = { fg = "orange" },                      grey = { fg = "black", bold = true } },
  ["@character"]                  = { vague = { fg = "string", italic = true },       onedark = { fg = "orange" },                      sonokai_shusia = { fg = "orange" },                      grey = { fg = "green" } },
  ["@character.special"]          = { vague = { fg = "keyword" },                     onedark = { fg = "red" },                         sonokai_shusia = { fg = "red" },                         grey = { fg = "black" } },
  ["@comment"]                    = { vague = { fg = "comment", italic = true },      onedark = { fg = "grey", italic = true },         sonokai_shusia = { fg = "grey", italic = true },         grey = { fg = "grey" } },
  ["@comment.todo"]               = { vague = { fg = "func", italic = true },         onedark = { fg = "red", italic = true },          sonokai_shusia = { fg = "red", italic = true },          grey = { fg = "grey", bold = true } },
  ["@comment.todo.checked"]       = { vague = { fg = "plus", italic = true },         onedark = { fg = "green", italic = true },        sonokai_shusia = { fg = "green", italic = true },        grey = { fg = "green", bold = true } },
  ["@comment.todo.unchecked"]     = { vague = { fg = "func", italic = true },         onedark = { fg = "red", italic = true },          sonokai_shusia = { fg = "red", italic = true },          grey = { fg = "red", bold = true } },
  ["@constant"]                   = { vague = { fg = "constant" },                    onedark = { fg = "orange" },                      sonokai_shusia = { fg = "orange" },                      grey = { fg = "black" } },
  ["@constant.builtin"]           = { vague = { fg = "number", bold = true },         onedark = { fg = "orange" },                      sonokai_shusia = { fg = "orange" },                      grey = { fg = "black", bold = true } },
  ["@constant.macro"]             = { vague = { fg = "number" },                      onedark = { fg = "orange" },                      sonokai_shusia = { fg = "orange" },                      grey = { fg = "orange" } },
  ["@constructor"]                = { vague = { fg = "constant" },                    onedark = { fg = "yellow", bold = true },         sonokai_shusia = { fg = "yellow", bold = true },         grey = { fg = "black", bold = true } },
  ["@constructor.lua"]            = { vague = { fg = "type" },                        onedark = { fg = "light_grey" },                  sonokai_shusia = { fg = "grey_dim" },                    grey = { fg = "black" } },
  ["@danger"]                     = { vague = { fg = "fg" },                          onedark = { fg = "fg" },                          sonokai_shusia = { fg = "fg" },                          grey = { fg = "red", bold = true } },
  ["@diff.add"]                   = { vague = { fg = "plus" },                        onedark = { fg = "green" },                       sonokai_shusia = { fg = "green" },                       grey = { fg = "green" } },
  ["@diff.delete"]                = { vague = { fg = "error" },                       onedark = { fg = "red" },                         sonokai_shusia = { fg = "red" },                         grey = { fg = "red" } },
  ["@diff.delta"]                 = { vague = { fg = "delta" },                       onedark = { fg = "blue" },                        sonokai_shusia = { fg = "blue" },                        grey = { fg = "blue" } },
  ["@diff.minus"]                 = { vague = { fg = "error" },                       onedark = { fg = "red" },                         sonokai_shusia = { fg = "red" },                         grey = { fg = "red" } },
  ["@diff.plus"]                  = { vague = { fg = "plus" },                        onedark = { fg = "green" },                       sonokai_shusia = { fg = "green" },                       grey = { fg = "green" } },
  ["@error"]                      = { vague = { fg = "fg" },                          onedark = { fg = "fg" },                          sonokai_shusia = { fg = "fg" },                          grey = { fg = "red" } },
  ["@function"]                   = { vague = { fg = "func" },                        onedark = { fg = "blue" },                        sonokai_shusia = { fg = "blue" },                        grey = { fg = "black" } },
  ["@function.builtin"]           = { vague = { fg = "func" },                        onedark = { fg = "cyan" },                        sonokai_shusia = { fg = "blue" },                        grey = { fg = "black" } },
  ["@function.call"]              = { vague = { fg = "parameter" },                   onedark = { fg = "blue" },                        sonokai_shusia = { fg = "blue" },                        grey = { fg = "black" } },
  ["@function.macro"]             = { vague = { fg = "constant" },                    onedark = { fg = "cyan" },                        sonokai_shusia = { fg = "blue" },                        grey = { fg = "orange" } },
  ["@function.method"]            = { vague = { fg = "func" },                        onedark = { fg = "blue" },                        sonokai_shusia = { fg = "blue" },                        grey = { fg = "black" } },
  ["@function.method.call"]       = { vague = { fg = "func" },                        onedark = { fg = "blue" },                        sonokai_shusia = { fg = "blue" },                        grey = { fg = "black" } },
  ["@keyword"]                    = { vague = { fg = "keyword" },                     onedark = { fg = "purple" },                      sonokai_shusia = { fg = "purple" },                      grey = { fg = "black", bold = true } },
  ["@keyword.conditional"]        = { vague = { fg = "keyword" },                     onedark = { fg = "purple" },                      sonokai_shusia = { fg = "purple" },                      grey = { fg = "black", bold = true } },
  ["@keyword.directive"]          = { vague = { fg = "keyword" },                     onedark = { fg = "purple" },                      sonokai_shusia = { fg = "purple" },                      grey = { fg = "black", bold = true } },
  ["@keyword.exception"]          = { vague = { fg = "keyword" },                     onedark = { fg = "purple" },                      sonokai_shusia = { fg = "purple" },                      grey = { fg = "black", bold = true } },
  ["@keyword.function"]           = { vague = { fg = "keyword" },                     onedark = { fg = "purple" },                      sonokai_shusia = { fg = "purple" },                      grey = { fg = "black", bold = true } },
  ["@keyword.import"]             = { vague = { fg = "constant" },                    onedark = { fg = "purple" },                      sonokai_shusia = { fg = "purple" },                      grey = { fg = "black", bold = true } },
  ["@keyword.operator"]           = { vague = { fg = "keyword" },                     onedark = { fg = "purple" },                      sonokai_shusia = { fg = "purple" },                      grey = { fg = "black", bold = true } },
  ["@keyword.repeat"]             = { vague = { fg = "keyword" },                     onedark = { fg = "purple" },                      sonokai_shusia = { fg = "purple" },                      grey = { fg = "black", bold = true } },
  ["@keyword.return"]             = { vague = { fg = "keyword", italic = true },      onedark = { fg = "purple" },                      sonokai_shusia = { fg = "purple" },                      grey = { fg = "black", bold = true } },
  ["@label"]                      = { vague = { fg = "keyword" },                     onedark = { fg = "red" },                         sonokai_shusia = { fg = "red" },                         grey = { fg = "black", bold = true } },
  ["@markup"]                     = { vague = { fg = "fg" },                          onedark = { fg = "fg" },                          sonokai_shusia = { fg = "fg" },                          grey = { fg = "black" } },
  ["@markup.emphasis"]            = { vague = { fg = "fg", italic = true },           onedark = { fg = "fg", italic = true },           sonokai_shusia = { fg = "fg", italic = true },           grey = { fg = "black", italic = true } },
  ["@markup.environment"]         = { vague = { fg = "fg" },                          onedark = { fg = "fg" },                          sonokai_shusia = { fg = "fg" },                          grey = { fg = "black" } },
  ["@markup.environment.name"]    = { vague = { fg = "fg" },                          onedark = { fg = "fg" },                          sonokai_shusia = { fg = "fg" },                          grey = { fg = "black" } },
  ["@markup.heading"]             = { vague = { fg = "keyword", bold = true },        onedark = { fg = "orange", bold = true },         sonokai_shusia = { fg = "orange", bold = true },         grey = { fg = "black", bold = true } },
  ["@markup.heading.1.markdown"]  = { vague = { fg = "error", bold = true },          onedark = { fg = "red", bold = true },            sonokai_shusia = { fg = "red", bold = true },            grey = { fg = "black", bold = true } },
  ["@markup.heading.2.markdown"]  = { vague = { fg = "keyword", bold = true },        onedark = { fg = "purple", bold = true },         sonokai_shusia = { fg = "purple", bold = true },         grey = { fg = "black", bold = true } },
  ["@markup.heading.3.markdown"]  = { vague = { fg = "number", bold = true },         onedark = { fg = "orange", bold = true },         sonokai_shusia = { fg = "orange", bold = true },         grey = { fg = "black", bold = true } },
  ["@markup.heading.4.markdown"]  = { vague = { fg = "error", bold = true },          onedark = { fg = "red", bold = true },            sonokai_shusia = { fg = "red", bold = true },            grey = { fg = "black", bold = true } },
  ["@markup.heading.5.markdown"]  = { vague = { fg = "keyword", bold = true },        onedark = { fg = "purple", bold = true },         sonokai_shusia = { fg = "purple", bold = true },         grey = { fg = "black", bold = true } },
  ["@markup.heading.6.markdown"]  = { vague = { fg = "number", bold = true },         onedark = { fg = "orange", bold = true },         sonokai_shusia = { fg = "orange", bold = true },         grey = { fg = "black", bold = true } },
  ["@markup.heading.1.marker.markdown"] = { vague = { fg = "error", bold = true },    onedark = { fg = "red", bold = true },            sonokai_shusia = { fg = "red", bold = true },            grey = { fg = "black", bold = true } },
  ["@markup.heading.2.marker.markdown"] = { vague = { fg = "keyword", bold = true },  onedark = { fg = "purple", bold = true },         sonokai_shusia = { fg = "purple", bold = true },         grey = { fg = "black", bold = true } },
  ["@markup.heading.3.marker.markdown"] = { vague = { fg = "number", bold = true },   onedark = { fg = "orange", bold = true },         sonokai_shusia = { fg = "orange", bold = true },         grey = { fg = "black", bold = true } },
  ["@markup.heading.4.marker.markdown"] = { vague = { fg = "error", bold = true },    onedark = { fg = "red", bold = true },            sonokai_shusia = { fg = "red", bold = true },            grey = { fg = "black", bold = true } },
  ["@markup.heading.5.marker.markdown"] = { vague = { fg = "keyword", bold = true },  onedark = { fg = "purple", bold = true },         sonokai_shusia = { fg = "purple", bold = true },         grey = { fg = "black", bold = true } },
  ["@markup.heading.6.marker.markdown"] = { vague = { fg = "number", bold = true },   onedark = { fg = "orange", bold = true },         sonokai_shusia = { fg = "orange", bold = true },         grey = { fg = "black", bold = true } },
  ["@markup.italic"]              = { vague = { fg = "fg", italic = true },           onedark = { fg = "fg", italic = true },           sonokai_shusia = { fg = "fg", italic = true },           grey = { fg = "black", italic = true } },
  ["@markup.link"]                = { vague = { fg = "string" },                      onedark = { fg = "blue" },                        sonokai_shusia = { fg = "blue" },                        grey = { fg = "blue" } },
  ["@markup.link.url"]            = { vague = { fg = "string", underline = true },    onedark = { fg = "cyan", underline = true },      sonokai_shusia = { fg = "blue", underline = true },      grey = { fg = "blue", underline = true } },
  ["@markup.list"]                = { vague = { fg = "func" },                        onedark = { fg = "red" },                         sonokai_shusia = { fg = "red" },                         grey = { fg = "black", bold = true } },
  ["@markup.math"]                = { vague = { fg = "string" },                      onedark = { fg = "fg" },                          sonokai_shusia = { fg = "fg" },                          grey = { fg = "black" } },
  ["@markup.quote.markdown"]      = { vague = { fg = "comment" },                     onedark = { fg = "grey" },                        sonokai_shusia = { fg = "grey" },                        grey = { fg = "grey" } },
  ["@markup.raw"]                 = { vague = { fg = "constant" },                    onedark = { fg = "green" },                       sonokai_shusia = { fg = "green" },                       grey = { fg = "grey" } },
  ["@markup.strike"]              = { vague = { fg = "comment", strikethrough = true }, onedark = { fg = "fg", strikethrough = true },  sonokai_shusia = { fg = "fg", strikethrough = true },    grey = { fg = "grey", strikethrough = true } },
  ["@markup.strong"]              = { vague = { fg = "fg", bold = true },             onedark = { fg = "fg", bold = true },             sonokai_shusia = { fg = "fg", bold = true },             grey = { fg = "black", bold = true } },
  ["@markup.underline"]           = { vague = { fg = "fg", underline = true },        onedark = { fg = "fg", underline = true },        sonokai_shusia = { fg = "fg", underline = true },        grey = { fg = "black", underline = true } },
  ["@module"]                     = { vague = { fg = "constant" },                    onedark = { fg = "yellow" },                      sonokai_shusia = { fg = "yellow" },                      grey = { fg = "black" } },
  ["@none"]                       = { vague = { fg = "fg" },                          onedark = { fg = "fg" },                          sonokai_shusia = { fg = "fg" },                          grey = { fg = "black" } },
  ["@note"]                       = { vague = { fg = "fg" },                          onedark = { fg = "fg" },                          sonokai_shusia = { fg = "fg" },                          grey = { fg = "black" } },
  ["@number"]                     = { vague = { fg = "number" },                      onedark = { fg = "orange" },                      sonokai_shusia = { fg = "orange" },                      grey = { fg = "blue" } },
  ["@number.float"]               = { vague = { fg = "number" },                      onedark = { fg = "orange" },                      sonokai_shusia = { fg = "orange" },                      grey = { fg = "blue" } },
  ["@operator"]                   = { vague = { fg = "operator" },                    onedark = { fg = "fg" },                          sonokai_shusia = { fg = "fg" },                          grey = { fg = "black" } },
  ["@parameter.reference"]        = { vague = { fg = "fg" },                          onedark = { fg = "fg" },                          sonokai_shusia = { fg = "fg" },                          grey = { fg = "orange" } },
  ["@property"]                   = { vague = { fg = "property" },                    onedark = { fg = "cyan" },                        sonokai_shusia = { fg = "blue" },                        grey = { fg = "black" } },
  ["@punctuation.bracket"]        = { vague = { fg = "fg" },                          onedark = { fg = "light_grey" },                  sonokai_shusia = { fg = "grey_dim" },                    grey = { fg = "black" } },
  ["@punctuation.delimiter"]      = { vague = { fg = "fg" },                          onedark = { fg = "light_grey" },                  sonokai_shusia = { fg = "grey_dim" },                    grey = { fg = "black" } },
  ["@punctuation.special"]        = { vague = { fg = "keyword" },                     onedark = { fg = "red" },                         sonokai_shusia = { fg = "red" },                         grey = { fg = "black" } },
  ["@string"]                     = { vague = { fg = "string", italic = true },       onedark = { fg = "green" },                       sonokai_shusia = { fg = "green" },                       grey = { fg = "green" } },
  ["@string.escape"]              = { vague = { fg = "keyword" },                     onedark = { fg = "red" },                         sonokai_shusia = { fg = "red" },                         grey = { fg = "orange" } },
  ["@string.regexp"]              = { vague = { fg = "keyword" },                     onedark = { fg = "orange" },                      sonokai_shusia = { fg = "orange" },                      grey = { fg = "orange" } },
  ["@string.special.symbol"]      = { vague = { fg = "constant" },                    onedark = { fg = "cyan" },                        sonokai_shusia = { fg = "blue" },                        grey = { fg = "orange" } },
  ["@string.special.url"]         = { vague = { fg = "func" },                        onedark = { fg = "cyan", underline = true },      sonokai_shusia = { fg = "blue", underline = true },      grey = { fg = "blue" } },
  ["@tag"]                        = { vague = { fg = "keyword" },                     onedark = { fg = "purple" },                      sonokai_shusia = { fg = "purple" },                      grey = { fg = "black", bold = true } },
  ["@tag.attribute"]              = { vague = { fg = "constant" },                    onedark = { fg = "yellow" },                      sonokai_shusia = { fg = "yellow" },                      grey = { fg = "black" } },
  ["@tag.delimiter"]              = { vague = { fg = "fg" },                          onedark = { fg = "purple" },                      sonokai_shusia = { fg = "purple" },                      grey = { fg = "black" } },
  ["@text"]                       = { vague = { fg = "fg" },                          onedark = { fg = "fg" },                          sonokai_shusia = { fg = "fg" },                          grey = { fg = "black" } },
  ["@type"]                       = { vague = { fg = "builtin" },                     onedark = { fg = "yellow" },                      sonokai_shusia = { fg = "yellow" },                      grey = { fg = "black" } },
  ["@type.builtin"]               = { vague = { fg = "builtin", bold = true },        onedark = { fg = "orange" },                      sonokai_shusia = { fg = "orange" },                      grey = { fg = "black", bold = true } },
  ["@type.declaration"]           = { vague = { fg = "constant" },                    onedark = { fg = "yellow" },                      sonokai_shusia = { fg = "yellow" },                      grey = { fg = "black" } },
  ["@type.definition"]            = { vague = { fg = "constant" },                    onedark = { fg = "yellow" },                      sonokai_shusia = { fg = "yellow" },                      grey = { fg = "black" } },
  ["@variable"]                   = { vague = { fg = "fg" },                          onedark = { fg = "fg" },                          sonokai_shusia = { fg = "fg" },                          grey = { fg = "black" } },
  ["@variable.builtin"]           = { vague = { fg = "builtin", italic = true },      onedark = { fg = "red" },                         sonokai_shusia = { fg = "red" },                         grey = { fg = "black", bold = true } },
  ["@variable.member"]            = { vague = { fg = "builtin" },                     onedark = { fg = "cyan" },                        sonokai_shusia = { fg = "blue" },                        grey = { fg = "purple" } },
  ["@variable.parameter"]         = { vague = { fg = "parameter" },                   onedark = { fg = "red" },                         sonokai_shusia = { fg = "red" },                         grey = { fg = "orange" } },
  ["@warning"]                    = { vague = { fg = "fg" },                          onedark = { fg = "fg" },                          sonokai_shusia = { fg = "fg" },                          grey = { fg = "dark_yellow" } },
}
