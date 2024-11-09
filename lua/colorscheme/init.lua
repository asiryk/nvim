---@diagnostic disable: unused-function, unused-local
local ok_everforest = pcall(require, "everforest")
local ok_onedark = pcall(require, "onedark")

if not ok_everforest and not ok_onedark then return end

local local_storage = require("local_storage")

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
  local c = require("onedark.colors")

  for _, func in ipairs(G.plugin_hl) do
    func(c)
  end
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
  theme.setup({ style = style, transparent = false })
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

---@param data ColorschemeStorage
local function switch_colorscheme(data)
  if data.name == "onedark" then
    if data.variant == "light" then
      onedark("light")
    else
      onedark("darker")
    end
  end
end

local function load_colorscheme()
  local data = local_storage.get_data()
  if (data == nil or data.colorscheme == nil) then
    onedark("darker")
    --- @type ColorschemeStorage
    local cfg = {
      name = "onedark",
      variant = "dark",
    }
    local_storage.persist_data({
      colorscheme = cfg
    })
  else
    switch_colorscheme(data.colorscheme)
  end
end

local function set_color_scheme()
  vim.ui.select(
    { "onedark" },
    { prompt = "Select colorscheme:" },
    function(colorscheme)
      if (colorscheme == nil) then return end
      vim.ui.select(
        { "dark", "light" },
        { prompt = "Select appearance:" },
        function(appearance)
          if (appearance == nil) then return end
          --- @type ColorschemeStorage
          local cfg = {
            name = colorscheme,
            variant = appearance,
          }
          local_storage.persist_data({
            colorscheme = cfg
          })
          vim.opt.background = appearance
          switch_colorscheme(cfg)
        end
      )
    end
  )
end

vim.api.nvim_create_user_command(
  "SetColorscheme",
  set_color_scheme,
  {}
)

vim.keymap.set("n", "<leader>ct", set_color_scheme, { desc = "Configure theme [User]" })

load_colorscheme()

-- read the latest value from storage
-- local function set_color_cheme()
-- end
-- colorscheme habamax
-- colorscheme quiet
-- colorscheme slate
