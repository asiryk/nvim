-- Prompt an action (vs-code like)

local F = {}

local actions = {
  ["[Git] blame open"] = "Gitsigns blame",
  ["[Git] blame close"] = PopUpMenu.close_git_blame,
  ["[Git] blame line"] = "Gitsigns blame_line",
  ["[Git] diff open"] = "DiffviewOpen",
  ["[Git] diff close"] = "DiffviewClose",
  ["[Git] preview hunk"] = "Gitsigns preview_hunk",
}

function F.trigger_prompt()
  local q = vim.tbl_keys(actions)
  vim.ui.select(q, { prompt = "Run action" }, function(key)
    local selected = actions[key]
    if type(selected) == "function" then
      selected()
    elseif type(selected) == "string" then
      vim.cmd(selected)
    end
  end)
end

vim.keymap.set(
  "n",
  "<leader>a",
  F.trigger_prompt,
  { desc = "Execute an action [User]" }
)
