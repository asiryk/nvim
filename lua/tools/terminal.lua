local function set_buf_keymaps()
  local opts = { noremap = true }
  vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
end

require("toggleterm").setup {
  on_open = set_buf_keymaps,
  size = vim.o.columns * 0.3,
  open_mapping = [[<c-\>]],
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_terminals = true,
  shading_factor = "1", -- the degree by which to darken to terminalcolour, default: 1 for dark backgrounds, 3 for light
  start_in_insert = false,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
  persist_size = true,
  direction = "vertical", -- "vertical" | "horizontal" | "window" | "float",
  close_on_exit = true, -- close the terminal window when the process exits
  shell = vim.o.shell, -- change the default shell
  float_opts = {
    border = "curved", -- see :h nvim_open_win for details on borders however
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal",
    }
  }
}

vim.api.nvim_set_keymap("n", "`", "<cmd>ToggleTermToggleAll<cr>", { noremap = true })
