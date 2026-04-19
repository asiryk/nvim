# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Neovim configuration targeting Neovim 0.12+. All configuration is in Lua. No build/test/lint commands — changes are validated by restarting Neovim.

**Keep this file current:** when editing code that changes a feature, convention, or architectural detail documented here, update the corresponding section in this file as part of the same change.

## Architecture

**Entry point:** `init.lua` loads modules in this order: `custom` (globals/utils) -> `defaults` (vim options/autocmds) -> `keymaps` -> `menu` (right-click popup) -> colorscheme -> `plugin_spec` (lazy.nvim) -> `qfpersist` -> `statusline` -> `tabline` -> `claudecode`.

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
- Custom statusline showing file path, flags, and git branch.
- Custom tabline showing buffer filenames per tab.

**Color-rendering choices:**
- mini.hipatterns' `hex_color` highlighter is customized to render a colored square (virt_text) next to each `#rrggbb` literal instead of recoloring the hex text itself. Per-color hl groups and `extmark_opts` tables are cached, and a ColorScheme autocmd re-registers them after `theme.apply_theme`'s `hi clear`.
- LSP document color is disabled via `client.server_capabilities.colorProvider = nil` in `on_attach` — servers (e.g. lua_ls) paint `LspDocumentColor_<hex>_*` highlights that conflict with the hipatterns approach.

**Known quirks:**
- `LspReferenceTarget` (`highlights.lua`) is only visible on the current symbol; mini.cursorword's matchadd renders on top of LSP extmarks on other occurrences, so those keep the cursorword color. Comment left in-file.
- fidget.nvim caches resolved `Normal`/`FloatBorder` colors in its `fidget-window` namespace and doesn't invalidate on ColorScheme. Notifications show stale colors after a theme switch until nvim restart — investigated and left as-is.
