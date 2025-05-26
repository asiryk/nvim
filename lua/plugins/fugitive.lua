vim.api.nvim_create_user_command(
  "Gitl",
  'Git log --oneline --invert-grep --grep="Auto version update" --grep="Auto update assets"',
  { desc = "Git log excluding generated commits [User]" }
)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "git",
  callback = function(args)
    vim.keymap.set("n", "K", function()
      local hash = vim.fn.expand("<cword>")
      if hash:match("^%x+$") then
        vim.cmd("DiffviewOpen " .. hash .. "^!")
      else
        local msg = string.format('Not a valid commit hash: "%s"', hash)
        vim.notify(msg, vim.log.levels.WARN)
      end
    end, { buffer = args.buf, desc = "Diffview on commit under cursor [User]" })
  end,
})
