local term = require("toggleterm")

term.setup({
  open_mapping = [[<C-T>]],
  direction = "horizontal",
  float_opts = { border = "rounded", winblend = 3 },
  size = function(t)
    if t.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return math.floor(vim.o.columns * 0.4)
    end
  end,
})
