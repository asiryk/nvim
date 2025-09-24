_G.Statusline_git_branch = function()
  -- Prefer Gitsigns (fast, buffer-scoped), fall back to Fugitive
  local head
  local gs = vim.b.gitsigns_status_dict
  if gs and gs.head and #gs.head > 0 then
    head = gs.head
  elseif vim.b.gitsigns_head and #vim.b.gitsigns_head > 0 then
    head = vim.b.gitsigns_head
  elseif vim.fn.exists("*FugitiveHead") == 1 then
    local h = vim.fn.FugitiveHead()
    if h and #h > 0 then head = h end
  end

  local icon_branch = ""

  if head and head ~= "" then
    return icon_branch .. " " .. head
  else
    return icon_branch  .. " not git repo"
  end
end

_G.Statusline_flags = function()
  -- Use Neovim's own expander so texts match %h%m%r exactly
  local ok, res = pcall(vim.api.nvim_eval_statusline, "%h%m%r", { winid = 0 })
  local flags = ok and (res.str or res) or ""
  if flags ~= nil and flags ~= "" then
    return " " .. flags .. "  "
  else
    return "  "
  end
end

local function redraw_status()
  -- schedule to avoid "textlock" errors during events
  vim.schedule(function() vim.cmd("redrawstatus") end)
end

vim.o.statusline = table.concat({
  "%F%{v:lua.Statusline_flags()}%{v:lua.Statusline_git_branch()}  %=",
  "%-14.(%l,%c%V%) %P"
})

-- Gitsigns fires this whenever its status_dict (incl. branch) changes
vim.api.nvim_create_autocmd("User", {
  pattern = "GitsignsStatusUpdated",
  callback = redraw_status,
})

-- Fugitive fires this on repo state changes (checkout, etc.)
-- vim.api.nvim_create_autocmd("User", {
--   pattern = "FugitiveChanged",
--   callback = redraw_status,
-- })

-- Also refresh when you come back to Neovim or change cwd/buffer
vim.api.nvim_create_autocmd({ "FocusGained", "DirChanged", "BufEnter" }, {
  callback = redraw_status,
})

-- (Optional) Give Gitsigns a nudge after focus returns, then redraw
-- vim.api.nvim_create_autocmd("FocusGained", {
--   callback = function()
--     pcall(function() require("gitsigns").refresh() end)
--     redraw_status()
--   end,
-- })

-- for future
-- vim.print(vim.lsp.buf.list_workspace_folders())
