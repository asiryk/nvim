local BUF_NAME = "claude code"

local function find_buf()
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(b) and vim.b[b].claude_code then
      return b
    end
  end
end

local function is_alive(buf)
  local chan = vim.b[buf].terminal_job_id
  if not chan then return false end
  local ok = pcall(vim.fn.jobpid, chan)
  return ok
end

local function tab_of(buf)
  for tab = 1, vim.fn.tabpagenr("$") do
    for _, b in ipairs(vim.fn.tabpagebuflist(tab)) do
      if b == buf then return tab end
    end
  end
end

local function focus(buf)
  local tab = tab_of(buf)
  if tab then
    vim.cmd("tabnext " .. tab)
  else
    vim.cmd("tabnew")
    vim.cmd("tabmove 0")
    vim.api.nvim_set_current_buf(buf)
  end
  vim.cmd("startinsert")
end

local function spawn(cmd)
  vim.cmd("tabnew")
  vim.cmd("tabmove 0")
  vim.fn.jobstart(cmd, { term = true })
  local buf = vim.api.nvim_get_current_buf()
  vim.b[buf].claude_code = true
  vim.bo[buf].bufhidden = "hide"
  pcall(vim.api.nvim_buf_set_name, buf, BUF_NAME)
  for _, key in ipairs({ "<ScrollWheelLeft>", "<ScrollWheelRight>", "<S-ScrollWheelLeft>", "<S-ScrollWheelRight>" }) do
    vim.keymap.set({ "n", "t" }, key, "<nop>", { buffer = buf })
  end
  vim.cmd("startinsert")
end

local function open(resume)
  local buf = find_buf()
  if buf and is_alive(buf) then
    if resume then
      vim.notify("Cannot resume: existing Claude Code session open", vim.log.levels.WARN)
    end
    focus(buf)
    return
  end
  if buf then vim.cmd("bwipeout! " .. buf) end
  spawn(resume and { "claude", "--resume" } or { "claude" })
end

vim.api.nvim_create_user_command("ClaudeCode", function() open(false) end,
  { desc = "Open Claude Code terminal [User]" })
vim.api.nvim_create_user_command("ClaudeCodeResume", function() open(true) end,
  { desc = "Open Claude Code terminal with --resume [User]" })
