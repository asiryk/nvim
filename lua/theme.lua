---@see VaguePalette
---@see OneDarkPalette
---@see SonokaiShusiaPalette
---@see GreyPalette

local colorscheme = {
  light = "onelight",
  dark = "vague",
}

local palettes = {
  onedark = require("palette.onedark"),
  onelight = require("palette.onelight"),
  vague = require("palette.vague"),
  sonokai_shusia = require("palette.sonokai_shusia"),
  grey = require("palette.grey"),
}

--- Which palette *shape* a highlight spec uses in highlights.lua.
--- onelight uses onedark's spec shape but onelight's color values.
local spec_shape = {
  vague = "vague",
  onedark = "onedark",
  onelight = "onedark",
  sonokai_shusia = "sonokai_shusia",
  grey = "grey",
}

local F = {}
local S = (function()
  if not G.theme then G.theme = {
    added_highlights = {},
  } end
  return G.theme
end)()

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
        vim.hl.on_yank({
          higroup = "Visual",
          timeout = 75,
        })
      end
    end,
  })

  S.autocmds_loaded = true
end

--- Resolve a spec against a palette: string values matching a palette key
--- become the palette color; everything else ("none", "#aabbcc", booleans,
--- links, numbers) passes through unchanged.
---@param spec table
---@param palette table
---@return table
local function resolve(spec, palette)
  local out = {}
  for k, v in pairs(spec) do
    if type(v) == "string" and palette[v] then
      out[k] = palette[v]
    else
      out[k] = v
    end
  end
  return out
end

--- Fail loudly if any group in highlights.lua is missing a palette variant.
---@param highlights table
local function assert_no_drift(highlights)
  local required = { "vague", "onedark", "sonokai_shusia", "grey" }
  for group, spec in pairs(highlights) do
    local has_any = false
    for _, key in ipairs(required) do
      if spec[key] then has_any = true; break end
    end
    if has_any then
      for _, key in ipairs(required) do
        assert(spec[key],
          ("highlights.lua: %s is missing palette variant %q"):format(group, key))
      end
    end
  end
end

function F.apply_highlight(highlight)
  for group, hl in pairs(highlight) do
    vim.api.nvim_set_hl(0, group, hl)
  end
end

function F.apply_theme()
  vim.cmd("hi clear")

  local name = colorscheme[vim.o.background]
  local shape = spec_shape[name]
  local palette = palettes[name].get_palette()

  -- Invalidate require cache so edits to highlights.lua land on next
  -- apply without needing an nvim restart.
  package.loaded["highlights"] = nil
  local highlights = require("highlights")

  assert_no_drift(highlights)

  for group, spec in pairs(highlights) do
    ---@type any
    local variant = spec
    if spec.vague or spec.onedark or spec.sonokai_shusia or spec.grey then variant = spec[shape] end
    vim.api.nvim_set_hl(0, group, resolve(variant, palette))
  end

  for _, added_palettes in pairs(S.added_highlights) do
    local added_hl = added_palettes[name](palette)
    F.apply_highlight(added_hl)
  end
  vim.g.colors_name = "custom"
end

---@class AddedHighlights
---@field vague fun(palette: VaguePalette): table<string, vim.api.keyset.highlight>
---@field onedark fun(palette: OneDarkPalette): table<string, vim.api.keyset.highlight>
---@field sonokai_shusia fun(palette: SonokaiShusiaPalette): table<string, vim.api.keyset.highlight>
---@field grey fun(palette: GreyPalette): table<string, vim.api.keyset.highlight>

--- Add custom highlights and apply them immediately
---@param fn fun(): (string, AddedHighlights)
function F.add_highlights(fn)
  local scope, highlights = fn()

  --- onelight uses onedark palette, no need to define them both on user side
  ---@diagnostic disable-next-line
  highlights.onelight = highlights.onedark

  S.added_highlights[scope] = highlights

  local name = colorscheme[vim.o.background]
  local palette = palettes[name].get_palette()
  local hl_groups = highlights[name](palette)
  F.apply_highlight(hl_groups)
end

function F.setup()
  F.init_autocmds()
  -- Set cursorline (highlights set up to highlight only line number)
  vim.o.cursorline = true
end

function F.once(fn)
  local called = false
  return function()
    if not called then
      fn()
      called = true
    end
  end
end

return {
  setup = F.once(F.setup),
  apply_theme = F.apply_theme,
  add_highlights = F.add_highlights,
}
