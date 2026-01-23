local F = {}
local L = {}

vim.keymap.set(
  "n",
  "<leader>gC",
  "Git commit --amend --no-edit",
  { desc = "Commit with amend [Fugitive]" }
)

vim.keymap.set("n", "<leader>gP", function()
  local url = L.get_pr_url()
  if url then
    -- make that multiline, so it opens :mes history
    vim.print("\n" .. url)
  end
end, { desc = "Print PR URL (GitHub, GitLab) [Fugitive]" })

function F.open_commit_diff_under_cursor()
  pcall(function()
    local line = vim.api.nvim_get_current_line()
    local hash = line:match("([0-9a-f]+)")
    if hash then vim.cmd("DiffviewOpen " .. hash .. "^!") end
  end)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "git", "git-graph" },
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

    vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "git-graph",
  callback = function(args)
    local buf = args.buf

    vim.keymap.set("n", "<CR>", function()
      local line = vim.api.nvim_get_current_line()
      -- Extract commit hash (7 hex characters)
      local hash = line:match("([0-9a-f]+)")
      if hash then vim.cmd("Gtabedit " .. hash) end
    end, { buffer = buf, silent = true })
  end,
})

vim.api.nvim_create_user_command("Gitl", function()
  local output = L.run_git_log()
  if output == nil then return end
  L.create_git_graph_buf(output)
end, { desc = "Git log graph excluding generated commits [User]" })

vim.api.nvim_create_user_command("Gitlo", function()
  local output = L.run_git_log_full()
  if output == nil then return end
  L.create_git_graph_buf(output)
end, { desc = "Git log graph [User]" })

--- Returns a URL to create a new PR/MR for the current branch.
--- Supports GitHub and GitLab remotes (both SSH and HTTPS formats).
function L.get_pr_url()
  local remote = vim.fn.system("git remote get-url origin"):gsub("%s+$", "")
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to get remote origin", vim.log.levels.ERROR)
    return nil
  end

  local branch = vim.fn.system("git branch --show-current"):gsub("%s+$", "")
  if vim.v.shell_error ~= 0 or branch == "" then
    vim.notify("Failed to get current branch", vim.log.levels.ERROR)
    return nil
  end

  -- Normalize SSH URLs to HTTPS format
  -- git@github.com:user/repo.git -> github.com/user/repo
  -- git@gitlab.com:group/subgroup/repo.git -> gitlab.com/group/subgroup/repo
  local host, path
  if remote:match("^git@") then
    host, path = remote:match("^git@([^:]+):(.+)$")
  else
    host, path = remote:match("^https?://([^/]+)/(.+)$")
  end

  if not host or not path then
    vim.notify("Could not parse remote URL: " .. remote, vim.log.levels.ERROR)
    return nil
  end

  path = path:gsub("%.git$", "")

  local url
  if host:match("github") then
    url = ("https://%s/%s/pull/new/%s"):format(host, path, branch)
  elseif host:match("gitlab") then
    local encoded_branch = vim.uri_encode(branch)
    url = ("https://%s/%s/-/merge_requests/new?merge_request%%5Bsource_branch%%5D=%s"):format(
      host,
      path,
      encoded_branch
    )
  else
    vim.notify("Unknown git host: " .. host, vim.log.levels.WARN)
    return nil
  end

  return url
end

function L.run_git_log()
  local git_cmd = "git log --graph --pretty=format:'%h%d %s <%ad | %an>' --abbrev-commit --date=local"
    .. " --invert-grep --grep='Auto version update' --grep='Auto update assets' --grep='Merge branch' --grep='Merge remote-tracking branch'"

  local output = vim.fn.systemlist(git_cmd)

  -- Check for errors
  if vim.v.shell_error ~= 0 then
    vim.notify("Git command failed", vim.log.levels.ERROR)
    return nil
  end

  return output
end

function L.run_git_log_full()
  local git_cmd =
    "Git log --graph --pretty=format:'%h%d %s <%ad | %an>' --abbrev-commit --date=local"

  local output = vim.fn.systemlist(git_cmd)

  -- Check for errors
  if vim.v.shell_error ~= 0 then
    vim.notify("Git command failed", vim.log.levels.ERROR)
    return nil
  end

  return output
end

function L.create_git_graph_buf(content)
  -- Create new buffer
  local bufnr = vim.api.nvim_create_buf(false, true)

  -- Set buffer options
  vim.bo[bufnr].buftype = "nofile"
  vim.bo[bufnr].bufhidden = "wipe"
  vim.bo[bufnr].swapfile = false
  vim.bo[bufnr].filetype = "git-graph"

  -- Set buffer content
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, content)
  vim.bo[bufnr].modifiable = false

  -- Open horizontal split and set buffer
  vim.cmd.split()
  vim.api.nvim_set_current_buf(bufnr)

  -- Set buffer name
  vim.api.nvim_buf_set_name(bufnr, "git-graph://" .. vim.fn.getcwd())

  vim.opt_local.listchars = { trail = " ", tab = "  ", nbsp = "␣" }
end

return F
