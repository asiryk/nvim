local max_tab_width = 30
local min_tab_width = 15

local function is_real_buffer(bufnr)
  local buftype = vim.bo[bufnr].buftype
  local filetype = vim.bo[bufnr].filetype
  local name = vim.fn.bufname(bufnr)

  if buftype ~= "" then return false end
  if name == "" then return false end

  local ignored_ft = {
    "TelescopePrompt", "harpoon", "minifiles", "mini.files",
    "NvimTree", "neo-tree", "oil", "lazy", "mason",
  }
  for _, ft in ipairs(ignored_ft) do
    if filetype == ft then return false end
  end

  return true
end

local function get_tab_label(tabnr)
  local buflist = vim.fn.tabpagebuflist(tabnr)
  local winnr = vim.fn.tabpagewinnr(tabnr)
  local current_bufnr = buflist[winnr]

  local bufnr = nil
  if is_real_buffer(current_bufnr) then
    bufnr = current_bufnr
  else
    for _, b in ipairs(buflist) do
      if is_real_buffer(b) then
        bufnr = b
        break
      end
    end
  end

  if not bufnr then
    local filetype = vim.bo[current_bufnr].filetype
    local buftype = vim.bo[current_bufnr].buftype
    local name = vim.fn.bufname(current_bufnr)

    if filetype ~= "" then
      return "[" .. filetype .. "]"
    elseif name ~= "" then
      return "[" .. vim.fn.fnamemodify(name, ":t") .. "]"
    elseif buftype ~= "" then
      return "[" .. buftype .. "]"
    else
      return "[No Name]"
    end
  end

  local name = vim.fn.bufname(bufnr)
  local filename = vim.fn.fnamemodify(name, ":t")
  if #filename > max_tab_width - 4 then
    filename = filename:sub(1, max_tab_width - 7) .. "…"
  end

  return filename
end

local function pad_label(label, width)
  local padding = width - vim.fn.strwidth(label)
  local left = math.floor(padding / 2)
  local right = padding - left
  return string.rep(" ", left) .. label .. string.rep(" ", right)
end

_G.Tabline = function()
  local s = ""
  local tabcount = vim.fn.tabpagenr("$")

  local available_width = vim.o.columns
  local tab_width = math.floor(available_width / tabcount)
  tab_width = math.max(min_tab_width, math.min(max_tab_width, tab_width))

  for tabnr = 1, tabcount do
    local is_current = tabnr == vim.fn.tabpagenr()
    local hl = is_current and "%#TabLineSel#" or "%#TabLine#"

    local label = get_tab_label(tabnr)
    local close_btn = " ✕ "
    local content_width = tab_width - #close_btn - 1
    local padded_label = pad_label(label, content_width)

    s = s .. hl
    s = s .. "%" .. tabnr .. "T"
    s = s .. " " .. padded_label
    s = s .. "%" .. tabnr .. "X" .. close_btn .. "%X"
  end

  s = s .. "%#TabLineFill#%T"
  return s
end

vim.o.tabline = "%!v:lua.Tabline()"
vim.o.showtabline = 1
