require("diffview").setup({
  file_panel = {
    listing_style = "list",
  },
})

-- NOTE: Show diff for a single commit ":DiffviewOpen <commit-hash>^!"

local F = {}

--- check if diffview is open in current tab
function F.is_diffview_open()
  local view = require("diffview.lib").get_current_view()
  return view ~= nil
end

function F.toggle_diffview()
  local is_open = F.is_diffview_open()
  if is_open then
    vim.cmd("DiffviewClose")
    vim.schedule(function()
      pcall(function() require("gitsigns").refresh() end)
    end)
  else
    vim.cmd("DiffviewOpen")
  end
end

function F.current_file_history_with_author()
  local M = {}
  M.co = coroutine.create(function(authors)
    vim.ui.select(authors, {
      prompt = "Select Git Author:",
    }, function(selected) coroutine.resume(M.co, selected) end)
    local selected = coroutine.yield()

    vim.cmd(
      "DiffviewFileHistory % --no-merges" .. string.format(" --author='%s'", selected)
    )
  end)

  vim.system(
    { "sh", "-c", "git log --format='%aN' | sort -u" },
    { text = true },
    function(result)
      if result.code ~= 0 then error("Failed to get authors") end

      local authors = {}
      for author in result.stdout:gmatch("[^\r\n]+") do
        table.insert(authors, author)
      end

      coroutine.resume(M.co, authors)
    end
  )
end

function F.current_file_history_selected_lines(opts)
  local file = vim.fn.expand("%")
  local start_line = opts.line1
  local end_line = opts.line2

  local cmd = string.format("DiffviewFileHistory -L%d,%d:%s", start_line, end_line, file)
  vim.cmd(cmd)
end

vim.keymap.set(
  "n",
  "<leader>gd",
  F.toggle_diffview,
  { desc = "Toggle Git Diff [Diffview]" }
)

vim.api.nvim_create_user_command("DiffPreset", function(opts)
  vim.ui.select({
    "Current file: filter by author",
    "Current file: selected lines",
  }, { prompt = "Select preset:" }, function(selected)
    if selected == "Current file: filter by author" then
      F.current_file_history_with_author()
    elseif selected == "Current file: selected lines" then
      F.current_file_history_selected_lines(opts)
    end
  end)
end, {
  range = true,
  desc = "Select one of multiple preset diff configurations [User]",
})

vim.api.nvim_create_user_command(
  "DiffLines",
  function(opts) F.current_file_history_selected_lines(opts) end,
  {
    range = true,
    desc = "Show file history for selected lines [User]",
  }
)

return F
