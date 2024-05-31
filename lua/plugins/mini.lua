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
