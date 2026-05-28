vim.api.nvim_create_autocmd("FileType", {
  pattern = "javascript",
  callback = function(data)
    local path = data.file
    if path:match("^lib") and not path:match("^lib/game") then
      vim.bo.shiftwidth = 4
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "xml",
  callback = function(data)
    local path = data.file
    if path:match("config.xml") then
      vim.bo.shiftwidth = 4
    end
  end,
})

vim.keymap.set("n", "<Leader>fO",
  function()
    local builtin = require("telescope.builtin")
    builtin.find_files({
      hidden = true,
      no_ignore = true,
      search_dirs = { "game", "lib" },
    })
  end,
  { desc = "Find files [Telescope]" }
)
