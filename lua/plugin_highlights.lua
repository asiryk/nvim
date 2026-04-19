-- stylua: ignore start

-- Plugin-specific highlights. Same shape as lua/highlights.lua — theme.lua
-- applies both tables on every theme switch, and the drift assert enforces
-- that any group with a palette variant has all of them.
--
-- When adding a new palette, edit this file in one place instead of every
-- lua/plugins/* file.

local M = {
  -- ───────────────────────── Harpoon ─────────────────────────

  HarpoonBorder = {
    vague          = { fg = "error" },
    onedark        = { fg = "cyan" },
    sonokai_shusia = { fg = "red" },
    grey           = { fg = "border" },
  },
  HarpoonWindow = {
    vague          = { fg = "fg" },
    onedark        = { fg = "fg" },
    sonokai_shusia = { fg = "fg" },
    grey           = { fg = "black" },
  },

  -- ─────────────────── Treesitter context ────────────────────

  TreesitterContext = {
    vague          = { bg = "bg" },
    onedark        = { bg = "bg0" },
    sonokai_shusia = { bg = "bg_dim" },
    grey           = { bg = "grey_bg_light" },
  },
  TreesitterContextBottom = {
    vague          = { bg = "bg",            sp = "fg",    underline = true },
    onedark        = { bg = "bg0",           sp = "fg",    underline = true },
    sonokai_shusia = { bg = "bg_dim",        sp = "fg",    underline = true },
    grey           = { bg = "grey_bg_light", sp = "black", underline = true },
  },

  -- ──────────────────────── Mini.files ───────────────────────

  MiniFilesBorder = {
    vague          = { fg = "floatBorder" },
    onedark        = { fg = "cyan" },
    sonokai_shusia = { fg = "blue" },
    grey           = { fg = "border" },
  },
  MiniFilesBorderModified = {
    vague          = { fg = "warning" },
    onedark        = { fg = "yellow" },
    sonokai_shusia = { fg = "yellow" },
    grey           = { fg = "dark_yellow" },
  },
  MiniFilesNormal = {
    vague          = { fg = "fg" },
    onedark        = { fg = "fg" },
    sonokai_shusia = { fg = "fg" },
    grey           = { fg = "black" },
  },

  -- ────────────────────── Mini.cursorword ────────────────────

  MiniCursorword = {
    vague          = { bg = "line" },
    onedark        = { bg = "bg_hl" },
    sonokai_shusia = { bg = "bg1" },
    grey           = { bg = "highlight" },
  },
  MiniCursorwordCurrent = {},

  -- ───────────────────────── Telescope ───────────────────────

  TelescopeBorder = {
    vague          = { link = "FloatBorder" },
    onedark        = { fg = "red" },
    sonokai_shusia = { fg = "red" },
    grey           = { fg = "border" },
  },
  TelescopePromptBorder = {
    vague          = { link = "FloatBorder" },
    onedark        = { fg = "cyan" },
    sonokai_shusia = { fg = "blue" },
    grey           = { fg = "border" },
  },
  TelescopeResultsBorder = {
    vague          = { link = "FloatBorder" },
    onedark        = { fg = "cyan" },
    sonokai_shusia = { fg = "blue" },
    grey           = { fg = "border" },
  },
  TelescopePreviewBorder = {
    vague          = { link = "FloatBorder" },
    onedark        = { fg = "cyan" },
    sonokai_shusia = { fg = "blue" },
    grey           = { fg = "border" },
  },
  TelescopeMatching = {
    vague          = { fg = "func",        bold = true },
    onedark        = { fg = "orange",      bold = true },
    sonokai_shusia = { fg = "orange",      bold = true },
    grey           = { fg = "dark_yellow", bold = true },
  },
  TelescopeSelection = {
    vague          = { bg = "line" },
    onedark        = { bg = "bg2" },
    sonokai_shusia = { bg = "bg2" },
    grey           = { bg = "light_grey", bold = true },
  },
  TelescopeSelectionCaret = {
    vague          = { fg = "keyword" },
    onedark        = { fg = "yellow" },
    sonokai_shusia = { fg = "yellow" },
    grey           = { fg = "black", bold = true },
  },

  -- ─────────────────────────── Blink ─────────────────────────
  -- Static link entries; per-kind fg colors are looped in below.

  BlinkCmpMenu       = { link = "NormalFloat" },
  BlinkCmpMenuBorder = { link = "FloatBorder" },
  BlinkCmpDocBorder  = { link = "FloatBorder" },
  BlinkCmpSource = {
    vague          = { fg = "floatBorder", italic = true },
    onedark        = { fg = "bg3",         italic = true },
    sonokai_shusia = { fg = "bg3",         italic = true },
    grey           = { fg = "border",      italic = true },
  },
  BlinkCmpMenuSelection = {
    vague          = { link = "PmenuSel" },
    onedark        = { link = "PmenuSel" },
    sonokai_shusia = { fg = "fg", bg = "bg_blue" },
    grey           = { link = "PmenuSel" },
  },

  -- ────────────────────────── Diffview ───────────────────────
  -- Palette-agnostic — all palettes share the same links.

  DiffviewFilePanelRootPath = { link = "Keyword" },
  DiffviewFilePanelCounter  = { link = "Removed" },
  DiffviewFilePanelTitle    = { link = "Keyword" },
  DiffviewFilePanelFileName = { link = "Normal" },
  DiffviewFilePanelSelected = { link = "Question" },
  DiffviewFilePanelPath     = { link = "LineNr" },
  DiffviewSecondary         = { link = "String" },
}

-- ─────────────────────── Blink kind icons ──────────────────────
-- Each palette maps every LSP kind to one of its palette colors. The
-- loop below expands this into BlinkCmpKind<Kind> entries with all four
-- palette variants present (so the drift assert stays happy).

local kind_colors = {
  vague = {
    Default       = "property", Array         = "constant", Boolean       = "number",
    Class         = "constant", Color         = "constant", Constant      = "number",
    Constructor   = "constant", Enum          = "property", EnumMember    = "string",
    Event         = "string",   Field         = "property", File          = "constant",
    Folder        = "number",   Function      = "func",     Interface     = "constant",
    Key           = "keyword",  Keyword       = "keyword",  Method        = "func",
    Module        = "number",   Namespace     = "operator", Null          = "fg",
    Number        = "number",   Object        = "operator", Operator      = "operator",
    Package       = "constant", Property      = "property", Reference     = "number",
    Snippet       = "operator", String        = "constant", Struct        = "property",
    Text          = "floatBorder", TypeParameter = "operator", Unit        = "constant",
    Value         = "number",   Variable      = "property",
  },
  onedark = {
    Default       = "purple", Array         = "yellow", Boolean       = "orange",
    Class         = "yellow", Color         = "green",  Constant      = "orange",
    Constructor   = "blue",   Enum          = "purple", EnumMember    = "yellow",
    Event         = "yellow", Field         = "purple", File          = "blue",
    Folder        = "orange", Function      = "blue",   Interface     = "green",
    Key           = "cyan",   Keyword       = "cyan",   Method        = "blue",
    Module        = "orange", Namespace     = "red",    Null          = "grey",
    Number        = "orange", Object        = "red",    Operator      = "red",
    Package       = "yellow", Property      = "cyan",   Reference     = "orange",
    Snippet       = "red",    String        = "green",  Struct        = "purple",
    Text          = "light_grey", TypeParameter = "red", Unit         = "green",
    Value         = "orange", Variable      = "purple",
  },
  sonokai_shusia = {
    Default       = "purple", Array         = "yellow", Boolean       = "orange",
    Class         = "yellow", Color         = "green",  Constant      = "orange",
    Constructor   = "blue",   Enum          = "purple", EnumMember    = "yellow",
    Event         = "yellow", Field         = "purple", File          = "blue",
    Folder        = "orange", Function      = "blue",   Interface     = "green",
    Key           = "blue",   Keyword       = "blue",   Method        = "blue",
    Module        = "orange", Namespace     = "red",    Null          = "grey",
    Number        = "orange", Object        = "red",    Operator      = "red",
    Package       = "yellow", Property      = "blue",   Reference     = "orange",
    Snippet       = "red",    String        = "green",  Struct        = "purple",
    Text          = "grey_dim", TypeParameter = "red",  Unit          = "green",
    Value         = "orange", Variable      = "purple",
  },
  grey = {
    Default       = "black",  Array         = "black",  Boolean       = "black",
    Class         = "black",  Color         = "green",  Constant      = "black",
    Constructor   = "black",  Enum          = "black",  EnumMember    = "purple",
    Event         = "orange", Field         = "black",  File          = "blue",
    Folder        = "purple", Function      = "black",  Interface     = "black",
    Key           = "black",  Keyword       = "black",  Method        = "black",
    Module        = "black",  Namespace     = "black",  Null          = "grey",
    Number        = "blue",   Object        = "black",  Operator      = "black",
    Package       = "black",  Property      = "black",  Reference     = "orange",
    Snippet       = "orange", String        = "green",  Struct        = "black",
    Text          = "grey",   TypeParameter = "black",  Unit          = "green",
    Value         = "blue",   Variable      = "black",
  },
}

for kind in pairs(kind_colors.vague) do
  M["BlinkCmpKind" .. kind] = {
    vague          = { fg = kind_colors.vague[kind],          blend = 0 },
    onedark        = { fg = kind_colors.onedark[kind],        blend = 0 },
    sonokai_shusia = { fg = kind_colors.sonokai_shusia[kind], blend = 0 },
    grey           = { fg = kind_colors.grey[kind],           blend = 0 },
  }
end

return M
