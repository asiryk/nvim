---@diagnostic disable: unused-function, unused-local
local ok_everforest = pcall(require, "everforest")
local ok_onedark = pcall(require, "onedark")

if not ok_everforest and not ok_onedark then return end

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local function transparent()
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

local function default()
  -- highlight current line number
  vim.opt.cursorline = true
  vim.cmd("hi clear CursorLine")
end

---@param background? "dark" | "light
---@param contrast? "hard" | "medium" | "soft"
local function everforest(background, contrast)
  if not background then background = "dark" end
  if not contrast then contrast = "soft" end

  vim.cmd("set background=" .. background)
  vim.cmd(string.format("let g:everforest_background='%s'", contrast))
  vim.cmd([[
    let g:everforest_enable_italic = 1
    let g:everforest_disable_italic_comment = 1

    colorscheme everforest
  ]])
end

---@param style? "dark" | "darker" | "cool" | "deep" | "warm" | "warmer" | "light"
local function onedark(style)
  if not style then style = "darker" end

  local theme = require("onedark")
  theme.setup({ style = style, transparent = true })
  theme.load()
end

local group = augroup("colorscheme", {})

autocmd("ColorScheme", {
  pattern = "*",
  group = group,
  callback = default,
})

-- Highilight yanked text for a short time
autocmd("TextYankPost", {
  pattern = "*",
  group = group,
  callback = function()
    local mode = vim.api.nvim_get_mode()["mode"]

    -- Only highlight in normal mode. not in visual
    if mode == "no" then
      vim.highlight.on_yank({
        higroup = "Visual",
        timeout = 75,
      })
    end
  end,
})

onedark()
