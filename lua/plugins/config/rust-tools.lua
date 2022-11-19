local rt = require("rust-tools")

rt.setup({
  server = {
    on_attach = function(_, buffer)
      local function set(lhs, rhs) vim.keymap.set("n", lhs, rhs, { buffer = buffer }) end

      set("gd", vim.lsp.buf.definition)
      set("<S-K>", vim.lsp.buf.hover)
      set("<Leader>lf", function() vim.lsp.buf.format({ async = true }) end)
      set("<Leader>lr", vim.lsp.buf.rename)
      set("<Leader>la", vim.lsp.buf.code_action)
      set("<Leader>lcr", vim.lsp.codelens.refresh)
      set("<S-H>", function() rt.hover_actions.hover_actions() end)
    end,
  },
  tools = {
    executor = require("rust-tools.executors").toggleterm,
    hover_actions = {
      auto_focus = true,
    },
    --   -- options same as lsp hover / vim.lsp.util.open_floating_preview()
    --   hover_actions = {
    --     -- see vim.api.nvim_open_win()
    --
    --     auto_focus = true,
    --   },
    --
    --   autoSetHints = true,
    --   runnables = { use_telescope = true },
    --   inlay_hints = { show_parameter_hints = true },
    -- },
    -- server = {
    --   on_attach = function(_, buffer)
    --     -- vim.keymap.set("n", "<C-h>", rt.hover_actions.hover_actions, { buffer = buffer })
    --     local function set(lhs, rhs) vim.keymap.set("n", lhs, rhs, { buffer = buffer }) end
    --
    --     set( "<C-h>", rt.runnables.runnables)
    --
    --
    --     -- default
    --     set("gd", vim.lsp.buf.definition)
    --     set("<S-K>", vim.lsp.buf.hover)
    --     set("<Leader>lf", function() vim.lsp.buf.format({ async = true }) end)
    --     set("<Leader>lr", vim.lsp.buf.rename)
    --     set("<Leader>la", vim.lsp.buf.code_action)
    --     set("<Leader>lcr", vim.lsp.codelens.refresh)
    --   end,
  },
})

-- vim.keymap.set("n", "<S-h>", "<cmd>RustHoverActions<cr>")
