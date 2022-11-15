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

local null_ls = require("null-ls")
table.insert(null_ls.builtins.formatting.prettierd.filetypes, "astro")
vim.pretty_print(null_ls.builtins.formatting.prettierd.filetypes)
