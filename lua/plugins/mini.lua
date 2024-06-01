local augroup = vim.api.nvim_create_augroup("mini", {})

do -- mini files
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

  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesWindowOpen",
    group = augroup,
    callback = function(args)
      local win_id = args.data.win_id
      vim.wo[win_id].winblend = G.const.default_winblend
    end,
    desc = "Customize mini.files winblend [Mini.files]"
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
      { mode = "n", keys = "\"" },
      { mode = "x", keys = "\"" },
      { mode = "i", keys = "<C-r>" },
      { mode = "c", keys = "<C-r>" },

      -- Window commands
      { mode = "n", keys = "<C-w>" },

      -- `z` key
      { mode = "n", keys = "z" },
      { mode = "x", keys = "z" },
    },

    clues = {
      -- Enhance this by adding descriptions for <Leader> mapping groups
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },
  })

  table.insert(G.plugin_hl, function(color)
    vim.api.nvim_set_hl(0, "MiniClueBorder", { bg = nil, fg = color.light_grey })
  end)
end
