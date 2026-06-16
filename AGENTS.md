# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## Overview

Personal Neovim configuration targeting Neovim 0.12+. All configuration is in Lua. No build/test/lint commands — changes are validated by restarting Neovim.

**Keep this file current:** when editing code that changes a feature, convention, or architectural detail documented here, update the corresponding section in this file as part of the same change.

## Architecture

**Entry point:** `init.lua` loads modules in this order: `custom` (globals/utils) -> `defaults` (vim options/autocmds) -> `fold` (treesitter folds + `[+N lines]` virt_text) -> `keymaps` -> `menu` (right-click popup) -> colorscheme -> `plugin_spec` (lazy.nvim) -> `qfpersist` -> `statusline` -> `winbar` -> `tabline` -> `claudecode` -> `diffhl`.

**Global state:** `G` (global table with `utils` and `log`), `L` (language-specific storage), `PopUpMenu` (right-click menu functions). These are set in `lua/custom.lua` and available everywhere.

**Plugin management:** lazy.nvim with all specs defined inline in `lua/plugin_spec.lua`. Each plugin's config lives in `lua/plugins/<name>.lua`. Plugins skip loading when Neovim is used as a manpager.

**Theme system:** Custom colorscheme in `colors/custom.lua` that calls `lua/theme.lua`. Each palette in `lua/palette/*.lua` exports a table of **role → full highlight spec** (e.g. `keyword = { fg = "#...", bold = true }`). Raw hex colors live as `local c = {...}` atoms at the top of each palette file, used to build the role specs; they are never exposed outside the palette. `lua/highlights.lua` and `lua/plugin_highlights.lua` list highlight groups, and each entry is either a string role name (resolved against the current palette) or a palette-agnostic spec table (links, `reverse = true`, literal hexes). `theme.lua`'s resolver looks up roles by name and applies them; `hi clear` runs first on each switch, and module caches are invalidated so edits land without an nvim restart. Blink's per-kind icon colors ride on a palette-level `blink_kind = { <Kind> = color }` table expanded at apply time. Plugin configs under `lua/plugins/` stay untouched when adding a palette — only `lua/palette/<name>.lua` and `lua/theme.lua` (for `palettes`/`colorscheme`) need edits. The active schemes are selected by `colorscheme.dark` / `colorscheme.light` in `lua/theme.lua`.

**Filetype configs:** `after/ftplugin/<lang>.lua` for language-specific settings (shiftwidth, formatters, LSP tweaks). Some have subdirectories with additional files.

**LSP:** Configured through `nvim-lspconfig` + Mason. Server list and per-server config in `lua/plugins/lsp.lua`. Formatting via `conform.nvim`. The `lua_ls` setup auto-detects whether it's editing this Neovim config (adds runtime libs) or a project with `.luarc.json` (defers to that).

**Key conventions:**
- Leader is `<Space>`, local leader is `,`
- `<Leader>l*` — LSP actions (format, rename, code action, diagnostics)
- `<Leader>f*` — Telescope finders
- `<Leader>n*` — Mini.files navigation
- `<Leader>h*` — Harpoon
- `<Leader>t*` — Tab management
- `<Leader>x*` — Execute Lua code
- Ukrainian keyboard layout is mapped to English equivalents in normal/visual/operator modes

