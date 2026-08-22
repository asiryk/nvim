-- Plugin management via Neovim's built-in |vim.pack| (0.12+).
--
-- Plugins live in `stdpath("data")/site/pack/core/opt`; revisions are pinned in
-- `nvim-pack-lock.json` next to this config (version-controlled — it is what
-- makes a fresh clone reproducible).
--
-- Ordering in the `add()` call matters: `vim.pack` has no dependency graph, so
-- a plugin's dependencies are simply listed before it. Configuration lives in
-- `lua/plugins/<name>.lua` and is `require`d below, after the `add()` call has
-- put every plugin on 'runtimepath'.
--
-- Note on load timing: during 'init.lua' sourcing `vim.pack.add()` defaults to
-- `load = false`, i.e. `:packadd!` — directories join 'runtimepath' but their
-- `plugin/` and `ftdetect/` files are sourced by Nvim's normal |load-plugins|
-- step right after 'init.lua' returns. The `require(...).setup()` calls below
-- are plain Lua and do not depend on that step having run.

-- Don't load plugins if using neovim as manpager
for _, arg in pairs(vim.v.argv) do
  if arg == "+Man!" or arg == "Man!" then return end
end

local function gh(repo) return "https://github.com/" .. repo end

-- ─────────────────────────── Build hooks ─────────────────────────────────────
-- lazy.nvim's `build` key. Must be registered before `add()` so it also fires
-- on the very first install.

local build_hooks = {
  ["telescope-fzf-native.nvim"] = function(ev) vim.system({ "make" }, { cwd = ev.data.path }):wait() end,
  -- Parser upkeep, the `build = ":TSUpdate"` equivalent. Uses the Lua API
  -- rather than the `:TSUpdate` command: on "install" the hook runs before the
  -- plugin is loaded, so the command does not exist yet.
  ["nvim-treesitter"] = function() require("nvim-treesitter").update() end,
}

vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("pack-build-hooks", { clear = true }),
  desc = "Run plugin build steps after install/update",
  callback = function(ev)
    if ev.data.kind ~= "install" and ev.data.kind ~= "update" then return end
    local hook = build_hooks[ev.data.spec.name]
    if not hook then return end
    -- The hook may need the plugin's own code; on "install" it is on disk but
    -- not yet on 'runtimepath'.
    if not ev.data.active then pcall(vim.cmd.packadd, ev.data.spec.name) end
    local ok, err = pcall(hook, ev)
    if not ok then
      vim.notify(("Build hook for %s failed: %s"):format(ev.data.spec.name, err), vim.log.levels.WARN)
    end
  end,
})

-- ─────────────────────────── Plugins ─────────────────────────────────────────

vim.pack.add({
  -- Shared libraries, first so dependents find them.
  gh("nvim-lua/plenary.nvim"),
  gh("nvim-tree/nvim-web-devicons"),

  gh("echasnovski/mini.nvim"),
  gh("asiryk/snacks.nvim"),

  -- treesitter
  { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
  gh("nvim-treesitter/nvim-treesitter-context"),
  gh("nvim-treesitter/nvim-treesitter-textobjects"),

  -- lsp
  gh("williamboman/mason.nvim"),
  gh("williamboman/mason-lspconfig.nvim"),
  gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
  gh("neovim/nvim-lspconfig"),
  gh("stevearc/conform.nvim"),

  -- completion
  gh("L3MON4D3/LuaSnip"),
  { src = gh("saghen/blink.cmp"), version = vim.version.range("1") },

  -- telescope
  gh("nvim-telescope/telescope-fzf-native.nvim"),
  gh("nvim-telescope/telescope-ui-select.nvim"),
  gh("nvim-telescope/telescope.nvim"),

  -- git
  { src = gh("lewis6991/gitsigns.nvim"), version = "v2.1.0" },
  gh("tpope/vim-fugitive"),
  gh("asiryk/diffview.nvim"),

  -- misc
  { src = gh("ThePrimeagen/harpoon"), version = "harpoon2" },
  gh("j-hui/fidget.nvim"),
  gh("stevearc/quicker.nvim"),
  gh("folke/flash.nvim"),
})

-- ─────────────────────────── Configuration ───────────────────────────────────

-- lazy.nvim's `VeryLazy` equivalent: run once the UI is up, so the work lands
-- after the first screen is drawn instead of before it.
local function defer(fn)
  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = vim.schedule_wrap(fn),
  })
end

require("nvim-web-devicons").setup({ blend = 0 })

require("plugins.mini")

require("snacks").setup({
  bigfile = { enabled = true },
  indent = {
    enabled = true,
    hl = "SnacksIndent",
    scope = { hl = "SnacksIndent1" },
    animate = { enabled = false },
  },
  dim = {}, -- Leave it on for fun. Usage :lua Snacks.dim.enable()
  input = {
    enabled = true,
    win = { wo = { winblend = vim.o.pumblend } },
  },
})

require("plugins.treesitter")
require("plugins.lsp")
require("plugins.blink")
require("plugins.harpoon")
require("plugins.gitsigns")

-- Telescope is the single most expensive config here (~15ms) and nothing needs
-- it before the UI is up. Deferring it off the critical path replaces the
-- `event = "VeryLazy"` it had under lazy.nvim.
defer(function() require("plugins.telescope") end)

do -- diffview
  local actions = require("diffview.actions")

  -- Shared across the three panels: next/prev entry and a uniform close.
  local nav_keymaps = {
    { "n", "<M-j>", actions.select_next_entry, { desc = "Next file entry [User]" } },
    { "n", "<M-k>", actions.select_prev_entry, { desc = "Prev file entry [User]" } },
    { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview [User]" } },
  }

  require("diffview").setup({
    -- Per-window winbar labelling each diff side ("WORKING TREE - path",
    -- "<hash>:path"). Built into diffview but off by default.
    view = {
      default = { winbar_info = true },
      file_history = { winbar_info = true },
    },
    file_panel = {
      listing_style = "list",
      win_config = { position = "bottom", height = 10 },
    },
    keymaps = {
      view = nav_keymaps,
      file_panel = nav_keymaps,
      file_history_panel = nav_keymaps,
    },
  })
end

require("plugins.git").setup_shared()

require("fidget").setup({})

-- Deferred rather than hung off `FileType qf` (its `event` under lazy.nvim):
-- quicker installs its own `FileType qf` handler, which would not fire for the
-- very buffer whose FileType event triggered the setup.
defer(function() require("quicker").setup({}) end)

do -- flash
  -- Keymaps are registered eagerly and `require` inside the callback, so the
  -- plugin itself only loads on first use; only `setup()` needs deferring.
  defer(function()
    require("flash").setup({
      modes = {
        char = {
          keys = {},
        },
      },
    })
  end)

  local set = vim.keymap.set
  set({ "n", "x", "o" }, "S", function() require("flash").jump() end, { desc = "Flash" })
  set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
  set("c", "<C-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })
end
