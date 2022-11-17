local present, nvim_tree = pcall(require, "nvim-tree")

if not present then return end

nvim_tree.setup({
  sort_by = "case_sensitive",
  disable_netrw = true,
  hijack_cursor = true,
  -- remove_keymaps = true, -- TODO: make custom keymaps
  -- on_attach = function(bufnr)
  --   -- set keymaps here
  -- end,
  view = {
    width = 35,
    -- height = 35, -- todo seems it's deprecated
    adaptive_size = true,
    hide_root_folder = true,
    side = "left",
    signcolumn = "yes",
  },
  renderer = {
    group_empty = true,
    highlight_git = true, -- TODO: change colors
    icons = {
      show = {
        file = true,
        folder = false,
        folder_arrow = true,
        git = false,
      },
    },
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
  },
  filters = {
    dotfiles = false,
    custom = {},
    exclude = {},
  },
  git = {
    enable = true,
    ignore = false,
  },
})

vim.keymap.set({ "n", "i" }, "<C-N>", "<cmd>NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>nf", "<cmd>NvimTreeFindFile<CR>")

-- Load colorscheme once again to fix wrong borders
vim.cmd(string.format("colorscheme %s", vim.g.colors_name))
