---@param background? "dark" | "light
---@param contrast? "hard" | "medium" | "soft"
---@return string
local function everforest(background, contrast)
  if not background then background = "dark" end
  if not contrast then contrast = "soft" end

  background = "set background=" .. background .. "\n"
  contrast = string.format("let g:everforest_background='%s'\n", contrast)

  local config = background
    .. contrast
    .. [[
    let g:everforest_enable_italic = 1
    let g:everforest_disable_italic_comment = 1

    colorscheme everforest
  ]]

  vim.cmd(config)
end

---@param style? "dark" | "darker" | "cool" | "deep" | "warm" | "warmer" | "light"
local function onedark(style)
  if not style then style = "darker" end

  local od = require("onedark")
  od.setup({ style = style })
  od.load()
end

onedark()
