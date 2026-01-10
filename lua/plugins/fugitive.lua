local F = {}

vim.api.nvim_create_user_command(
  "Gitl",
  "Git log --graph --pretty=format:'%h%d %s <%ad | %an>' --abbrev-commit --date=local"
    .. " --invert-grep --grep='Auto version update' --grep='Auto update assets' --grep='Merge branch' --grep='Merge remote-tracking branch'"
    .. " <args>",
  { desc = "Git log graph excluding generated commits [User]" }
)
vim.api.nvim_create_user_command(
  "Gitlo",
  "Git log --graph --pretty=format:'%h%d %s <%ad | %an>' --abbrev-commit --date=local"
    .. " <args>",
  { desc = "Git log graph [User]" }
)

function F.open_commit_diff_under_cursor()
  pcall(function()
    local hash = vim.fn.expand("<cword>")
    if hash:match("^%x+$") then
      vim.cmd("DiffviewOpen " .. hash .. "^!")
    else
      local msg = string.format('Not a valid commit hash: "%s"', hash)
      vim.notify(msg, vim.log.levels.WARN)
    end
  end)
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

vim.keymap.set(
  "n",
  "<leader>gC",
  "Git commit --amend --no-edit",
  { desc = "Commit with amend [Fugitive]" }
)

local grp = vim.api.nvim_create_augroup("GitLgSyntax", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = grp,
  pattern = "git",
  callback = function(ev)
    vim.api.nvim_buf_call(
      ev.buf,
      function()
        vim.cmd([[
        syntax clear

        " 1. Graph (Start of line)
        syn match gitLgGraph /^[|/\\_* ]\+/ nextgroup=gitLgHash skipwhite

        " 2. Commit Hash
        syn match gitLgHash /[a-f0-9]\{4,40\}/ contained nextgroup=gitLgDecoration,gitLgMessage skipwhite

        " 3. Decorations (The parens)
        " We define the region, containing our 3 groups
        syn region gitLgDecoration start="(" end=")" contained contains=gitLgHead,gitLgTag,gitLgBranch nextgroup=gitLgMessage skipwhite

        " --- Inner Decoration Matches ---

        " HEAD -> ...
        " Matches the whole arrow sequence
        syn match gitLgHead /HEAD -> [a-zA-Z0-9_\.\-/]\+/ contained

        " tag: ...
        " Matches the tag prefix and the version
        syn match gitLgTag /tag: [a-zA-Z0-9_\.\-/]\+/ contained

        " Branch (Catch-all)
        " \<\(HEAD\|tag\)\@! : Negative Lookahead.
        " If the word starts with "HEAD" or "tag", this match FAILS immediately.
        " This forces Vim to use gitLgHead or gitLgTag instead.
        syn match gitLgBranch /\<\(HEAD\|tag\)\@![a-zA-Z0-9_\.\-/]\+\>/ contained

        " 4. Commit Message
        " Safety: Don't match if we see an opening parenthesis
        syn match gitLgMessage /\(\s*(\)\@!.\{-}\ze\s*<[a-zA-Z]/ contained

        " 5. Meta Block <Date | Author>
        syn match gitLgMeta /<[^>]*>$/ contains=gitLgAuthor

        " 6. Author Name
        syn match gitLgAuthor /| \zs[^>]\+/ contained

        " --- Linking ---
        hi def link gitLgGraph    Comment
        hi def link gitLgHash     Number
        hi def link gitLgDecoration Comment

        hi def link gitLgHead     Keyword
        hi def link gitLgTag      Constant
        hi def link gitLgBranch   Type

        hi def link gitLgMessage  Normal
        hi def link gitLgMeta     Comment
        hi def link gitLgAuthor   Identifier
      ]])
      end
    )

    -- override local listchars not to show trailing spaces
    vim.opt_local.listchars = { trail = " ", tab = "  ", nbsp = "␣" }
  end,
})

return F
