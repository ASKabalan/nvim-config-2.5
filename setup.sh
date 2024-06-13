#!/bin/bash

# Default versions
DEFAULT_NEOVIM_VERSION="0.9.5"
DEFAULT_NODE_VERSION="v20.14.0"
DEFAULT_RIPGREP_VERSION="14.1.0"

# Default backup flag
DEFAULT_BACKUP=false
FORCE_REDOWNLOAD=false
# Set defaults
NEOVIM_VERSION=$DEFAULT_NEOVIM_VERSION
NODE_VERSION=$DEFAULT_NODE_VERSION
RIPGREP_VERSION=$DEFAULT_RIPGREP_VERSION
BACKUP_FLAG=$DEFAULT_BACKUP

while getopts ":n:v:r:b:f" opt; do
  case $opt in
    n)  
      NEOVIM_VERSION=$OPTARG
      ;;
    v)
      NODE_VERSION=$OPTARG
      ;;
    r)
      RIPGREP_VERSION=$OPTARG
      ;;
    b)
      BACKUP_FLAG=true
      ;;
    f)
      FORCE_REDOWNLOAD=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Function to check if a command is available
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Backup function
backup() {
  if [ "$BACKUP_FLAG" = true ]; then
    echo "Backing up existing Neovim setup..."
    mv ~/.local/nvim/share ~/.local/nvim/share.old
    mv ~/.config/nvim ~/.config/nvim.old
  else
    echo "Deleting existing Neovim setup..."
    rm -rf ~/.local/share/nvim
    rm -rf ~/.config/nvim
  fi
}

mkdir -p /tmp/nvim-code-download
# Install Neovim
echo "==================================="
echo "Installing Neovim..."
echo "==================================="
if ! command -v nvim &> /dev/null || [ "$FORCE_REDOWNLOAD" = true ]
then
  NVIM_DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/v0.10.0/nvim-linux64.tar.gz"
  echo "Downloading Neovim from $NVIM_DOWNLOAD_URL..."
  wget $NVIM_DOWNLOAD_URL -P /tmp/nvim-code-download
  rm -rf ~/.local/tools/nvim
  mkdir -p ~/.local/tools/nvim
  echo "Extracting Neovim..."
  tar -xzf /tmp/nvim-code-download/nvim-linux64.tar.gz --strip-components=1 -C ~/.local/tools/nvim
  rm /tmp/nvim-code-download/nvim-linux64.tar.gz
  echo "# <<< Init nvim >>>" >> ~/.bashrc
  echo "export PATH=\$HOME/.local/tools/nvim/bin:\$PATH" >> ~/.bashrc
  export PATH=$HOME/.local/tools/nvim/bin:$PATH
  echo "Neovim is installed at path ~/.local/tools/nvim/bin/."
else
  echo "Neovim is already installed."
  echo "it's path is $(which nvim)."
fi

# Install Node.js
echo "==================================="
echo "Installing Node.js..."
echo "==================================="
if ! command -v node &> /dev/null || [ "$FORCE_REDOWNLOAD" = true ]
then
  NODE_DOWNLOAD_URL="https://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION-linux-x64.tar.xz"
  echo "Downloading Node.js from $NODE_DOWNLOAD_URL..."
  wget $NODE_DOWNLOAD_URL -P /tmp/nvim-code-download
  rm -rf ~/.local/tools/node
  mkdir -p ~/.local/tools/node
  echo "Extracting Node.js..."
  tar -xJf /tmp/nvim-code-download/node*.tar.xz --strip-components=1 -C ~/.local/tools/node
  rm /tmp/nvim-code-download/node*.tar.xz
  echo "# <<< Init node >>>" >> ~/.bashrc
  echo "export PATH=\$HOME/.local/tools/node/bin:\$PATH" >> ~/.bashrc
  export PATH=$HOME/.local/tools/node/bin:$PATH
  echo "Node is installed at path ~/.local/tools/node/bin/."
else
  echo "Node is already installed."
  echo "it's path is $(which node)."
fi

# Install ripgrep
echo "==================================="
echo "Installing ripgrep..."
echo "==================================="
if ! command -v rg &> /dev/null || [ "$FORCE_REDOWNLOAD" = true ]
then
  RIPGREP_DOWNLOAD_URL="https://github.com/BurntSushi/ripgrep/releases/download/$RIPGREP_VERSION/ripgrep-$RIPGREP_VERSION-x86_64-unknown-linux-musl.tar.gz"
  echo "Downloading ripgrep from $RIPGREP_DOWNLOAD_URL..."
  wget $RIPGREP_DOWNLOAD_URL -P /tmp/nvim-code-download
  rm -rf ~/.local/tools/ripgrep
  mkdir -p ~/.local/tools/ripgrep
  echo "Extracting ripgrep..."
  tar -xzf /tmp/nvim-code-download/ripgrep-*.tar.gz --strip-components=1 -C ~/.local/tools/ripgrep
  rm /tmp/nvim-code-download/ripgrep-*.tar.gz
  echo "# <<< Init ripgrep >>>" >> ~/.bashrc
  echo "export PATH=\$HOME/.local/tools/ripgrep:\$PATH" >> ~/.bashrc
  export PATH=$HOME/.local/tools/ripgrep:$PATH
  echo "Ripgrep is installed at path ~/.local/tools/ripgrep/."
else
  echo "Ripgrep is already installed."
  echo "it's path is $(which rg)."
fi

rm -fr /tmp/nvim-code-download
# If user wants to back up then back otherwise delete ~/.local/nvim/share and ~/.config/nvim
backup

# Install NvChad and custom parameters
echo "==================================="
echo "Installing NvChad and custom parameters..."
echo "==================================="
git clone -b v2.0 https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
git clone https://github.com/ASKabalan/my-nvim-config ~/.config/nvim/lua/custom --depth 1
nvim
