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

local function cfg_file_path()
  return vim.fn.stdpath("data") .. "/colorscheme.properties"
end

local function save_data(data)
  local filepath = cfg_file_path()
  local file = io.open(filepath, "w")
  if file then
    local str = ""
    for k, v in pairs(data) do
      local row = string.format("%s=%s", k, v)
      str = str .. "\n" .. row
    end
    file:write(str)
    file:close()
  else
    vim.notify("Failed to open file " .. filepath, vim.log.levels.ERROR)
  end
end

local function load_data()
  local filepath = cfg_file_path()
  local ok, file_content = pcall(vim.fn.readfile, filepath)
  if ok and #file_content > 0 then
    local tbl = {}
    for _, row in pairs(file_content) do
      if row ~= "" then
        local splited = vim.split(row, "=", { trimempty = true })
        tbl[splited[1]] = splited[2]
      end
    end

    return tbl
  else
    return nil
  end
end

local function switch_colorscheme(data)
  if data.colorscheme == "onedark" then
    if data.appearance == "light" then
      onedark("light")
    else
      onedark("darker")
    end
  end
end

local function load_colorscheme()
  local persisted = load_data()
  if persisted == nil then
    onedark("darker")
    local cfg = {
      colorscheme = "onedark",
      appearance = "dark",
    }
    save_data(cfg)
    return
  else
    switch_colorscheme(persisted)
  end
end

local function set_color_scheme()
  vim.ui.select(
    { "onedark" },
    { prompt = "Select colorscheme:" },
    function(colorscheme)
      vim.ui.select(
        { "dark", "light" },
        { prompt = "Select appearance:" },
        function(appearance)
          local cfg = {
            colorscheme = colorscheme,
            appearance = appearance,
          }
          save_data(cfg)
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

load_colorscheme()

-- read the latest value from storage
-- local function set_color_cheme()
-- end
-- colorscheme habamax
-- colorscheme quiet
-- colorscheme slate
