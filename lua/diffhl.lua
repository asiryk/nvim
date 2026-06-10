-- Treesitter source-language highlighting for unified diffs: patch/diff files
-- and fugitive `:Git diff` / `:Git show` buffers. Hunk content is highlighted
-- with each file's own parser, plus full-width green/red line backgrounds.
--
-- Why this is non-trivial: the diff parse tree is unreliable (real git diffs with
-- trailing `@@` context, blank lines, and index lines flatten it so change lines
-- aren't nested under (changes)), and a multi-file diff mixes languages. So we
-- generate one fixed-language injection pattern per language and use a predicate
-- to route each line to its file's language, with the per-file boundaries computed
-- here in Lua. Injection is NON-combined (one region per line): combined would
-- give better multi-line parsing but its range handling cross-contaminates
-- languages and interleaves old/new lines; per-line is robust and predictable —
-- each line parses on its own (keywords/strings/numbers correct), at the cost of
-- multi-line constructs and outer-level JSON keys not resolving.

-- Languages we attempt to highlight inside diffs. Patterns referencing a parser
-- that isn't installed are simply skipped at injection time, so a broad list is
-- harmless.
local LANGS = {
  "lua", "json", "jsonc", "javascript", "typescript", "tsx", "python", "go",
  "rust", "c", "cpp", "java", "ruby", "bash", "yaml", "toml", "html", "css",
  "scss", "markdown", "vim", "sql", "zig", "dockerfile", "graphql", "proto",
}

-- bufnr -> sorted list of { row, lang }: the file each `+++ b/path` header starts
-- and the language it maps to. A line's language is the last header at/above it.
local file_langs = {}

local function compute_file_langs(buf)
  local res = {}
  for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    local path = line:match("^%+%+%+ [ab]/(.+)$") or line:match("^%+%+%+ (%S+)")
    if path and path ~= "/dev/null" then
      path = path:gsub("%s+$", "")
      local ft = vim.filetype.match({ filename = path })
      local lang = ft and vim.treesitter.language.get_lang(ft)
      res[#res + 1] = { row = i - 1, lang = lang or "" }
    end
  end
  file_langs[buf] = res
  return res
end

-- Predicate: does the matched line node belong to a file of the given language?
vim.treesitter.query.add_predicate("diff-file-lang?", function(match, _, bufnr, pred)
  local regions = file_langs[bufnr] or compute_file_langs(bufnr)
  local node = match[pred[2]]
  if type(node) == "table" then node = node[#node] end
  if not node then return false end
  local row = node:range()
  local lang
  for _, e in ipairs(regions) do
    if row >= e.row then lang = e.lang else break end
  end
  return lang == pred[3]
end, { force = true, all = false })

-- Build and install the injection query: comment injection (from upstream) plus
-- one per-language pattern. `#offset! 0 1 0 0` strips column 0 (the +/-/space
-- marker) so the parser sees clean code; `include-children` makes the offset, not
-- child-exclusion, remove the marker.
local function install_query()
  local patterns = { '((comment) @injection.content (#set! injection.language "comment"))' }
  for _, lang in ipairs(LANGS) do
    patterns[#patterns + 1] = string.format(
      [[([(context) (addition) (deletion)] @injection.content
  (#diff-file-lang? @injection.content %q)
  (#offset! @injection.content 0 1 0 0)
  (#set! injection.language %q)
  (#set! injection.include-children))]], lang, lang)
  end
  vim.treesitter.query.set("diff", "injections", table.concat(patterns, "\n"))
end
install_query()

-- Filetypes whose buffers contain unified-diff text. `git` covers fugitive's
-- `:Git diff` / `:Git show` output (it has no parser of its own).
local diff_fts = { diff = true, git = true }

-- Full-width green/red line backgrounds for added/removed lines (diffview-style).
-- DiffAdd/DiffDelete are theme groups (bg only), so they track colorscheme
-- switches and the injected source foreground layers on top via `line_hl_group`.
local bg_ns = vim.api.nvim_create_namespace("diffhl_linebg")
local linebg_query = vim.treesitter.query.parse("diff", "((addition) @add) ((deletion) @del)")

local function refresh_linebg(buf)
  if not vim.api.nvim_buf_is_valid(buf) or not diff_fts[vim.bo[buf].filetype] then return end
  local ok, parser = pcall(vim.treesitter.get_parser, buf, "diff")
  if not ok or not parser then return end
  local tree = parser:parse()[1]
  vim.api.nvim_buf_clear_namespace(buf, bg_ns, 0, -1)
  if not tree then return end
  for id, node in linebg_query:iter_captures(tree:root(), buf) do
    local grp = linebg_query.captures[id] == "add" and "DiffAdd" or "DiffDelete"
    local sr, _, er, ec = node:range()
    for ln = sr, (ec == 0 and er - 1 or er) do
      vim.api.nvim_buf_set_extmark(buf, bg_ns, ln, 0, { line_hl_group = grp, priority = 90 })
    end
  end
end

vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter", "TextChanged", "TextChangedI" }, {
  group = vim.api.nvim_create_augroup("diffhl", {}),
  callback = function(args)
    if not diff_fts[vim.bo[args.buf].filetype] then return end
    compute_file_langs(args.buf)        -- refresh before (re)parsing injections
    pcall(vim.treesitter.start, args.buf, "diff")
    refresh_linebg(args.buf)
  end,
})

vim.api.nvim_create_autocmd("BufWipeout", {
  group = "diffhl",
  callback = function(args) file_langs[args.buf] = nil end,
})
