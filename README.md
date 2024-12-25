# nvim configuration

![preview](https://user-images.githubusercontent.com/61456651/202856540-ddb5478d-4de7-483c-b859-1b6ddc771a70.png)

## TODO

- [ ] Add syntax correction and underline for comments or identifier names (either builtin or plugin)

## Highlight Group TODO

- [ ] Change GitSigns highlight groups to match vim diff (existing groups).
- [ ] Change indent blankline highlight equal to visual mode highlight.
- [ ] Investigate the reason why nvim cmp highlights is corrupted after switching color schemes

## Requirements

- Neovim
- A C compiler in your path and libstdc++ installed (gcc, g++) for TreeSitter

## Removing

To completely remove any footprints of the config:

```zsh
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim
```

## Git Workflow requirements

- [X] Hunk features:
    - Stage/Unstage current hunk
    - Jump to current/prev hunk
    - Diff hunk under the cursor
  Gitsigns is sorted this out.

- [X] Able to see diff for staged/unstaged. Also for comparing branches
  like master to current branch: to see what I'm going to merge to master.
  The Diffview plugin allows to do that. DiffviewOpen; DiffviewOpen master..HEAD

- [X] Search through the log history.
  Telescope git_commits

- [X] Commit & push within the neovim
  Fugitive: Git commit; Git push

- [ ] Being able to see the history for a line. It is a common that current
  line gets overridden by prettier, or other stuff. It's nice to see more
  recent changes for this line.

  Currently only regular git diff (no Diffview)

  ```lua
  vim.cmd('Git log -L' .. vim.fn.line('.') .. ',' .. vim.fn.line('.') .. ':' .. vim.fn.expand('%'))

  ```
