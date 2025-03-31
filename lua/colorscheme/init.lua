-- colorscheme habamax
-- colorscheme quiet
---@diagnostic disable: unused-function, unused-local
local ok_onedark = pcall(require, "onedark")

if not ok_onedark then return end

local local_storage = require("local_storage")

local M = {}

---@param style? "dark" | "darker" | "cool" | "deep" | "warm" | "warmer" | "light"
local function onedark(style)
  if not style then style = "darker" end

  local theme = require("onedark")
  theme.setup({
    style = style,
    transparent = false,
  })
  theme.load()
end

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
  if data == nil or data.colorscheme == nil then
    onedark("darker")
    --- @type ColorschemeStorage
    local cfg = {
      name = "onedark",
      variant = "dark",
    }
    local_storage.persist_data({
      colorscheme = cfg,
    })
  else
    switch_colorscheme(data.colorscheme)
  end
  M.on_colorscheme_changed({ match = vim.g.colors_name })
end

function M.set_color_scheme(colorscheme, appearance)
  --- @type ColorschemeStorage
  local cfg = {
    name = colorscheme,
    variant = appearance,
  }
  local_storage.persist_data({
    colorscheme = cfg,
  })
  vim.opt.background = appearance
  switch_colorscheme(cfg)
end

function M.prompt_color_scheme()
  vim.ui.select({ "onedark" }, { prompt = "Select colorscheme:" }, function(colorscheme)
    if colorscheme == nil then return end
    vim.ui.select(
      { "dark", "light" },
      { prompt = "Select appearance:" },
      function(appearance)
        if appearance == nil then return end
        M.set_color_scheme(colorscheme, appearance)
      end
    )
  end)
end

local function hl_overrides()
  -- The structure of a table: "<theme-name>"."<background>".overrides()
  return {
    ["onedark"] = {
      ["base"] = function()
        vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
        vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
        do -- Set neat line for TreesitterContext
          local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
          local c = require("onedark.colors")
          vim.api.nvim_set_hl(0, "TreesitterContext", { bg = normal_bg })
          vim.api.nvim_set_hl(0, "TreesitterContextBottom", {
            bg = normal_bg,
            sp = c.fg,
            underline = true,
          })
        end
      end,
      ["dark"] = function()
      end,
      ["light"] = function()
      end,
    },
  }
end

function M.on_colorscheme_changed(a)
  vim.schedule(function()
    do
      -- Highlight current line number
      vim.opt.cursorline = true
      vim.cmd("hi clear CursorLine")
      local c = require("onedark.colors")

      -- Apply plugin highlights
      for _, func in ipairs(G.plugin_hl) do
        func(c)
      end
    end

    do -- Apply custom overrides
      local name = a.match
      local override = hl_overrides()[name]
      if type(override) == "table" then
        local bg = vim.o.background
        local fn = override[bg]
        local fn_base = override["base"]
        if type(fn_base) == "function" then fn_base() end
        if type(fn) == "function" then fn() end
      end
    end

  end)
end

--#region autocmd
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local group = augroup("colorscheme", {})

autocmd("ColorScheme", {
  pattern = "*",
  group = group,
  callback = M.on_colorscheme_changed,
})

-- Read more about this autocmd
-- https://github.com/neovim/neovim/pull/31350
-- https://contour-terminal.org/vt-extensions/color-palette-update-notifications/#when-to-send-out-the-dsr
autocmd("OptionSet", {
  pattern = "background",
  group = group,
  callback = function(e)
    local bg = vim.o.background
    if bg == "dark" then
      M.set_color_scheme("onedark", "dark")
    else
      M.set_color_scheme("onedark", "light")
    end
  end,
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
--#endregion

-- Call stuff.
vim.api.nvim_create_user_command("SetColorscheme", M.prompt_color_scheme, {})
vim.keymap.set("n", "<leader>ct", M.prompt_color_scheme, { desc = "Configure theme [User]" })

load_colorscheme()
