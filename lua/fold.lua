vim.o.foldcolumn = "0"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldtext = ""

local fold_ns = vim.api.nvim_create_namespace("fold_count")
local cur_winid = 0
vim.api.nvim_set_decoration_provider(fold_ns, {
  on_win = function(_, winid, bufnr)
    if not vim.api.nvim_buf_is_valid(bufnr) then return false end
    cur_winid = winid
    return true
  end,
  on_line = function(_, _, bufnr, row)
    local lnum = row + 1
    local count = vim.api.nvim_win_call(cur_winid, function()
      if vim.fn.foldclosed(lnum) ~= lnum then return nil end
      return vim.fn.foldclosedend(lnum) - lnum
    end)
    if not count then return end
    vim.api.nvim_buf_set_extmark(bufnr, fold_ns, row, 0, {
      virt_text = { { (" [+%d lines]"):format(count), "Comment" } },
      virt_text_pos = "right_align",
      hl_mode = "combine",
      ephemeral = true,
    })
  end,
})
