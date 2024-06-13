require("aerial").setup({
    -- from https://github.com/stevearc/aerial.nvim?tab=readme-ov-file#options
    layout = {
      max_width = { 80, 0.2 },
      width = 80,
      min_width = 10,
            win_opts = {},
      default_direction = "prefer_right",
      placement = "window",
      resize_to_content = true,
      preserve_equality = false,
    },
    -- optionally use on_attach to set keymaps when aerial has attached to a buffer
    on_attach = function(bufnr)
      vim.keymap.set("n", "<C-3>", "<cmd>AerialPrev<CR>", { buffer = bufnr })
      vim.keymap.set("n", "<C-1>", "<cmd>AerialNext<CR>", { buffer = bufnr })
    end,
  })