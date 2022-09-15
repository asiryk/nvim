local opts = {
  tools = {
    -- options same as lsp hover / vim.lsp.util.open_floating_preview()
    hover_actions = {
      -- see vim.api.nvim_open_win()

      auto_focus = true,
    },

    autoSetHints = true,
    runnables = { use_telescope = true },
    inlay_hints = { show_parameter_hints = true },
  },
}

require("rust-tools").setup(opts)

vim.keymap.set("n", "<S-h>", "<cmd>RustHoverActions<cr>")
