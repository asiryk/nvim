---@param background? "dark" | "light
---@param contrast? "hard" | "medium" | "soft"
---@return string
local everforest = function(background, contrast)
  if not background then background = "dark" end
  if not contrast then contrast = "soft" end

  background = "set background=" .. background .. "\n"
  contrast = string.format("let g:everforest_background='%s'\n", contrast)

  return background .. contrast .. [[
    let g:everforest_enable_italic = 1
    let g:everforest_disable_italic_comment = 1

    if has('termguicolors')
      set termguicolors
    endif

    colorscheme everforest
  ]]
end

vim.cmd(everforest())
