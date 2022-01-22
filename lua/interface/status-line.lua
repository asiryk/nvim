require('lualine').setup {
  options = {
    icons_enabled = true,
  },
  sections = {
    lualine_x = { 'encoding', 'fileformat', 'filetype', 'progress' },
    lualine_y = { 'os.date("%H:%M")' },
  },
}