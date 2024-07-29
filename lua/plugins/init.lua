local overrides = require "configs.overrides"

return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "nvchad.configs.lspconfig"
      require "configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },
  {
    "NvChad/nvterm",
    opts = overrides.nvterm,
  },
  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").load_extension "file_browser"
    end,
    lazy = false,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").load_extension "ui-select"
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      },
    },
    config = function()
      local telescope = require "telescope"
      local lga_actions = require "telescope-live-grep-args.actions"

      telescope.setup {
        extensions = {
          live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
            -- define mappings, e.g.
            mappings = { -- extend mappings
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-i>"] = lga_actions.quote_prompt { postfix = " --iglob " },
              },
            },
            -- ... also accepts theme settings, for example:
            theme = "dropdown", -- use dropdown theme
            -- theme = { }, -- use own theme spec
            -- layout_config = { mirror=true }, -- mirror preview pane
          },
        },
      }

      require("telescope").load_extension "live_grep_args"
    end,
  },
  {
    "MunifTanjim/nui.nvim",
  },
  {
    "VonHeikemen/searchbox.nvim",
    requires = {
      { "MunifTanjim/nui.nvim" },
    },
    config = function()
      require("searchbox").setup {
        defaults = {
          reverse = false,
          exact = false,
          prompt = " ",
          modifier = "disabled",
          confirm = "off",
          clear_matches = true,
          show_matches = false,
        },
        popup = {
          relative = "win",
          position = {
            row = "5%",
            col = "95%",
          },
          size = 30,
          border = {
            style = "rounded",
            text = {
              top = " Search ",
              top_align = "left",
            },
          },
          win_options = {
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          },
        },
        hooks = {
          before_mount = function(input)
            -- code
          end,
          after_mount = function(input)
            local opts = { buffer = input.bufnr }

            -- Go to the next match
            vim.keymap.set("i", "<C-Right>", "<Plug>(searchbox-next-match)", opts)
            -- Go to the previous match
            vim.keymap.set("i", "<C-Left>", "<Plug>(searchbox-prev-match)", opts)
          end,
          on_done = function(value, search_type)
            -- code
          end,
        },
      }
    end,
  },
  {
    "mg979/vim-visual-multi",
    branch = "master",
    lazy = false,
  },
  {
    "github/copilot.vim",
    lazy = false,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      show_help = "yes", -- Show help text for CopilotChatInPlace, default: yes
      debug = false, -- Enable or disable debug mode, the log file will be in ~/.local/state/nvim/CopilotChat.nvim.log
      disable_extra_info = "no", -- Disable extra information (e.g: system prompt) in the response.
      -- proxy = "socks5://127.0.0.1:3000", -- Proxies requests via https or socks.
    },
    build = function()
      vim.notify "Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim."
    end,
    event = "VeryLazy",
    keys = {
      { "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
      { "<leader>cct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
      {
        "<leader>ccv",
        ":CopilotChatVisual",
        mode = "x",
        desc = "CopilotChat - Open in vertical split",
      },
      {
        "<leader>ccx",
        ":CopilotChatInPlace<cr>",
        mode = "x",
        desc = "CopilotChat - Run in-place code",
      },
    },
    lazy = false,
  },
  {
    "sindrets/diffview.nvim",
  },
  {
    "stevearc/aerial.nvim",
    config = function()
      require "configs.aerial"
    end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = true,
  },
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup()
      require("telescope").load_extension "projects"
    end,
    lazy = false,
  },
  {
    "dstein64/nvim-scrollview",
    config = function()
      require("scrollview").setup()
    end,
    lazy = false,
  },
  {
    "nvim-pack/nvim-spectre",
    branch = "master",
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      require "configs.dap"
    end,
    branch = "master",
  },
  {
    "rcarriga/nvim-dap-ui",
    config = function()
      require "configs.dapui"
    end,
    requires = { "mfussenegger/nvim-dap" },
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
  {
    "mechatroner/rainbow_csv",
    config = function()
      vim.g.disable_rainbow_hover = 1
    end,
    lazy = false,
  },
  {
    "fei6409/log-highlight.nvim",
    config = function()
      require("log-highlight").setup {}
    end,
  },
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "edluffy/hologram.nvim",
    config = function()
      require("hologram").setup {
        auto_display = true, -- WIP automatic markdown image display, may be prone to breaking
      }
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },
}
