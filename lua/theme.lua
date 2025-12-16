---@see VaguePalette
---@see OneDarkPalette

local colorscheme = {
  light = "onelight",
  dark = "vague",
}

local palettes = {
  onedark = require("palette.onedark"),
  onelight = require("palette.onelight"),
  vague = require("palette.vague"),
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
        vim.highlight.on_yank({
          higroup = "Visual",
          timeout = 75,
        })
      end
    end,
  })

  S.autocmds_loaded = true
end

function F.apply_highlight(highlight)
  for group, hl in pairs(highlight) do
    vim.api.nvim_set_hl(0, group, hl)
  end
end

function F.apply_theme()
  local name = colorscheme[vim.o.background]
  local highlights = palettes[name].build_highlights()

  for _, highlight in pairs(highlights) do
    F.apply_highlight(highlight)
  end

  for _, added_palettes in pairs(S.added_highlights) do
    local palette = palettes[name].get_palette()
    local added_hl = added_palettes[name](palette)
    F.apply_highlight(added_hl)
  end
  vim.g.colors_name = "custom"
end

---@class AddedHighlights
---@field vague fun(palette: VaguePalette): table<string, vim.api.keyset.highlight>
---@field onedark fun(palette: OneDarkPalette): table<string, vim.api.keyset.highlight>

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
