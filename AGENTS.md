# AGENTS.md

Personal Neovim config built on **NvChad 2.5** (`branch = "v2.5"` in `init.lua`), tuned for **C++/CUDA and Python** development. Single-user config; also deployed to HPC clusters via SSH.

## Layout

- `init.lua` — bootstrap lazy.nvim, load NvChad base + `plugins` import, theme, mappings, commands. Most tuning lives here too (indentation autocmds, vim-visual-multi keys, folding).
- `lua/plugins/init.lua` — every plugin spec. Custom plugins live here; NvChad's own plugins come from the `NvChad/NvChad` import.
- `lua/configs/*.lua` — per-plugin config, referenced from `plugins/init.lua` via `require "configs.<name>"`.
- `lua/configs/overrides.lua` — `opts` overrides for NvChad-managed plugins (mason, treesitter, nvterm, nvimtree).
- `lua/chadrc.lua` — NvChad UI/theme (`flexoki`).
- `lua/mappings.lua` — keymaps; `lua/commands.lua` — user commands. Both loaded lazily via `vim.schedule` from `init.lua`.
- `opencode-ghost/` — local clone of `muschneider/opencode-ghost.nvim` (not on any registry), **gitignored**. It's a `dir=` plugin whose lazy `build` **self-clones the repo and runs `uv sync` if the directory is missing** — so fresh installs and `:Lazy install` work without manual setup. Update via `git -C ~/.config/nvim/opencode-ghost pull` (the venv + lockfiles live there, not in the repo).
- `.github/README.md` — the real docs: install, VSCode-style mapping tables, LSP usage. `.github/mapping.md` — additional mapping list.
- `setup.sh` — standalone bootstrap: downloads Neovim/ripgrep to `~/.local/tools`, then clones this repo into `~/.config/nvim`. It deletes existing config unless run with `-b` (backup). **No Node install anymore** (was only needed for Copilot). Requires `uv` on PATH (used by uv.nvim and opencode-ghost). Defaults: neovim 0.12.4, ripgrep 15.2.0.

## Commands

- Install/update tools: `bash setup.sh` (flags: `-n` neovim ver, `-r` ripgrep ver, `-b` backup old config, `-f` force redownload).
- `nvim` then `:Lazy install` / `:Lazy sync` / `:Lazy update` for plugins; `:MasonInstallAll` for LSP servers, formatters, debuggers.
- Formatters: `stylua` (lua), `yapf` (python), `clang-format` (c/cpp/cuda) via conform. Format on save is on (`format_on_save`, 500ms).
- Style: follow `.stylua.toml` (120 col, 2-space indent, double quotes, no call parens).
- **opencode-ghost** (Copilot-style ghost text): loads on `InsertEnter`, auto-runs a Python backend via `uv`. Needs an **OpenCode Go subscription**; the key is auto-discovered from `~/.local/share/opencode/auth.json` (no `OPENCODE_API_KEY` env needed). Keybinds are insert-mode Alt+arrows (`<M-Right>` accept, `<M-Down>` accept line, `<M-Up>` suggest, `<M-Left>` dismiss, `<M-S-Right>` accept word). Diagnose with `:checkhealth opencode_ghost` / `:OpencodeGhost status`.

## Gotchas

- **Neovim must be recent.** `lua/configs/lspconfig.lua` uses the native LSP APIs `vim.lsp.config` / `vim.lsp.enable` (Neovim 0.11+), not the old `lspconfig.<server>.setup`. `setup.sh` defaults to 0.12.4. This file also overrides NvChad's `defaults()` on purpose.
- **C++/CUDA LSP (clangd)**: relies on `compile_commands.json` (export via `-DCMAKE_EXPORT_COMPILE_COMMANDS` and symlink to project root), else falls back to the hardcoded Google-style `--format-style`. Header/source switching bound to `<C-q>`.
- **Python**: managed with `uv` + [uv.nvim](https://github.com/benomahony/uv.nvim) (`<leader>x` prefix: run file/selection/function, venv auto-activate, package mgmt). For conda, activate the env before launching nvim. DAP `pythonPath` resolves from `CONDA_PREFIX`, then `./.venv`, else `/usr/bin/python`.
- **DAP**: F5–F12 keys. C++ needs an executable path input (prompted) or gdbserver :1234. debugpy adapter is assumed installed via Mason (`~/.local/share/nvim/mason/packages/debugpy/...`).
- **Folding** uses nvim-ufo; LSPs must advertise `foldingRange` (wired in `lspconfig.lua`). `foldlevel`/`foldlevelstart` are pinned to 99 in `init.lua`.
- **Mason tools** install to `~/.local/share/nvim/mason` (standard Neovim data dir), not under this repo.
- **opencode-ghost default model**: `deepseek-v4-flash` returns HTTP 403 `RegionError` (China-hosted, needs explicit opt-in); the backend falls back to `kimi-k2.6` / `glm-5.1` automatically. Model configurable via the plugin `backend.model` opt or `OPENCODE_GHOST_MODEL`.
- **Git auth**: remote is HTTPS (`ASKabalan/nvim-config-2.5`). Push requires a working credential helper (`gh auth setup-git`) or SSH — plain `git push` fails with a `ksshaskpass` error otherwise.

## Work-in-progress (do not "fix" pre-existing issues unless asked)

- `lua/configs/dap.lua` references `cwd` in the python `pythonPath` function but never defines it — likely buggy, but guarded by an `executable()` check.
- Several mappings in `lua/mappings.lua` are marked NOT WORKING (visual grep/highlight, gitsigns `<C-M-*>`). Some commented-out commands (`commands.lua`) reference the removed hologram plugin.
- `.github/README.md` can drift from `lua/mappings.lua`; trust `mappings.lua` as the source of truth.
- `lazy-lock.json` is regenerated by `:Lazy update`; commit it after plugin updates.