local present, toggleterm = pcall(require, "toggleterm")

if not present then return end

toggleterm.setup({
  open_mapping = [[<C-T>]],
  direction = "horizontal",
  float_opts = { border = "rounded", winblend = 3 },
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return math.floor(vim.o.columns * 0.4)
    end
  end,
})

local Terminal = require("toggleterm.terminal").Terminal
local btop = Terminal:new({ cmd = "btop", hidden = true })

vim.keymap.set("n", "<Leader>tb", function() btop:toggle() end)
