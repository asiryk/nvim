-- original https://github.com/yorickpeterse/nvim-grey

---@class GreyPalette
---@field background string
---@field grey_bg_light string
---@field black string
---@field blue string
---@field light_blue string
---@field diff_text string
---@field green string
---@field light_green string
---@field light_red string
---@field red string
---@field grey string
---@field light_grey string
---@field visual string
---@field border string
---@field highlight string
---@field dark_yellow string
---@field yellow string
---@field light_yellow string
---@field orange string
---@field purple string
---@field white string
---@field cyan string

---@type GreyPalette
local palette = {
  background = "#f2f2f2",
  grey_bg_light = "#ececec",
  black = "#000000",
  blue = "#1561b8",
  light_blue = "#d3e0f2",
  diff_text = "#a8c2de",
  green = "#1C5708",
  light_green = "#dfeacc",
  light_red = "#f2d3cd",
  red = "#c4331d",
  grey = "#5e5e5e",
  light_grey = "#e6e6e6",
  visual = "#d6d6d6",
  border = "#cccccc",
  highlight = "#eeeeee",
  dark_yellow = "#b37f02",
  yellow = "#f9db70",
  light_yellow = "#f9eab3",
  orange = "#a55000",
  purple = "#5c21a5",
  white = "#ffffff",
  cyan = "#007872",
}

return {
  ---@return GreyPalette
  get_palette = function() return palette end,
}
