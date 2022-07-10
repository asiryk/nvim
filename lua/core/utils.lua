local utils = {}

function utils.autocmd_default_colorscheme(config)
  local pattern = "blue,darkblue,default,delek,desert,"
    .. "elford,evening,industry,koehler,morhing,murphy,"
    .. "pablo,peachpuff,ron,shine,slate,torte,zellner"

  config["pattern"] = pattern

  vim.api.nvim_create_autocmd("ColorScheme", config)
end

return utils
