local augroup = vim.api.nvim_create_augroup("mini", {})

do -- mini files
  local files = require("mini.files")
  files.setup()

  local function open_current()
    local path_str = vim.api.nvim_buf_get_name(0)
    local ok = pcall(files.open, path_str)
    if not ok then files.open() end
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

  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesWindowOpen",
    group = augroup,
    callback = function(args)
      local win_id = args.data.win_id
      vim.wo[win_id].winblend = G.const.default_winblend
      local border = G.config.window.border
      -- mini requires border for file names
      if border == "none" then border = "solid" end
      vim.api.nvim_win_set_config(win_id, { border = border })
    end,
    desc = "Customize mini.files winblend [Mini.files]",
  })

  local function open_in_finder()
    local entry = files.get_fs_entry()
    do -- sanity check
      if entry == nil then
        local lines_to_iter = math.min(100, vim.api.nvim_buf_line_count(0))
        for i = 1, lines_to_iter do
          local e = files.get_fs_entry(nil, i)
          if e ~= nil then
            entry = e
            break
          end
        end
        if entry == nil then
          local msg = "Failed to get file information"
          vim.notify(msg, vim.log.levels.WARN)
          return
        end
      end
    end

    local dir = nil
    if entry.fs_type == "file" then
      dir = vim.fs.dirname(entry.path)
    else
      dir = entry.path
    end
    os.execute("open " .. dir)
  end

  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesBufferCreate",
    group = augroup,
    callback = function(args)
      local buf_id = args.data.buf_id
      vim.keymap.set("n", "go", open_in_finder, { buffer = buf_id })
    end,
    desc = "Set buffer keymaps [Mini.files]",
  })
end

do
  local miniclue = require("mini.clue")
  miniclue.setup({
    triggers = {
      -- Leader triggers
      { mode = "n", keys = "<Leader>" },
      { mode = "x", keys = "<Leader>" },

      -- Built-in completion
      { mode = "i", keys = "<C-x>" },

      -- `g` key
      { mode = "n", keys = "g" },
      { mode = "x", keys = "g" },

      -- Marks
      { mode = "n", keys = "'" },
      { mode = "n", keys = "`" },
      { mode = "x", keys = "'" },
      { mode = "x", keys = "`" },

      -- Registers
      { mode = "n", keys = '"' },
      { mode = "x", keys = '"' },
      { mode = "i", keys = "<C-r>" },
      { mode = "c", keys = "<C-r>" },

      -- Window commands
      { mode = "n", keys = "<C-w>" },

      -- `z` key
      -- { mode = "n", keys = "z" },
      -- { mode = "x", keys = "z" },
    },

    clues = {
      -- Enhance this by adding descriptions for <Leader> mapping groups
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      -- miniclue.gen_clues.z(),
    },
  })

  table.insert(
    G.plugin_hl,
    function(color)
      vim.api.nvim_set_hl(0, "MiniClueBorder", { bg = nil, fg = color.light_grey })
    end
  )
end

do
  require("mini.cursorword").setup({
    delay = 25,
  })
  table.insert(G.plugin_hl, function()
    vim.api.nvim_set_hl(0, "MiniCursorword", { link = "CursorColumn" })
    vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", {})
  end)
end

do
  local hipatterns = require("mini.hipatterns")
  hipatterns.setup({
    highlighters = {
      -- Highlight standalone 'FIXME', 'TODO', 'NOTE'
      fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
      todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
      note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

      -- Highlight hex color strings (`#rrggbb`) using that color
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end
