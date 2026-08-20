-- Add foldingRange capability globally (required by nvim-ufo)
vim.lsp.config("*", {
  capabilities = {
    textDocument = {
      foldingRange = { dynamicRegistration = false, lineFoldingOnly = true },
    },
  },
})

-- Servers needing no extra config
vim.lsp.enable({ "html", "cssls", "ts_ls", "marksman", "cmake" })

-- lua_ls: defaults() already enables it; extend with vim global
vim.lsp.config("lua_ls", {
  settings = { Lua = { diagnostics = { globals = { "vim" } } } },
})

-- pyright
vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = { diagnosticMode = "workspace", typeCheckingMode = "standard" },
    },
  },
})
vim.lsp.enable("pyright")

-- clangd with custom formatting
vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--fallback-style=Google",
    "--format-style={BasedOnStyle: Google, UseTab: Never, IndentWidth: 4, ColumnLimit: 0, BreakBeforeBraces: Allman, AllowShortIfStatementsOnASingleLine: false, AllowShortFunctionsOnASingleLine: None, AllowShortLoopsOnASingleLine: false}",
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cu", "cc", "h", "cuh", "hpp" },
})
vim.lsp.enable("clangd")
