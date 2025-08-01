-- Following remaps don't add new features/keybindings, but improve existing ones

vim.opt.mouse = "a" -- Enable mouse support
vim.opt.mousemodel = "popup_setpos" -- Disable mouse context menu
vim.opt.cursorline = false -- Don't highlight current line
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show line number starting at cursor position
vim.opt.signcolumn = "yes" -- Show sign column always, even without lsp or gitsigns
vim.opt.swapfile = false -- Disable swapfiles
vim.opt.expandtab = true -- Use tabs instead of spaces
vim.opt.tabstop = 4 -- Amount of spaces the tab is displayed
vim.opt.shiftwidth = 2 -- Amount of spaces to use for each step of (auto)indent
vim.opt.smartindent = true -- Copy indent from the previous line
vim.opt.exrc = true -- Use .nvim.lua file for per-project configuration
vim.opt.termguicolors = true -- Set 24 bit colors
vim.opt.laststatus = 3 -- Set global status line
vim.opt.ignorecase = true -- Ignore case when searching
vim.opt.smartcase = true -- If capitals are present, do case-sensitive search
vim.opt.pumblend = 15 -- Blend colors with compositor
vim.opt.scrolloff = 10 -- Leave some space while scrolling
vim.opt.list = true -- Allow listchars to display
vim.opt.listchars = { trail = "·", tab = "  ", nbsp = "␣" } -- tab = "» ",
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.splitright = true
vim.opt.splitbelow = true
-- vim.opt.inccommand = "split" -- Preview supstitutions live
vim.o.statusline = "%F %h%m%r%=%-14.(%l,%c%V%) %P" -- modify status line to include full path to the file

-- Set character for vim diff (removed lines)
vim.opt.fillchars:append({ diff = "╱" })

-- Set undo breakpoints: Every time following key ({"<CR>", "."})
-- gets pressed, it stops current change, so the next "undo"
-- will apply up to this key
local undo_breakpoints = { "<CR>", "." }
for _, key in pairs(undo_breakpoints) do
  vim.keymap.set("i", key, key .. "<c-g>u")
end

-- Center cursor
vim.keymap.set("n", "<C-i>", "<C-i>zz")
vim.keymap.set("n", "<C-o>", "<C-o>zz")

vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

vim.keymap.set("n", "<C-f>", "<C-f>zz")
vim.keymap.set("n", "<C-b>", "<C-b>zz")

vim.keymap.set("n", "<S-g>", "<S-g>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

local function is_mark_set(c)
  local res = vim.fn.getpos("'" .. c)
  return res[2] ~= 0
end


vim.keymap.set("n", "'", function() -- center after mark
  local c = vim.fn.getchar()
  c = vim.fn.nr2char(c)
  if not is_mark_set(c) then
    vim.notify("E20: Mark not set", vim.log.levels.ERROR)
    return
  end
  vim.cmd("normal! '" .. c)
  vim.cmd("normal! zz")
end, { noremap = true, silent = true })

vim.keymap.set("n", "`", function() -- center after mark
  local c = vim.fn.getchar()
  c = vim.fn.nr2char(c)
  if not is_mark_set(c) then
    vim.notify("E20: Mark not set", vim.log.levels.ERROR)
    return
  end
  vim.cmd("normal! `" .. c)
  vim.cmd("normal! zz")
end, { noremap = true, silent = true })

-- Add position to jumplist if moving more than 5 lines up or down
vim.keymap.set("n", "j", [[v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'j']], { expr = true })
vim.keymap.set("n", "k", [[v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'k']], { expr = true })

local defaults_augroup = vim.api.nvim_create_augroup("defaults", {})

vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Don't auto comment new lines",
  group = defaults_augroup,
  pattern = "*",
  command = "set fo-=c fo-=r fo-=o",
})

vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
  desc = "Autosave on leaving insert mode or text change",
  group = defaults_augroup,
  pattern = "*",
  callback = function()
    local modifiable = vim.bo.modifiable
    local no_buftype = vim.bo.buftype == ""

    local buf = vim.api.nvim_get_current_buf()
    local file = vim.api.nvim_buf_get_name(buf)
    local exists = vim.loop.fs_stat(file) ~= nil
    local attached = file ~= ""

    if exists and modifiable and no_buftype and attached then
      vim.cmd("silent update")
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Remove trailing whitespace on pressing :w",
  group = defaults_augroup,
  pattern = "*",
  callback = function()
    local filetype = vim.bo.filetype
    local filetype_allowed = filetype ~= "markdown"

    if vim.bo.modifiable and filetype_allowed then
      local cursor_pos = vim.api.nvim_win_get_cursor(0)
      vim.cmd("%s/\\s\\+$//e")
      vim.api.nvim_win_set_cursor(0, cursor_pos)
    end
  end,
})

-- Disable some default plugins
local default_plugins = {
  -- "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "matchit",
  "tar",
  "tarPlugin",
  "rrhelper",
  "spellfile_plugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
  "python3_provider",
  "python_provider",
  "node_provider",
  "ruby_provider",
  "perl_provider",
  "tutor",
  "rplugin",
  "syntax",
  "synmenu",
  "optwin",
  "compiler",
  "bugreport",
  -- "ftplugin",
}

for _, plugin in pairs(default_plugins) do
  vim.g["loaded_" .. plugin] = 1
end

-------------------- Cross-plugin configuration --------------------

do
  ---Annotate this function in order to see completions for
  ---the actual config table.
  ---@generic T : table
  ---@param tbl T The input table to observe.
  ---@param callback function The function
  ---@return T tbl The same table, now observed.
  local function t(tbl, callback)
    return G.utils.observed_table(tbl, callback)
  end

  local r = function(key, value)
    vim.api.nvim_exec_autocmds("User", {
      pattern = "ReloadConfig", data = { key = key, value = value }
    })
  end

  G.config = t({
    -- Theoretically it should be replaced by this
    -- vim.o.winborder = "rounded" -- Good option
    -- however it messes up Telescope
    window = t({
      --- @type "none" | "single" | "double" | "rounded" | "solid" | "shadow"
      border = "rounded"
    }, r),
  }, r)
end
