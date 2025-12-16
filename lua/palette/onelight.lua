local F = {}

---@type OneDarkPalette
F.palette = {
  black = "#101012",
  bg0 = "#fafafa",
  bg1 = "#f0f0f0",
  bg2 = "#e6e6e6",
  bg3 = "#dcdcdc",
  bg_d = "#c9c9c9",
  bg_hl = "#f0f0f0",
  bg_blue = "#68aee8",
  bg_yellow = "#e2c792",
  fg = "#383a42",
  purple = "#a626a4",
  green = "#50a14f",
  orange = "#c18401",
  blue = "#4078f2",
  yellow = "#986801",
  cyan = "#0184bc",
  red = "#e45649",
  grey = "#a0a1a7",
  light_grey = "#818387",
  dark_cyan = "#2b5d63",
  dark_red = "#833b3b",
  dark_yellow = "#7c5c20",
  dark_purple = "#79428a",
  diff_add = "#e2fbe4",
  diff_delete = "#fce2e5",
  diff_change = "#e2ecfb",
  diff_text = "#cad3e0",
}

function F.get_palette() return F.palette end

---@return table<string, vim.api.keyset.highlight>
function F.build_highlights()
  return require("palette.onedark").build_themed_highlights(F.palette)
end

return {
  get_palette = F.get_palette,
  build_highlights = F.build_highlights,
}
