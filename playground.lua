-- vim.api.nvim_echo({{ "before treesitter stopped", "TSConstant" }}, true, {})

-- local function get_buf_size_in_bytes(buf)
--   local line_count = vim.api.nvim_buf_line_count(buf)
--   return vim.api.nvim_buf_get_offset(buf, line_count)
-- end
-- print(get_buf_size_in_bytes(vim.api.nvim_get_current_buf()))

-- vim.ui.select({ "tabs", "spaces" }, {
--   prompt = "Select tabs or spaces:",
--   format_item = function(item) return "I'd like to choose " .. item end,
-- }, function(choice)
--   if choice == "spaces" then
--     vim.o.expandtab = true
--   else
--     vim.o.expandtab = false
--   end
-- end)

-- local null_ls = require("null-ls")
-- table.insert(null_ls.builtins.formatting.prettierd.filetypes, "astro")
-- vim.pretty_print(null_ls.builtins.formatting.prettierd.filetypes)

-- NeoTreeVertSplit = { fg = c.bg1, bg = cfg.transparent and c.none or c.bg1 },

-- NvimTreeVertSplit

-- VertSplit = {fg = c.bg3},




---
--- LSP rust-analyzer runnables
---
-- local buf = 13
-- local function get_params(buf_number)
--   return {
--     textDocument = vim.lsp.util.make_text_document_params(buf_number),
--     position = nil, -- get em all
--   }
-- end

-- local function get_options(result)
--   local option_strings = {}
--
--   for _, runnable in ipairs(result) do
--     local str = runnable.label
--     table.insert(option_strings, str)
--   end
--
--   return option_strings
-- end
-- local function handler(_, result)
--   -- :h lsp-handler
--   local options = get_options(result)
--   vim.pretty_print(options)
-- end
-- vim.lsp.buf_request(buf, "experimental/runnables", get_params(buf), handler)
---
--- LSP rust-analyzer runnables
---


-- vim.ui.input({ prompt = 'enter colorscheme mode' }, function(input)
--   vim.print(input)
-- end)

-- vim.ui.input({ prompt = "Commit message: " }, function(msg)
--   if not msg then return end
--   -- vim.print(msg);
-- end)


-- vim.ui.select({ 'tabs', 'spaces' }, {
--   prompt = 'Select tabs or spaces:',
--   format_item = function(item)
--     return "I'd like to choose " .. item
--   end,
-- }, function(choice)
--     print(choice)
--     -- if choice == 'spaces' then
--     --   vim.o.expandtab = true
--     -- else
--     --   vim.o.expandtab = false
--     -- end
--   end)

local RingBuffer = require("ring_buffer")
local storage_buffer = RingBuffer.new(10)
storage_buffer:push(1)
vim.print(#storage_buffer)
