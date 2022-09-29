local present, ts_context = pcall(require, "treesitter-context")

if not present then return end

ts_context.setup({
  enable = true,
  -- throttle = true, -- Throttles plugin updates (may improve performance)
  -- max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
  -- show_all_context = true,
  patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
    -- For all filetypes
    -- Note that setting an entry here replaces all other patterns for this entry.
    -- By setting the 'default' entry below, you can control which nodes you want to
    -- appear in the context window.
    default = {
      "function",
      "method",
      "for",
      "while",
      "if",
      "switch",
      "case",
    },

    rust = {
      "loop_expression",
      "impl_item",
    },

    typescript = {
      "class_declaration",
      "abstract_class_declaration",
      "else_clause",
    },
  },
})
