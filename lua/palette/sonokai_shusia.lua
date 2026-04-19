-- original https://github.com/sainnhe/sonokai (shusia style)

---@class SonokaiShusiaPalette
---@field black string
---@field bg_dim string
---@field bg0 string
---@field bg1 string
---@field bg2 string
---@field bg3 string
---@field bg4 string
---@field bg_red string
---@field bg_yellow string
---@field bg_green string
---@field bg_blue string
---@field bg_purple string
---@field diff_text string
---@field filled_red string
---@field filled_green string
---@field filled_blue string
---@field fg string
---@field red string
---@field orange string
---@field yellow string
---@field green string
---@field blue string
---@field purple string
---@field grey string
---@field grey_dim string

---@type SonokaiShusiaPalette
local palette = {
  black = "#1a181a",
  bg_dim = "#211f21",
  bg0 = "#2d2a2e",
  bg1 = "#37343a",
  bg2 = "#3b383e",
  bg3 = "#423f46",
  bg4 = "#49464e",
  bg_red = "#55393d",
  bg_yellow = "#4e432f",
  bg_green = "#394634",
  bg_blue = "#354157",
  bg_purple = "#433d51",
  diff_text = "#4e6380",
  filled_red = "#ff6188",
  filled_green = "#a9dc76",
  filled_blue = "#78dce8",
  fg = "#e3e1e4",
  red = "#f85e84",
  orange = "#ef9062",
  yellow = "#e5c463",
  green = "#9ecd6f",
  blue = "#7accd7",
  purple = "#ab9df2",
  grey = "#848089",
  grey_dim = "#605d68",
}

return {
  ---@return SonokaiShusiaPalette
  get_palette = function() return palette end,
}
