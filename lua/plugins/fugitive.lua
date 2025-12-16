local F = {}

vim.api.nvim_create_user_command(
  "Gitl",
  "Git log --graph --pretty=format:'%h - (%ad)%d %s <%an>' --abbrev-commit --date=local"
    .. " --invert-grep --grep='Auto version update' --grep='Auto update assets'"
    .. " <args>",
  -- 'Git log --oneline --invert-grep --grep="Auto version update" --grep="Auto update assets"',
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
      "",
      "<2-LeftMouse>",
      function() F.open_commit_diff_under_cursor() end,
      { buffer = buf, desc = "Diffview on commit under cursor [User]" }
    )
  end,
})

vim.keymap.set("n", "<leader>gC", "Git commit --amend --no-edit", { desc = "Commit with amend [Fugitive]" })

local grp = vim.api.nvim_create_augroup("GitLgSyntax", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = grp,
  pattern = "git",
  callback = function(ev)
    -- run :syntax commands buffer-locally
    vim.api.nvim_buf_call(ev.buf, function()
      vim.cmd([[
        syn match gitLgLine     /^[_\*|\/\\ ]\+\(\<\x\{4,40\}\>.*\)\?$/
        syn match gitLgHead     /^[_\*|\/\\ ]\+\(\<\x\{4,40\}\> - ([^)]\+)\( ([^)]\+)\)\? \)\?/ contained containedin=gitLgLine
        syn match gitLgDate     /(\u\l\l \u\l\l \d\=\d \d\d:\d\d:\d\d \d\d\d\d)/ contained containedin=gitLgHead nextgroup=gitLgRefs skipwhite
        syn match gitLgRefs     /([^)]*)/ contained containedin=gitLgHead
        syn match gitLgGraph    /^[_\*|\/\\ ]\+/ contained containedin=gitLgHead,gitLgCommit nextgroup=gitHashAbbrev skipwhite
        syn match gitLgCommit   /^[^-]\+- / contained containedin=gitLgHead nextgroup=gitLgDate skipwhite
        syn match gitLgIdentity /<[^>]*>$/ contained containedin=gitLgLine
        ]])
    end)

    -- highlight links (buffer 0 = current)
    vim.api.nvim_set_hl(0, "gitLgGraph",    { link = "Comment" })
    vim.api.nvim_set_hl(0, "gitLgDate",     { link = "gitDate" })
    vim.api.nvim_set_hl(0, "gitLgRefs",     { link = "gitReference" })
    vim.api.nvim_set_hl(0, "gitLgIdentity", { link = "gitIdentity" })

    -- override local listchars not to show trailing spaces
    vim.opt_local.listchars = { trail = " ", tab = "  ", nbsp = "␣" }
  end,
})

return F
