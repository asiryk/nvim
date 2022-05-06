local function autocmd(events, handler)
  assert(type(events) == "string" or type(events) == "table")
  assert(type(handler) == "function" or (type(handler) == "table" and #handler == 2))

  local au = vim.api.nvim_create_autocmd
  if type(events == "string") then events = { events } end

  if type(handler) == "function" then
    au(events, { callback = handler })
  elseif type(handler) == "table" then
    au(events, { callback = function()
      vim.opt[handler[1]] = handler[2]
    end })
  end
end

return {
  autocmd = autocmd
}
