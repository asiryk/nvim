---@diagnostic disable: unused-function, unused-local
local ok_everforest = pcall(require, "everforest")
local ok_onedark = pcall(require, "onedark")

if not ok_everforest and not ok_onedark then return end

local function default()
  -- Transparent background
  vim.cmd([[
    highlight Normal guibg=NONE ctermbg=NONE
    highlight EndOfBuffer guibg=NONE ctermbg=NONE
    highlight NonText ctermbg=NONE
    highlight WinSeparator guibg=None  " Remove borders for window separators
    highlight SignColumn guibg=None " Remove background from signs column
    highlight NvimTreeWinSeparator guibg=None
    highlight NvimTreeEndOfBuffer guibg=None
    highlight NvimTreeNormal guibg=None
  ]])
end

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
  default()
end

---@param style? "dark" | "darker" | "cool" | "deep" | "warm" | "warmer" | "light"
local function onedark(style)
  if not style then style = "darker" end

  local theme = require("onedark")
  theme.setup({ style = style })
  theme.load()

  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e222a" })

  default()
end

onedark()
