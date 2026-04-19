-- stylua: ignore start

-- Plugin-specific highlights. Same shape as lua/highlights.lua — theme.lua
-- applies both tables on every theme switch. Each entry is either a role
-- name (string, resolved against the current palette) or a palette-agnostic
-- spec (table).

local M = {
  -- ─── Harpoon ───
  HarpoonBorder = "harpoon_border",
  HarpoonWindow = "harpoon_window",

  -- ─── Treesitter context ───
  TreesitterContext       = "ts_context",
  TreesitterContextBottom = "ts_context_bottom",

  -- ─── Mini.files ───
  MiniFilesBorder         = "mini_files_border",
  MiniFilesBorderModified = "mini_files_modified",
  MiniFilesNormal         = "mini_files_normal",

  -- MiniCursorword / MiniCursorwordCurrent are set in the late-apply block
  -- at the bottom of this file — mini's `default = true` re-link means
  -- overrides must run after its ColorScheme autocmd.

  -- ─── Telescope ───
  TelescopeBorder         = "telescope_border",
  TelescopePromptBorder   = "telescope_prompt_border",
  TelescopeResultsBorder  = "telescope_prompt_border",
  TelescopePreviewBorder  = "telescope_prompt_border",
  TelescopeMatching       = "telescope_matching",
  TelescopeSelection      = "telescope_selection",
  TelescopeSelectionCaret = "telescope_caret",

  -- ─── Blink ───
  BlinkCmpMenu          = { link = "NormalFloat" },
  BlinkCmpMenuBorder    = { link = "FloatBorder" },
  BlinkCmpDocBorder     = { link = "FloatBorder" },
  BlinkCmpSource        = "blink_source",
  BlinkCmpMenuSelection = "blink_menu_selection",

  -- ─── Snacks.indent ───
  SnacksIndent  = "snacks_indent",
  SnacksIndent1 = "snacks_indent1",

  -- ─── Language-specific overrides ───
  xmlTagName = "xml_tag_name",

  -- ─── Diffview (palette-agnostic links) ───
  DiffviewFilePanelRootPath = { link = "Keyword" },
  DiffviewFilePanelCounter  = { link = "Removed" },
  DiffviewFilePanelTitle    = { link = "Keyword" },
  DiffviewFilePanelFileName = { link = "Normal" },
  DiffviewFilePanelSelected = { link = "Question" },
  DiffviewFilePanelPath     = { link = "LineNr" },
  DiffviewSecondary         = { link = "String" },
}

-- ─── Blink kind icons ───
-- Each palette exports a `blink_kind` table mapping kind name → color.
-- We expand it here into BlinkCmpKind<Kind> entries; theme.lua's resolver
-- handles the palette-dispatch at apply time.
local kind_names = {
  "Default", "Array", "Boolean", "Class", "Color", "Constant", "Constructor",
  "Enum", "EnumMember", "Event", "Field", "File", "Folder", "Function",
  "Interface", "Key", "Keyword", "Method", "Module", "Namespace", "Null",
  "Number", "Object", "Operator", "Package", "Property", "Reference",
  "Snippet", "String", "Struct", "Text", "TypeParameter", "Unit", "Value",
  "Variable",
}
for _, kind in ipairs(kind_names) do
  -- A role token that theme.lua's resolver turns into { fg = palette.blink_kind[kind], blend = 0 }.
  M["BlinkCmpKind" .. kind] = { _blink_kind = kind }
end

-- ─── Late-apply overrides ───
-- Some plugins re-register highlight defaults via `default = true` after
-- our apply_theme runs (mini.cursorword links MiniCursorwordCurrent back
-- to MiniCursorword on setup and on every ColorScheme event). Our normal
-- apply can't win that race because it fires before the plugin's autocmd.
-- This block re-asserts those groups *after* the plugin's default-linking.

local function late_overrides()
  vim.api.nvim_set_hl(0, "MiniCursorword", { link = "CursorColumn" })
  vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", {})
end

local group = vim.api.nvim_create_augroup("plugin-highlights-late", { clear = true })
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy", group = group, once = true, callback = late_overrides,
  desc = "Apply late plugin-highlight overrides once plugins have loaded",
})
vim.api.nvim_create_autocmd("ColorScheme", {
  group = group, callback = late_overrides,
  desc = "Re-apply late plugin-highlight overrides on theme switches",
})

return M
