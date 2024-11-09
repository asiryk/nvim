vim.opt.shiftwidth = 2

local utils = require("custom").utils

--- Since this file runs for every buffer we need to avoid
--- initializing data multiple times (especially reading from files)
local function init()
  if L.javascript == nil then L.javascript = {} end

  if L.javascript.queries == nil then
    L.javascript.queries = {}
    local queries_dir = vim.fn.stdpath("config") .. "/after/ftplugin/javascript"
    local methods = utils.read_file(queries_dir .. "/methods.scm")
    L.javascript.queries.methods = methods
  end
end

local ok = pcall(init)
if not ok then
  vim.notify("Failed to initialize javascript plugin", vim.log.levels.WARN)
end

-- Parse and execute the query
local function exec_ts_query(bufnr, query_str)
  local ts = vim.treesitter
  local parser = ts.get_parser(bufnr, "javascript")
  local tree = parser:parse()[1]
  local query = ts.query.parse("javascript", query_str)

  local results = {}
  for id, node in query:iter_captures(tree:root(), 0) do
    local capture_name = query.captures[id]
    local text = vim.treesitter.get_node_text(node, 0)
    local start_row, start_col, end_row, end_col = vim.treesitter.get_node_range(node)
    table.insert(results, {
      capture_name = capture_name,
      match_text = text,
      node = node,
      start_row = start_row + 1,
      start_col = start_col + 1,
      end_row = end_row + 1,
      end_col = end_col,
    })
  end
  return results
end

local function methods_picker()
  local raw_results = exec_ts_query(0, L.javascript.queries.methods)
  if vim.tbl_isempty(raw_results) then return end
  local results = {}
  for _, res in pairs(raw_results) do
    table.insert(results, {
      kind = "",
      text = res.match_text,
      node = res.node,
      lnum = res.start_row,
      col = res.start_col,
    })
  end

  local actions = require("telescope.actions")
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local make_entry = require "telescope.make_entry"

  pickers
    .new({}, {
      prompt_title = "File Methods",
      finder = finders.new_table({
        results = results,
        entry_maker = make_entry.gen_from_treesitter({ show_line = true })
      }),
      previewer = conf.grep_previewer({}),
      sorter = conf.prefilter_sorter({
        sorter = conf.generic_sorter({}),
      }),
      push_cursor_on_edit = true,
      attach_mappings = function(_, map)
        map("i", "<CR>", actions.select_default + actions.center)
        map("n", "<CR>", actions.select_default + actions.center)
        return true
      end,
    })
    :find()
end

vim.keymap.set("n", "<LocalLeader>fm", methods_picker)
