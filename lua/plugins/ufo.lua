vim.o.foldcolumn = "0"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

-- I took that from ufo repo readme
local function handler(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (" [+%d lines]"):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "Conceal" })
  return newVirtText
end

require("ufo").setup({
  open_fold_hl_timeout = 200,
  fold_virt_text_handler = handler,
  -- provider_selector = function(_bufnr, _filetype, _buftype)
  provider_selector = function()
    return { "treesitter", "indent" }
  end,
})

vim.api.nvim_set_hl(0, "UfoFoldedBg", { link = "CursorColumn" })
vim.api.nvim_set_hl(0, "UfoFoldedFg", { link = "CursorLineNr" })

require("harpoon"):extend(require("harpoon.extensions").builtins.command_on_nav("UfoEnableFold"))

