local telescope = require("telescope")
local builtin = require("telescope.builtin")
local bind = require("plenary.fun").bind

local function find_nvim_config() builtin.find_files({ cwd = "~/.config/nvim/" }) end

vim.keymap.set("n", "<Leader>fo",
  bind(builtin.find_files, { hidden = true }),
  { desc = "Find files [Telescope]" }
)
vim.keymap.set("n", "<Leader>ff",
  bind(builtin.live_grep, { additional_args = { "--hidden" } }),
  { desc = "Find text [Telescope]" }
)
vim.keymap.set("n", "<Leader>fa", builtin.builtin, { desc = "Find action [Telescope]" })
vim.keymap.set("n", "<Leader>fb", builtin.buffers, { desc = "Find buffers [Telescope]" })
vim.keymap.set("n", "<Leader>fc", find_nvim_config, { desc = "Find Neovim configs [Telescope]" })
vim.keymap.set("n", "<Leader>fr", builtin.lsp_references, { desc = "Find LSP references [Telescope]" })
vim.keymap.set("n", "<Leader>fh", builtin.help_tags, { desc = "Find Neovim help [Telescope]" })
vim.keymap.set("n", "<Leader>fk", builtin.keymaps, { desc = "Find keymaps [Telescope]" })
vim.keymap.set("n", "<Leader>fm", builtin.marks, { desc = "Find marks [Telescope]" })

local ignore_files = {
  -- folders
  ".git/",
  "node_modules/",
  "bin/",
  "obj/",

  -- files
  "^.*%.ogg$",
  "^.*%.m4a$",
  "^.*%.log$",
  "^.*%.png$",
  "^.*%.jpg$",
  "^.*%.wav$",
  "^.*%.webp$",
  "^.*%.fnt$",
  "^.*%.woff?2$",
  "^.*%.atlas$",
  "^.*%.spine$",
}

local options = {
  defaults = {
    winblend = vim.o.pumblend,
    prompt_prefix = "",
    selection_caret = "  ",
    file_ignore_patterns = ignore_files,
  },
}

telescope.setup(options)
telescope.load_extension("fzf")

---
--- pickers
---
local themes = require("telescope.themes")
local actions = require("telescope.actions")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local devicons = require("nvim-web-devicons")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")

local function get_modified_files()
  local handle = io.popen("git status --porcelain")
  if handle == nil then
    vim.notify("Unable to get git status", vim.log.levels.ERROR)
    return
  end

  local result = handle:read("*a")
  handle:close()

  local modified_files = {}
  for line in result:gmatch("[^\r\n]+") do
    local status, file = line:match("^(..)%s+(.*)$")
    if status and file then
      -- local absolute_path = vim.fn.fnamemodify(file, ":p")
      table.insert(modified_files, file)
    end
  end

  return modified_files
end

local function modified_git_files_picker()
  local modified_files = get_modified_files()

  local displayer = entry_display.create({
    separator = " ",
    items = {
      { width = 2 },  -- Icon
      { remaining = true },  -- File name
    },
  })

  local function make_display(entry)
    local icon, icon_highlight = devicons.get_icon(entry.value)
    return displayer({
      { icon, icon_highlight },
      entry.value,
    })
  end

  pickers
    .new({}, {
      prompt_title = "Modified Git Files",
      finder = finders.new_table({
        results = modified_files,
        entry_maker = function(entry)
          return {
            value = entry,
            ordinal = entry,
            display = make_display,
          }
        end,
      }),
      previewer = conf.file_previewer({}),
      sorter = conf.file_sorter({}),
      attach_mappings = function(_, map)
        map("i", "<CR>", actions.select_default + actions.center)
        map("n", "<CR>", actions.select_default + actions.center)
        return true
      end,
    })
    :find()
end

vim.keymap.set("n", "<Leader>fg", modified_git_files_picker, { desc = "Find modified Git files [Telescope]" })

local function open_harpoon_files(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers")
    .new(themes.get_dropdown({}), {
      prompt_title = "Harpoon",
      finder = require("telescope.finders").new_table({
        results = file_paths,
      }),
      -- previewer = conf.file_previewer({}),
      sorter = conf.generic_sorter({}),
    })
    :find()
end

vim.keymap.set(
  "n",
  "<leader>hf",
  function() open_harpoon_files(require("harpoon"):list()) end,
  { desc = "Open harpoon window [Telescope]" }
)

require("theme").add_highlights(function(c)
  local highlights = {
    TelescopeBorder = { fg = c.red },
    TelescopePromptBorder = { fg = c.cyan },
    TelescopeResultsBorder = { fg = c.cyan },
    TelescopePreviewBorder = { fg = c.cyan },
    TelescopeMatching = { fg = c.orange, bold = true },
    TelescopePromptPrefix = { fg = c.green },
    TelescopeSelection = { bg = c.bg2 },
    TelescopeSelectionCaret = { fg = c.yellow },
  }

  return "telescope", highlights
end)
