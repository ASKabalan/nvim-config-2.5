local on_attach = require("nvchad.configs.lspconfig").on_attach
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- Servers with default configuration
local servers = { "html", "cssls", "tsserver","marksman","cmake", "lua_ls" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Pyright configuration
lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
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
        "--format-style={BasedOnStyle: Google, UseTab: Never, IndentWidth: 4, ColumnLimit: 0, BreakBeforeBraces: Allman, AllowShortIfStatementsOnASingleLine: false, AllowShortFunctionsOnASingleLine: None, AllowShortLoopsOnASingleLine: false}"
      }
    }
  }
}
