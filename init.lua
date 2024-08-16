vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
  require "commands"
end)

-- Function to set indentation
local function set_indentation()
  vim.opt.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for
  vim.opt.shiftwidth = 2 -- Size of an indent
  vim.opt.expandtab = true -- Use spaces instead of tabs
  vim.opt.smartindent = false -- Insert indents automatically
end

-- Set indentation for specific filetypes
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "python", "c", "cpp", "cuda" },
  callback = set_indentation,
})

vim.g.VM_default_mappings = 0
vim.g.VM_use_first_cursor_in_line = 1
vim.g.VM_maps = {
  ["Find Under"] = "<C-d>",
  ["Find Subword Under"] = "<C-d>",
  ["Select Cursor Down"] = "<C-Down>",
  ["Select Cursor Up"] = "<C-Up>",
  ["Add Cursor At Pos"] = "<A-e>",
  ["Move Right"] = "<M-S-Right>",
  ["Move Left"] = "<M-S-Left>",
}

vim.g.copilot_no_tab_map = true

vim.g.syntastic_auto_jump = 0

vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
