vim.o.foldcolumn = "0"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldtext = ""

local fold_ns = vim.api.nvim_create_namespace("fold_count")
vim.api.nvim_set_decoration_provider(fold_ns, {
  on_win = function(_, _, bufnr) return vim.api.nvim_buf_is_valid(bufnr) end,
  on_line = function(_, _, bufnr, row)
    local lnum = row + 1
    if vim.fn.foldclosed(lnum) ~= lnum then return end
    local count = vim.fn.foldclosedend(lnum) - lnum
    vim.api.nvim_buf_set_extmark(bufnr, fold_ns, row, 0, {
      virt_text = { { (" [+%d lines]"):format(count), "Comment" } },
      virt_text_pos = "right_align",
      hl_mode = "combine",
      ephemeral = true,
    })
  end,
})
