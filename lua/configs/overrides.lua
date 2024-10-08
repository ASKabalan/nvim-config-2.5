local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "python",
    "c",
    "cpp",
    "cuda",
    "markdown",
    "markdown_inline",
    "vimdoc",
  },

  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

M.mason = {
  ensure_installed = {
    -- markdown stuff
    "marksman",
    -- lua stuff
    "lua-language-server",
    "stylua",
    -- python stuff
    "pyright",
    "yapf",
    -- c/cpp stuff
    "clangd",
    "clang-format",
    "debugpy",
    "cmakelint",
    "cpplint",
    "cmake-language-server",
    -- tree-sitter stuff
    "tree-sitter-cli",
  },
}

M.nvterm = {
  terminals = {
    shell = vim.o.shell,
    list = {},
    type_opts = {
      float = {
        relative = "editor",
        row = 0.3,
        col = 0.25,
        width = 0.5,
        height = 0.4,
        border = "single",
      },
      horizontal = { location = "rightbelow", split_ratio = 0.15 },
      vertical = { location = "rightbelow", split_ratio = 0.5 },
    },
  },
  behavior = {
    autoclose_on_quit = {
      enabled = false,
      confirm = true,
    },
    close_on_exit = true,
    auto_insert = true,
  },
}

-- git support in nvimtree
M.nvimtree = {
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = true,
  },
  git = {
    enable = true,
    ignore = false,
  },
  actions = {
    open_file = {
      resize_window = false,
    },
  },
  view = {
    preserve_window_proportions = false,
  },
  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M
