require("mini.files").setup()
local files = require("mini.files")

local function open_current()
  files.open(vim.api.nvim_buf_get_name(0))
end

vim.keymap.set("n", "<C-n>", open_current,
  { desc = "Open current file directory [Mini.files]" }
)
vim.keymap.set("n", "<leader>nc", open_current,
  { desc = "Open current file directory [Mini.files]" }
)

vim.keymap.set("n", "<leader>no", files.open,
  { desc = "Open working directory in last used state [Mini.files]" }
)

table.insert(G.plugin_hl, function(color)
  vim.api.nvim_set_hl(0, "MiniFilesBorder", { bg = nil, fg = color.light_grey })
  vim.api.nvim_set_hl(0, "MiniFilesBorderModified", { bg = nil, fg = color.yellow })
  vim.api.nvim_set_hl(0, "MiniFilesNormal", { bg = nil, fg = color.fg })
end)

local augroup = vim.api.nvim_create_augroup("mini", {})
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesWindowOpen",
  group = augroup,
  callback = function(args)
    local win_id = args.data.win_id

    -- Customize window-local settings
    vim.wo[win_id].winblend = G.const.default_winblend
    -- vim.api.nvim_win_set_config(win_id, { border = "rounded" })
  end,
})