**Custom features:**
- `qfpersist` (`lua/qfpersist.lua`): Save/load/delete quickfix lists to disk as JSON. Commands: `QFSave`, `QFLoad`, `QFDelete`.
- `claudecode` (`lua/claudecode.lua`): Claude Code terminal integration. Commands `ClaudeCode` (runs `claude`) and `ClaudeCodeResume` (runs `claude --resume`). A single session is identified by the buffer-local flag `b:claude_code = true`. Behavior: if the buffer exists with a live job, focus its tab (creating a new leftmost tab if it's hidden); if the buffer exists but the job has died, wipe it and spawn fresh; `ClaudeCodeResume` falls back to focusing the existing session with a warning. New tabs are moved leftmost via `tabmove 0`; the terminal buffer is renamed to `claude code` so the existing tabline (`lua/tabline.lua`) renders `[claude code]` via its non-file-buffer fallback — no tabline special case.
- Autosave on `TextChanged`/`InsertLeave` for real files.
- Trailing whitespace auto-removal on save (except markdown).
- Right-click context menu with git operations (blame, diff, hunk preview, revert).
- Git commit buffers (`git` filetype and `Gitl`/`Gitlo` git-graph buffers) share local commit keymaps: `K` opens the commit in a tab, `<CR>` opens the commit diff in Diffview, and `r` rewords the commit through Fugitive (`Git commit --amend --only`) only when the cursor hash resolves to `HEAD`.
- Custom statusline showing file path, flags, and git branch.
- Custom winbar (`lua/winbar.lua`) showing the buffer's relative path with modified/readonly flags; skips terminals and special filetypes.
- Custom tabline showing buffer filenames per tab. Diffview tabs are detected by scanning for the `DiffviewFiles`/`DiffviewFileHistory` panel filetypes and shown as a fixed `[DiffviewFiles]`/`[Diffview History]` label instead of the focused diff buffer's name.
- `diffhl` (`lua/diffhl.lua`, self-contained — no query files): treesitter source-language highlighting plus full-width green/red line backgrounds for unified diffs (patch/diff files and fugitive's `git`-filetype `:Git diff`/`:Git show` buffers), like diffview. **Backgrounds:** persistent `line_hl_group` extmarks (`diffhl_linebg` namespace) over `(addition)`/`(deletion)` line nodes, using the theme's `DiffAdd`/`DiffDelete` groups (bg-only, so they track colorscheme switches and let foreground show through), refreshed on `FileType`/`BufWinEnter`/`TextChanged*`. This is the robust part and works everywhere. **Syntax:** the injection query is generated in Lua (`install_query` → `vim.treesitter.query.set`, NOT a `.scm` file) — one pattern per language in `LANGS`, each matching `(context)`/`(addition)`/`(deletion)` line nodes **directly** (the `(hunk (changes …))` nesting is unusable: real git diffs with trailing `@@ … @@` context, blank lines, and `index` lines flatten the tree so change lines become top-level siblings of `block`). Per-file language is routed by the `#diff-file-lang?` predicate against `file_langs[buf]` — a Lua-computed list of `{row, lang}` from each `+++ b/path` header (`vim.filetype.match`); this is why a single combined buffer-language was wrong (a multi-file `:Git show` mixing json+lua corrupted the lua sections by parsing them as json). `#offset! @injection.content 0 1 0 0` strips column 0 (the +/-/space marker); `include-children` makes the offset, not child-exclusion, remove it. **Injection is NON-combined** (one region per line): `injection.combined` parses multi-line constructs better but its range handling cross-contaminates languages (the `0 1 1 0` newline-extension leaks one file's tree into the next) and interleaves old/new lines (flipping keyword↔identifier). Per-line is robust and deterministic — each line parses on its own so complete statements (`local x = 10`) highlight correctly and never corrupt, but structurally-incomplete lines (`function foo()` with no matching `end`, lone `{`) become ERROR nodes and don't highlight, and outer-level JSON keys fall in gaps. Accepted as the honest limit of inline diff highlighting. The query is `query.set` at module load (before any diff parser is created, so the LanguageTree picks it up); `file_langs` is computed in the autocmd and lazily in the predicate, and cleared on `BufWipeout`. `:Gdiffsplit` needs nothing since it uses real file buffers.

**Color-rendering choices:**
- mini.hipatterns' `hex_color` highlighter is customized to render a colored square (virt_text) next to each `#rrggbb` literal instead of recoloring the hex text itself. Per-color hl groups and `extmark_opts` tables are cached, and a ColorScheme autocmd re-registers them after `theme.apply_theme`'s `hi clear`.
- LSP document color is disabled via `client.server_capabilities.colorProvider = nil` in `on_attach` — servers (e.g. lua_ls) paint `LspDocumentColor_<hex>_*` highlights that conflict with the hipatterns approach.

**Known quirks:**
- `LspReferenceTarget` (`highlights.lua`) is only visible on the current symbol; mini.cursorword's matchadd renders on top of LSP extmarks on other occurrences, so those keep the cursorword color. Comment left in-file.
- fidget.nvim caches resolved `Normal`/`FloatBorder` colors in its `fidget-window` namespace and doesn't invalidate on ColorScheme. Notifications show stale colors after a theme switch until nvim restart — investigated and left as-is.
