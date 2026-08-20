# Full IDE Setup

### Note: This is my new NvChad 2.5 compatible config

This is my Neovim setup that I use mainly to write C++/CUDA and Python software. It includes a VSCode-like search textbox, a complete set of syntax highlighting, auto-complete and linters for C++/CUDA and Python using Clang and Pyright, git integration, symbol windows, etc. It also includes AI ghost-text autocompletion (via [opencode-ghost](https://github.com/muschneider/opencode-ghost.nvim), powered by your OpenCode Go subscription), `uv`-native Python tooling (via [uv.nvim](https://github.com/benomahony/uv.nvim)) and the DAP extension that allows debugging Python and C++ code.

### Main Usage

- **Programming Languages**: Python and CUDA/C++ programming.
- **Environment**: Locally and through an SSH tunnel on HPC clusters.

### Terminal Recommendation

I highly recommend using [Kitty](https://sw.kovidgoyal.net/kitty) since it has a very good graphical protocol and can render images even on a remote server in an SSH connection. Follow the provided in the [FAQ](https://sw.kovidgoyal.net/kitty/conf/#fonts) to get Nerd Fonts, which will render the icons inside your terminal.

### Installation

This script installs (from scratch) all the necessary tools to run Neovim (Neovim itself and Ripgrep). Python is managed with [`uv`](https://github.com/astral-sh/uv), which the config also uses for LSP/formatting tooling (via Mason) and for AI ghost-text autocompletion.

#### Before Installing

1. Install [uv](https://docs.astral.sh/uv/) (needed by `uv.nvim` and `opencode-ghost`):
   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```
   or `pip install uv`.
2. (Optional) Log in to opencode with your **OpenCode Go** subscription to enable AI ghost-text autocompletion. The key is auto-discovered from `~/.local/share/opencode/auth.json` — no environment variables needed.

#### To Install

```bash
# Then run the installer
bash <(curl -s https://raw.githubusercontent.com/ASKabalan/nvim-config-2.5/main/setup.sh)
```
You can specify which Ripgrep or Neovim version to use:
```bash
bash <(curl -s https://raw.githubusercontent.com/ASKabalan/nvim-config-2.5/main/setup.sh) -n 0.12.4 -r 15.2.0 -b
```
or
```bash
bash <(curl -s https://raw.githubusercontent.com/ASKabalan/nvim-config-2.5/main/setup.sh) --neovim 0.12.4 --ripgrep 15.2.0 --backup
```
- `backup`: Backup previous Neovim and NvChad configs instead of overriding them.

#### After Installation

After installation, you can open Neovim and run `:Lazy install` to install all the plugins. If you want to install the LSP servers, formatters, debuggers, etc., run `:MasonInstallAll`.

It installs the tools to `$HOME/.local/tools` and NvChad and my custom config to `$HOME/.config/nvim`. Then all LSP servers, formatters, debuggers, etc., will be installed in `$HOME/.local/nvim/share`. On first launch, `:Lazy install` pulls all plugins — including `opencode-ghost`, whose Python backend is set up automatically with `uv sync`.

If you are limited in space in the `$HOME` folder (which is the case for some HPC servers), make a symbolic link (to opt or a folder with a lot of space):
```bash
mkdir /opt/.local
ln -s /opt/.local $HOME/.config/nvim
```

### Uninstallation

Just delete the installed tools and configs:
```bash
rm -rf $HOME/.local/tools/ripgrep
rm -rf $HOME/.local/tools/nvim
rm -rf $HOME/.local/nvim/share
rm -rf $HOME/.config/nvim
```
And remove these lines from `.bashrc`:
```bash
# <<< Init nvim >>>
export PATH=$HOME/.local/tools/nvim/bin:$PATH
# <<< Init ripgrep >>>
export PATH=$HOME/.local/tools/ripgrep:$PATH
```

### Updating

You can update the configs using `Lazy` by running command in neovim:
```bash
:Lazy sync
:Lazy update
```

or just run the installer again: (WARNING : it will delete your configs and install the new ones)

# Why Neovim and Not VSCode

Some HPC clusters do not allow VSCode SSH remote extension, which means that we either have to use JupyterLab notebooks (💀) or use VSCode in a browser (🥵).

One can consider [sshfs](https://github.com/libfuse/sshfs)), but with a weak connection, this is an actual nightmare and can even freeze my Intel i9 laptop.

Plus, Vim makes you cooler. 😎

![@credit:Vim-memes](https://raw.githubusercontent.com/kuator/Vim-memes/master/they-dont-know.png)
*@credit:Vim-memes*

---

### Mappings and Shortcuts

in nvim lingo `leader` is `Space` and `meta` or `M` is `Alt`.

#### Basic Stuff

| Action                   | VSCode                  | My IDE                                | Plugin / Function          |
|--------------------------|-------------------------|---------------------------------------|----------------------------|
| Copy/Paste/Cut/Backspace | Same as VSCode          | Same                                  | -                          |
| Move Line Up             | Alt+Up                  | Alt+Up                                | -                          |
| Move Line Down           | Alt+Down                | Alt+Down                              | -                          |
| Copy Line Down/Up        | Ctrl+Alt+Down/Up        | Ctrl+Alt+Down/Up                      | -                          |
| Undo/Redo                | Ctrl+Z / Ctrl+Y         | Ctrl+Z / Ctrl+Y                       | -                          |
| Select All               | Ctrl+A                  | Ctrl+A                                | -                          |
| Comment Line             | Ctrl+/                  | <leader> /                            | nvim-comment.nvim          |
| Indent/Unindent          | Tab / Shift+Tab         | Tab / Shift+Tab                       | -                          |
| Open terminal(horizontal)| GUI                     | <leader> h                            | nvim-terminal.nvim         |
| Open terminal(vertical)  | GUI                     | <leader> v                            | nvim-terminal.nvim         |
| Split Window horizontal  | GUI                     | :sp                                   | -                          |
| Split Window vertical    | GUI                     | :vsp                                  | -                          |

#### Search Stuff

| Action            | VSCode                   | My IDE                         | Plugin / Function           |
|-------------------|--------------------------|--------------------------------|-----------------------------|
| Search Box        | Ctrl+F                   | Ctrl+F                         | searchbox.nvim              |
| Search and Replace| Ctrl+Shift+H             | Ctrl+Shift+H                   | spectre.nvim                |
| Open Files        | Ctrl+P                   | Ctrl+P                         | telescope.nvim              |
| Search with Args  | Ctrl+Alt+F               | Ctrl+Alt+F                     | telescope.nvim + ripgrep    |

#### Formatting

| Action      | VSCode           | My IDE         | Plugin / Function  |
|-------------|------------------|----------------|---------------------|
| Formatting  | Alt+Shift+F      | Alt+F          | conform.nvim        |

#### Debugging

| Action        | VSCode               | My IDE        | Plugin / Function   |
|---------------|----------------------|---------------|---------------------|
| Start/Continue| F5                   | F5            | dap.nvim            |
| Stop          | Shift+F5             | Shift+F5      | dap.nvim            |
| Step Over     | F10                  | F10           | dap.nvim            |
| Step Into     | F11                  | F11           | dap.nvim            |
| Step Out      | Shift+F11            | Shift+F11     | dap.nvim            |

#### Git Integration

| Action                 | VSCode                       | My IDE                             | Plugin / Function  |
|------------------------|------------------------------|------------------------------------|--------------------|
| Open Git +Symbols      | GUI                          | Space + O                          | aerial.nvim        |
| Staging File           | GUI with + signs and arrows  | s                                  | Neogit.nvim        |
| Undo Stage             | GUI                          | u                                  | Neogit.nvim        |
| Discard                | GUI                          | x                                  | Neogit.nvim        |
| Diff View              | GUI                          | :DiffViewOpen                      | DiffView.nvim      |
| Next Hunk              | GUI                          | Ctrl+Alt+Down                      | gitsign.nvim       |
| Previous Hunk          | GUI                          | Ctrl+Alt+Up                        | gitsign.nvim       |
| Stage Hunk             | GUI                          | Ctrl+Alt+S                         | gitsign.nvim       |
| Unstage Hunk           | GUI                          | Ctrl+Alt+U                         | gitsign.nvim       |
| Discard Hunk           | GUI                          | Ctrl+Alt+D                         | gitsign.nvim       |

#### AI Autocomplete (opencode-ghost)

Ghost-text suggestions (Copilot-style) powered by your OpenCode Go subscription. Backend starts automatically on insert; model falls back to `kimi-k2.6` / `glm-5.1` if the primary is unavailable. Diagnose with `:checkhealth opencode_ghost`.

| Action         | My IDE              | Plugin / Function      |
|----------------|---------------------|------------------------|
| Accept all     | Alt+Right           | opencode-ghost         |
| Accept line    | Alt+Down            | opencode-ghost         |
| Accept word    | Alt+Shift+Right     | opencode-ghost         |
| Request suggest| Alt+Up              | opencode-ghost         |
| Dismiss        | Alt+Left            | opencode-ghost         |

---

### Using LSP Servers, Autocomplete, and Syntax Highlighting

#### Using Python LSP

Python is managed with [`uv`](https://github.com/astral-sh/uv), and [uv.nvim](https://github.com/benomahony/uv.nvim) gives you project init, venv auto-activation, package management and "run code from inside the editor" — all from Neovim. `uv.nvim` auto-activates the project's `.venv` on open, so `pyright` and the DAP pick up the right interpreter automatically.

```bash
cd /path/to/myproject
uv init --python 3.12        # one-time project setup (creates pyproject.toml + .venv)
uv add numpy pandas          # install deps
nvim
```

Inside Neovim, `uv.nvim` provides (all under `<leader>x`, requires the picker integration):

| Keymap           | Command               | Action                         |
|------------------|-----------------------|--------------------------------|
| `<leader>x`      | `:UV`                 | Show uv commands menu          |
| `<leader>xr`     | `:UVRunFile`          | Run current file               |
| `<leader>xs`     | `:UVRunSelection`     | Run selected code (visual)     |
| `<leader>xf`     | `:UVRunFunction`      | Run a function from the file   |
| `<leader>xe`     |                       | Environment management         |
| `<leader>xi`     | `:UVInit`             | Initialize a uv project        |
| `<leader>xa`     |                       | Add a package                  |
| `<leader>xd`     |                       | Remove a package               |
| `<leader>xc`     |                       | Sync packages                  |

If you prefer conda/micromamba, activate the environment before starting Neovim:
```bash
cd /path/to/myproject
conda activate myenv
nvim
```

By default it uses `pyright` as the LSP server for Python. You can change it in the [lspconfig.lua](../lua/configs/lspconfig.lua).

Also `conform` uses `yapf` as the default formatter. You can change it in the [conform.lua](../lua/configs/conform.lua) file.

#### Using C++ / CUDA LSP

##### Using CMake

Make sure that you compile with the `CMAKE_EXPORT_COMPILE_COMMANDS` option. Then link the generated file in the root directory:

```bash
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS
ln -s build/compile_commands.json .
```

By default it uses `clangd` as the LSP server and `clang-format` as the formatter. You can change it in the [lspconfig.lua](../lua/configs/lspconfig.lua) and [conform.lua](../lua/configs/conform.lua) files.
### Using Mason

Mason is a package manager for Neovim that installs LSP servers, formatters, debuggers, etc. It is used to install the necessary tools for the IDE.
It is actually something that VSCode does terribly and it much easier to do with Neovim.

To see available packages: `:Mason`

To install one or more packages: `:MasonInstall <package1> <package2> ...`

for example if you want to use `Black` as the Python formatter, you first add it to [conform.lua](../lua/configs/conform.lua) then run `:MasonInstall black`
