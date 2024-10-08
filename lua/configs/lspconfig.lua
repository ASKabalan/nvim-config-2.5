local on_attach = require("nvchad.configs.lspconfig").on_attach
local capabilities = require("nvchad.configs.lspconfig").capabilities
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
  }

local lspconfig = require "lspconfig"

-- Servers with default configuration
local servers = { "html", "cssls", "ts_ls", "marksman", "cmake", "lua_ls" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig.lua_ls.setup {
  -- ... other configs
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
}

-- Pyright configuration
lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        diagnosticMode = "workspace",
        typeCheckingMode = "standard",
      },
    },
  },
}

-- Clangd configuration with custom formatting
lspconfig.clangd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    clangd = {
      filetypes = { "c", "cpp", "objc", "objcpp", "cu", "cc", "h", "cuh", "hpp" },
      cmd = {
        "clangd",
        "--fallback-style=Google",
        "--format-style={BasedOnStyle: Google, UseTab: Never, IndentWidth: 4, ColumnLimit: 0, BreakBeforeBraces: Allman, AllowShortIfStatementsOnASingleLine: false, AllowShortFunctionsOnASingleLine: None, AllowShortLoopsOnASingleLine: false}",
      },
    },
  },
}
