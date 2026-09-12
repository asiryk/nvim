local telescope = require("telescope")
local builtin = require("telescope.builtin")
local bind = require("plenary.fun").bind
local themes = require("telescope.themes")

local function find_nvim_config() builtin.find_files({ cwd = "~/.config/nvim/" }) end

vim.keymap.set("n", "<Leader>fo",
  bind(builtin.find_files, { hidden = true }),
  { desc = "Find files [Telescope]" }
)

-- Pick files and put `@/abs/path` references at the cursor instead of opening
-- them (Claude Code file mentions). Multi-select (<Tab>) inserts all of them.
-- Meant for insert mode: the cursor position is captured up front and insert
-- mode is resumed after the inserted text.
local function insert_file_refs()
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local win = vim.api.nvim_get_current_win()
  local row, col = unpack(vim.api.nvim_win_get_cursor(win))
  builtin.find_files({
    hidden = true,
    prompt_title = "Insert @path",
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local entries = action_state.get_current_picker(prompt_bufnr):get_multi_selection()
        if vim.tbl_isempty(entries) then entries = { action_state.get_selected_entry() } end
        actions.close(prompt_bufnr)
        if #entries == 0 then return end -- <CR> with no matches
        local refs = {}
        for _, entry in ipairs(entries) do
          table.insert(refs, "@" .. vim.fn.fnamemodify(entry.path or entry[1], ":p"))
        end
        local buf = vim.api.nvim_win_get_buf(win)
        local text = table.concat(refs, " ")
        vim.api.nvim_buf_set_text(buf, row - 1, col, row - 1, col, { text })
        -- Deferred past telescope's own mode switching on close; then resume
        -- insert right after the text (`startinsert!` when that's end of line).
        vim.schedule(function()
          if not vim.api.nvim_win_is_valid(win) then return end
          vim.api.nvim_set_current_win(win)
          local end_col = col + #text
          vim.api.nvim_win_set_cursor(win, { row, end_col })
          local at_eol = end_col >= #vim.api.nvim_buf_get_lines(buf, row - 1, row, true)[1]
          vim.cmd(at_eol and "startinsert!" or "startinsert")
        end)
      end)
      return true
    end,
  })
end

-- Only in Claude Code prompt buffers: its external editor (Ctrl+G) opens
-- `$TMPDIR/claude-prompt-<id>.md` and passes no env marker.
if vim.api.nvim_buf_get_name(0):match("/claude%-prompt%-[^/]*%.md$") then
  vim.keymap.set("i", "<C-o>", insert_file_refs, { buffer = 0, desc = "Insert @file path [Telescope]" })
end

vim.keymap.set("n", "<Leader>ff",
  bind(builtin.live_grep, { additional_args = { "--hidden", "--fixed-strings" } }),
  { desc = "Find text [Telescope]" }
)

local function buffers() builtin.buffers(themes.get_ivy()) end
vim.keymap.set("n", "<Leader>fa", builtin.builtin, { desc = "Find action [Telescope]" })
vim.keymap.set("n", "<Leader>fb", buffers, { desc = "Find buffers [Telescope]" })
vim.keymap.set("n", "<Leader>fc", find_nvim_config, { desc = "Find Neovim configs [Telescope]" })
vim.keymap.set("n", "<Leader>fr", builtin.lsp_references, { desc = "Find LSP references [Telescope]" })
vim.keymap.set("n", "<Leader>fh", builtin.help_tags, { desc = "Find Neovim help [Telescope]" })
vim.keymap.set("n", "<Leader>fk", builtin.keymaps, { desc = "Find keymaps [Telescope]" })
vim.keymap.set("n", "<Leader>fm", builtin.marks, { desc = "Find marks [Telescope]" })
vim.keymap.set("n", "<Leader>fs", builtin.spell_suggest, { desc = "Suggest spell fixes under cursor [Telescope]" })

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
  "^.*package%-lock.json$",
}

local options = {
  defaults = {
    winblend = vim.o.pumblend,
    prompt_prefix = "",
    selection_caret = "  ",
    file_ignore_patterns = ignore_files,
  },
  extensions = {
    ["ui-select"] = {
      themes.get_dropdown({ winblend = vim.o.pumblend }),
    },
  },
}

telescope.setup(options)
telescope.load_extension("fzf")
telescope.load_extension("ui-select")

---
--- pickers
---
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

