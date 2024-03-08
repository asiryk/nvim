local nt = require("nvim-tree")
local nt_api = require("nvim-tree.api")
local bind = require("plenary.fun").bind

nt.setup({
  sort = {
    sorter = "case_sensitive",
  },
  hijack_cursor = true,
  renderer = {
    group_empty = true,
    highlight_git = "icon",
    highlight_diagnostics = "all",
    icons = {
      show = {
        file = true,
        folder = false,
        folder_arrow = true,
        git = false,
        modified = true,
        diagnostics = true,
        bookmarks = true,
      },
    },
  },
  on_attach = function(buffer)
    local function set(lhs, rhs)
      vim.keymap.set("n", lhs, rhs, { buffer = buffer, nowait = true })
    end

    set("i", "<NOP>")
    set("c", "<NOP>")

    set("<Tab>", nt_api.node.open.preview)
    set("<CR>", nt_api.node.open.edit)
    set("<2-LeftMouse>", nt_api.node.open.edit)
    set("gk", nt_api.node.navigate.parent)
    set("gj", nt_api.node.navigate.sibling.last)
    set("gc", bind(nt_api.tree.collapse_all, true))
    set("a", nt_api.fs.create)
    set("d", nt_api.fs.remove)
    set("r", nt_api.fs.rename)
    set("x", nt_api.fs.cut)
    set("p", nt_api.fs.paste)
    set("cd", nt_api.tree.change_root_to_node)
    set("<S-R>", nt_api.tree.reload)
  end,
  diagnostics = {
    enable = true,
    show_on_dirs = true,
  },
})

vim.keymap.set({ "n", "i" }, "<C-N>", "<cmd>NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>nf", "<cmd>NvimTreeFindFile<CR>")

-- Load colorscheme once again to fix wrong borders
vim.cmd(string.format("colorscheme %s", vim.g.colors_name))
