-- original https://github.com/vague-theme/vague.nvim/tree/main

---@class VaguePalette
---@field bg string
---@field inactiveBg string
---@field fg string
---@field floatBorder string
---@field line string
---@field comment string
---@field builtin string
---@field func string
---@field string string
---@field number string
---@field property string
---@field constant string
---@field parameter string
---@field visual string
---@field error string
---@field warning string
---@field hint string
---@field operator string
---@field keyword string
---@field type string
---@field search string
---@field plus string
---@field delta string

---@type VaguePalette
local palette = {
  bg = "#141415",
  inactiveBg = "#1c1c24",
  fg = "#cdcdcd",
  floatBorder = "#878787",
  line = "#252530",
  comment = "#606079",
  builtin = "#b4d4cf",
  func = "#c48282",
  string = "#e8b589",
  number = "#e0a363",
  property = "#c3c3d5",
  constant = "#aeaed1",
  parameter = "#bb9dbd",
  visual = "#333738",
  error = "#d8647e",
  warning = "#f3be7c",
  hint = "#7e98e8",
  operator = "#90a0b5",
  keyword = "#6e94b2",
  type = "#9bb4bc",
  search = "#405065",
  plus = "#7fa563",
  delta = "#6e94b2",
}

return {
  ---@return VaguePalette
  get_palette = function() return palette end,
}

-- Reference: the original blend() used to compute DiffAdd/Change/Delete/Text
-- backgrounds in highlights.lua. Kept commented so the formulas stay
-- rediscoverable if those literals ever need retuning.
--
-- local function color_to_rgb(color)
--   local function byte(value, offset) return bit.band(bit.rshift(value, offset), 0xFF) end
--
--   local new_color = vim.api.nvim_get_color_by_name(color)
--   if new_color == -1 then
--     new_color = vim.opt.background:get() == "dark" and 000 or 255255255
--   end
--
--   return { byte(new_color, 16), byte(new_color, 8), byte(new_color, 0) }
-- end
--
-- ---@param color string       Color to blend
-- ---@param base_color string  Base color to blend on
-- ---@param alpha number       Between 0 (base) and 1 (color)
-- ---@return string hex
-- local function blend(color, base_color, alpha)
--   local fg_rgb = color_to_rgb(color)
--   local bg_rgb = color_to_rgb(base_color)
--   local function blend_channel(i)
--     local ret = (alpha * fg_rgb[i] + ((1 - alpha) * bg_rgb[i]))
--     return math.floor(math.min(math.max(0, ret), 255) + 0.5)
--   end
--   return string.format("#%02X%02X%02X", blend_channel(1), blend_channel(2), blend_channel(3))
-- end
