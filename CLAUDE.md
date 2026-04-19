# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Neovim configuration targeting Neovim 0.12+. All configuration is in Lua. No build/test/lint commands — changes are validated by restarting Neovim.

**Keep this file current:** when editing code that changes a feature, convention, or architectural detail documented here, update the corresponding section in this file as part of the same change.

## Architecture

**Entry point:** `init.lua` loads modules in this order: `custom` (globals/utils) -> `defaults` (vim options/autocmds) -> `keymaps` -> `menu` (right-click popup) -> colorscheme -> `plugin_spec` (lazy.nvim) -> `qfpersist` -> `statusline` -> `tabline` -> `claudecode`.

**Global state:** `G` (global table with `utils` and `log`), `L` (language-specific storage), `PopUpMenu` (right-click menu functions). These are set in `lua/custom.lua` and available everywhere.

**Plugin management:** lazy.nvim with all specs defined inline in `lua/plugin_spec.lua`. Each plugin's config lives in `lua/plugins/<name>.lua`. Plugins skip loading when Neovim is used as a manpager.

**Theme system:** Custom colorscheme in `colors/custom.lua` that calls `lua/theme.lua`. Palette files in `lua/palette/` (`vague` and `sonokai_shusia` for dark, `onelight` and `grey` for light — `onedark` is the spec-shape donor that `onelight` reuses) are **color tables only** — no highlight logic. All base highlight groups live in a single flat file `lua/highlights.lua`, clustered semantically (alphabetical inside each cluster). Each group is either per-palette (`{ vague = {...}, onedark = {...}, sonokai_shusia = {...}, grey = {...} }` — `onelight` reuses the `onedark` spec shape with `onelight` colors) or palette-agnostic (any table without palette keys, e.g. `{ link = "Search" }` or `{ reverse = true }`). Spec values that are strings matching a palette key resolve to that color; literals (`"none"`, `"#aabbcc"`), booleans, numbers, and `link` pass through unchanged. On each `apply_theme`: `hi clear` runs first (no stale highlights across theme switches), a drift assertion fires if any group is missing one of the required palette variants, and the `highlights` module cache is invalidated so edits land without an nvim restart. Plugin highlights are centralized in `lua/plugin_highlights.lua`, which uses the same table shape as `lua/highlights.lua` (per-group palette variants). `theme.lua` applies both tables on each theme switch and runs the same drift assertion across them. Adding a new palette only needs edits to `lua/palette/<name>.lua`, `lua/highlights.lua`, `lua/plugin_highlights.lua`, and `lua/theme.lua` — plugin configs under `lua/plugins/` stay untouched. The active schemes are selected by `colorscheme.dark` / `colorscheme.light` in `lua/theme.lua`.

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
