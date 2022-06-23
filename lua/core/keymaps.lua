local lib = require("core.lib")

-- todo use ? vim.keymap.del() ?
vim.keymap.set("n", "<bs>", "<nop>")              -- Unmap Backspace
vim.keymap.set("n", "<space>", "<nop>")           -- Unmap Space
vim.g.mapleader = " "                             -- Set Leader key

local M = {}

M.neovim = {
   n = {
      ["tn"] = { "<cmd>tabnew<cr>", "Create new tab" },
      ["<C-L>"] = { "<cmd>tabnext<cr>", "Switch to right tab" },
      ["<C-H>"] = { "<cmd>tabprev<cr>", "Switch to left tab" },
      ["tc"] = { "<cmd>tabclose<cr>", "Close current tab" },
      ["tac"] = { "<cmd>tabo<cr>", "Close all tabs" },
   }
}

local function set_telescope_keymaps(telescope)
   M.telescope = {
      n = {
         ["<Leader>p"] = { telescope.find_files, " Find files" },
         ["<Leader>F"] = { telescope.live_grep, " Global search" },
         ["<Leader>a"] = { telescope.builtin, " Telescope all" },
      },
   }
end

lib.Result(pcall(require, "telescope.builtin"))
   :Ok(set_telescope_keymaps)
   :Err(function() print("Err! Couldn't load Telescope to set keymaps") end)

return M
