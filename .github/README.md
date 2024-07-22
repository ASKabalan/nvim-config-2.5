
# Full IDE 

__note__: This is my new nvchad 2.5 compatible config

This is my neovim setup that I use mainly to write C++/cuda and python software.
It includes a vscode-like search textbox, a complete set of syntax highlighting, auto-complete and linters for c++/cuda and python using clang and Python Language Server, git integration, symbole windows etc ...
It also includes github-copilot, and the DAP extension that allows debugging python and c++ code.

To see a -almost- full list of [my mappings](mappings.md) 

# Installation

This script installs (from scratch) all the necessary tools to run a Neovim setup with an almost vscode-like shortcut experience (Neovim itself, Node.js for Copilot, and Ripgrep).

Before installing make sure that a python environment is activated\
doesn't matter which version and what packages it has, it will be used by the `MasonInstaller` extension to install LSP servers, formatters, debuggers etc ..

To install 

```bash
# activate some env
conda activate some_venv
# or using venv
source some_venv/bin/activate
```
Then run the installer 

```bash
bash <(curl -s https://raw.githubusercontent.com/ASKabalan/nvim-config-2.5/main/setup.sh)
```

you can specify which node,ripgrep or neovim version to use

```bash
bash <(curl -s https://raw.githubusercontent.com/ASKabalan/nvim-config-2.5/main/setup.sh)  -n 0.9.5 -v v20.11.1 -r 14.1.0 -b
```
or

```bash
bash <(curl -s https://raw.githubusercontent.com/ASKabalan/nvim-config-2.5/main/setup.sh) --neovim 0.9.5 --node v20.11.1 --ripgrep 14.1.0 --backup
```

**backup :**  backup previous neovim and nvchad configs instead of overriding them

It installs the tools to `$HOME/.local/tools`
and Nvchad and my custom config to `$HOME/.config/nvim`
Then all LSP servers, formatters, debuggers etc .. will be installed in `$HOME/.local/nvim/share`

If you are limited in space in the $HOME folder then make a symbolic link (to opt or a folder with a lot of space)

```bash
mkdir /opt/.local
ln -s /opt/.local $HOME/.config/nvim
```

# Uninstallation

Just delete the installed tools and configs :

```bash
rm -rf $HOME/.local/tools/node
rm -rf $HOME/.local/tools/ripgrep
rm -rf $HOME/.local/tools/nvim
rm -rf $HOME/.local/nvim/share
rm -rf $HOME/.config/nvim
```
And remove these lines from .bashrc

```bash
# <<< Init nvim >>>
export PATH=$HOME/.local/tools/nvim/bin:$PATH
# <<< Init node >>>
export PATH=$HOME/.local/tools/node/bin:$PATH
# <<< Init ripgrep >>>
export PATH=$HOME/.local/tools/ripgrep:$PATH
```

# Using LSP servers, autocomplete and syntax highlighting

## Using Python LSP

Make sure then before you start `nvim` that the correct python environment is activated 

for example

```bash
cd /path/to/myproject
# Using venv
source venv/bin/activate
# or conda/micromamba
conda activate myenv
nvim
```


## Using C++ / cuda LSP

### Using CMake

Make sure that you compile with `CMAKE_EXPORT_COMPILE_COMMANDS` option (no need to do it before neovim)
Then link the generated file in the root directory

```bash
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS
ln -s build/compile_commands.json .
```

### Using bazel

It has to be done using https://github.com/hedronvision/bazel-compile-commands-extractor
I haven't been able to do it yet for JAX and XLA

# Using Copilot

WIP

# Using Debuggers

WIP

## For Python

## For C++ and cuda

## For Jupyter notebook

Alot of solutions exists, all very difficult to put in place.

I recommend using https://euporie.readthedocs.io instead
