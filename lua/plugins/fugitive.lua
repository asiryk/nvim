local F = {}

vim.api.nvim_create_user_command(
  "Gitl",
  'Git log --oneline --invert-grep --grep="Auto version update" --grep="Auto update assets"',
  { desc = "Git log excluding generated commits [User]" }
)

function F.open_commit_diff_under_cursor()
  local hash = vim.fn.expand("<cword>")
  if hash:match("^%x+$") then
    vim.cmd("DiffviewOpen " .. hash .. "^!")
  else
    local msg = string.format('Not a valid commit hash: "%s"', hash)
    vim.notify(msg, vim.log.levels.WARN)
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "git",
  callback = function(args)
    local buf = args.buf
    vim.keymap.set(
      "n",
      "K",
      function() F.open_commit_diff_under_cursor() end,
      { buffer = buf, desc = "Diffview on commit under cursor [User]" }
    )
    vim.keymap.set(
      "n",
      "<CR>",
      function() F.open_commit_diff_under_cursor() end,
      { buffer = buf, desc = "Diffview on commit under cursor [User]" }
    )
    vim.keymap.set(
      "",
      "<2-LeftMouse>",
      function() F.open_commit_diff_under_cursor() end,
      { buffer = buf, desc = "Diffview on commit under cursor [User]" }
    )
  end,
})

return F
