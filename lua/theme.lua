-- Role-based theme dispatcher. Each palette file exports a table of
-- role → highlight spec. `highlights.lua` and `plugin_highlights.lua`
-- reference roles by name (or supply a palette-agnostic spec inline).

local colorscheme = {
  light = "grey",
  dark = "vague",
}

local palettes = {
  onedark        = require("palette.onedark"),
  onelight       = require("palette.onelight"),
  vague          = require("palette.vague"),
  sonokai_shusia = require("palette.sonokai_shusia"),
  grey           = require("palette.grey"),
}

local F = {}
local S = (function()
  if not G.theme then G.theme = {} end
  return G.theme
end)()

function F.init_autocmds()
  local group = vim.api.nvim_create_augroup("theme", {})
  vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    group = group,
    callback = function()
      if vim.api.nvim_get_mode()["mode"] == "no" then
        vim.hl.on_yank({ higroup = "Visual", timeout = 75 })
      end
    end,
  })
  S.autocmds_loaded = true
end

--- Resolve a highlights entry against the current palette.
---   string  → palette[string] (role lookup; must exist)
---   table   → applied as-is, unless it carries the `_blink_kind` marker
---             (expanded into { fg = palette.blink_kind[name], blend = 0 })
---@param entry any
---@param palette table
---@param group string   highlight group name (for error messages)
---@return table
local function resolve(entry, palette, group)
  if type(entry) == "string" then
    local spec = palette[entry]
    assert(spec, ("highlight %q references missing palette role %q"):format(group, entry))
    return spec
  end
  if entry._blink_kind then
    local color = palette.blink_kind[entry._blink_kind]
    assert(color, ("blink_kind missing entry %q"):format(entry._blink_kind))
    return { fg = color, blend = 0 }
  end
  return entry
end

local function apply_table(tbl, palette)
  for group, entry in pairs(tbl) do
    vim.api.nvim_set_hl(0, group, resolve(entry, palette, group))
  end
end

function F.apply_theme()
  vim.cmd("hi clear")

  local name = colorscheme[vim.o.background]
  local palette = palettes[name]

  -- Invalidate caches so edits land without an nvim restart.
  package.loaded["highlights"] = nil
  package.loaded["plugin_highlights"] = nil

  apply_table(require("highlights"), palette)
  apply_table(require("plugin_highlights"), palette)

  vim.g.colors_name = "custom"
end

function F.setup()
  F.init_autocmds()
  vim.o.cursorline = true
end

function F.once(fn)
  local called = false
  return function()
    if not called then fn(); called = true end
  end
end

return {
  setup = F.once(F.setup),
  apply_theme = F.apply_theme,
}
