vim.o.fileformats = "unix,dos,mac"

vim.keymap.set("n", "<Leader>fO",
  function()
    local builtin = require("telescope.builtin")
    builtin.find_files({
      hidden = true,
      search_dirs = { "commonLibRepo" },
    })
  end,
  { desc = "Find files [Telescope]" }
)
