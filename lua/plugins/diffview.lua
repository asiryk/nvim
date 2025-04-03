require("diffview").setup({
  file_panel = {
    listing_style = "list",
  },
})

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

vim.keymap.set(
  "n",
  "<leader>gd",
  F.toggle_diffview,
  { desc = "Toggle Git Diff [Diffview]" }
)

vim.api.nvim_create_user_command("DiffPreset", function()
  vim.ui.select({
    "Current file: filter by author",
  }, { prompt = "Select preset:" }, function(selected)
    if selected == "Current file: filter by author" then
      F.current_file_history_with_author()
    end
  end)
end, {
  desc = "Select one of multiple preset diff configurations [User]",
})
