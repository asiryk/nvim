local parsers = {
  "css", "html", "java", "javascript", "jsdoc", "lua",
  "markdown", "markdown_inline", "regex", "rust", "tsx", "typescript",
  "vim", "vimdoc", "c", "go", "gomod", "gosum", "gotmpl", "gowork",
  "yaml", "toml", "json", "dockerfile", "bash", "sql", "scheme", "zig",
}

require("nvim-treesitter").setup({ auto_install = true })
require("nvim-treesitter").install(parsers)

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

require("nvim-treesitter-textobjects").setup({
  select = { lookahead = true },
})

local select_textobject = require("nvim-treesitter-textobjects.select").select_textobject
local textobjects = {
  ["af"] = { "@function.outer", "Select around function" },
  ["if"] = { "@function.inner", "Select inside function" },
  ["ab"] = { "@block.outer", "Select around block" },
  ["ib"] = { "@block.inner", "Select inside block" },
  ["ac"] = { "@comment.outer", "Select around comment" },
  ["ic"] = { "@comment.inner", "Select inside comment" },
}
for key, obj in pairs(textobjects) do
  vim.keymap.set({ "x", "o" }, key, function()
    select_textobject(obj[1], "textobjects")
  end, { desc = obj[2] })
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("NvimTreesitter-handlebars", {}),
  pattern = "handlebars",
  callback = function() vim.cmd("set filetype=html") end,
  desc = "Use html treesitter parser for handlebars",
})

require("treesitter-context").setup({
  max_lines = 10,
})

require("theme").add_highlights(function()
  return "treesitter-context",
    {
      ---@param c VaguePalette
      vague = function(c) return {
          TreesitterContext = { bg = c.bg },
          TreesitterContextBottom = { bg = c.bg, sp = c.fg, underline = true },
      } end,
      ---@param c OneDarkPalette
      onedark = function(c)
        return {
          TreesitterContext = { bg = c.bg0 },
          TreesitterContextBottom = { bg = c.bg0, sp = c.fg, underline = true },
        }
      end,
      ---@param c SonokaiShusiaPalette
      sonokai_shusia = function(c)
        return {
          TreesitterContext = { bg = c.bg_dim },
          TreesitterContextBottom = { bg = c.bg_dim, sp = c.fg, underline = true },
        }
      end,
      ---@param c GreyPalette
      grey = function(c)
        return {
          TreesitterContext = { bg = c.grey_bg_light },
          TreesitterContextBottom = { bg = c.grey_bg_light, sp = c.black, underline = true },
        }
      end,
    }
end)
