---@see VaguePalette
---@see OneDarkPalette
---@see SonokaiShusiaPalette
---@see GreyPalette

local colorscheme = {
  light = "grey",
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
  if not G.theme then G.theme = {} end
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

local required_palettes = { "vague", "onedark", "sonokai_shusia", "grey" }

--- Fail loudly if any group has some but not all required palette variants.
---@param tbl table
---@param source string
local function assert_no_drift(tbl, source)
  for group, spec in pairs(tbl) do
    local has_any = false
    for _, key in ipairs(required_palettes) do
      if spec[key] then has_any = true; break end
    end
    if has_any then
      for _, key in ipairs(required_palettes) do
        assert(spec[key],
          ("%s: %s is missing palette variant %q"):format(source, group, key))
      end
    end
  end
end

local function apply_table(tbl, shape, palette)
  for group, spec in pairs(tbl) do
    ---@type any
    local variant = spec
    if spec.vague or spec.onedark or spec.sonokai_shusia or spec.grey then
      variant = spec[shape]
    end
    vim.api.nvim_set_hl(0, group, resolve(variant, palette))
  end
end

function F.apply_theme()
  vim.cmd("hi clear")

  local name = colorscheme[vim.o.background]
  local shape = spec_shape[name]
  local palette = palettes[name].get_palette()

  -- Invalidate require caches so edits land without an nvim restart.
  package.loaded["highlights"] = nil
  package.loaded["plugin_highlights"] = nil
  local highlights = require("highlights")
  local plugin_highlights = require("plugin_highlights")

  assert_no_drift(highlights, "highlights.lua")
  assert_no_drift(plugin_highlights, "plugin_highlights.lua")

  apply_table(highlights, shape, palette)
  apply_table(plugin_highlights, shape, palette)

  vim.g.colors_name = "custom"
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
}
