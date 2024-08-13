require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local nomap = vim.keymap.del

-- Functions
function TOGGLE_MOUSE()
  if vim.o.mouse == "a" then
    vim.o.mouse = ""
    vim.cmd "NvimTreeClose"
    vim.wo.number = false
    vim.wo.relativenumber = false
  else
    vim.o.mouse = "a"
    vim.wo.number = true
    vim.wo.relativenumber = false
    vim.cmd "NvimTreeOpen"
  end
end
function TOGGLE_GIT()
  local neogit = require "neogit"
  if neogit.status.started then
    neogit.close()
  else
    neogit.open { kind = "split" }
  end
end

function TOGGLE_SYMBOLES()
  local aerial = require "aerial"
  if aerial.is_open() then
    aerial.close_all()
  else
    aerial.open_all()
  end
end

function TOGGLE_GIT_SYMBOLES()
  local aerial = require "aerial"
  local neogit = require "neogit"
  if aerial.is_open() then
    aerial.close_all()
    neogit.close()
  else
    aerial.open_all()
    vim.cmd "wincmd l"
    neogit.open { kind = "split" }
  end
end

function Highlight_selected_word()
  local current_word = vim.fn.expand "<cword>"
  current_word = vim.fn.escape(current_word, "/\\")
  vim.fn.setreg("/", "\\V" .. current_word)
  vim.cmd "set hlsearch"
  vim.cmd "normal! n"
end

function OpenSpectreWithQuickfix()
  require("spectre").open_file_search { select_word = true }
  vim.cmd "hor copen"
end

function Get_visual_selection()
  vim.cmd 'noau normal! "vy"'
  local text = vim.fn.getreg "v"
  text = text:gsub("\n", ""):gsub("[-[%]{}()*+?.,\\^$|#\\s]", "\\%&")
  return text
end

function Live_grep_current_buffers()
  require("telescope.builtin").live_grep {
    prompt_title = "Live Grep Current Buffers",
    prompt_prefix = "Search: ",
    preview_title = "Preview",
    grep_open_files = true,
    results_title = "Results",
    layout_strategy = "vertical",
    layout_config = {
      preview_width = 0.5,
    },
  }
end

-- Global variable to hold the image object
local holo_image = nil

-- Function to display the image from the current buffer's file path
function Holo_disp()
  local image_path = vim.fn.expand "%"

  if image_path and vim.fn.match(image_path, "\\v\\.png$") ~= -1 then
    -- Get the current buffer
    Holo_del()
    local buf = vim.api.nvim_get_current_buf()

    -- Load the hologram image
    holo_image = require("hologram.image"):new(image_path, {})

    -- Display the image at the center of the buffer
    holo_image:display(1, 0, buf, {})
  else
    print "No valid PNG file detected"
  end
end

-- Function to delete the image immediately
function Holo_del()
  if holo_image then
    holo_image:delete(0, { free = true })
    holo_image = nil
  end
end

-- Autocommands to trigger image display and deletion
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufAdd" }, {
  pattern = { "*.png" },
  callback = function()
    Holo_disp()
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave" }, {
  pattern = { "*.png" },
  callback = function()
    Holo_del()
  end,
})

-- Define a Lua function to execute the command
local function open_frogmouth_terminal()
  vim.cmd "vert terminal frogmouth %"
  vim.cmd "wincmd p"
end

-- Create a Neovim command that calls the Lua function
vim.api.nvim_create_user_command(
  "FrogmouthPreview",
  open_frogmouth_terminal,
  { desc = "Open Frogmouth in a vertical terminal and switch back to previous window" }
)

vim.api.nvim_create_user_command("Quarto", require("quarto").quartoPreview, { desc = "Preview Quarto" })
-- Normal mode mappings
map("n", ";", ":", { desc = "enter command mode", nowait = true })
map("n", "<A-Up>", ":m .-2<CR>==", { desc = "Move line up" })
map("n", "<A-Down>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<C-v>", '"+p', { desc = "Paste from clipboard" })
map("n", "<C-q>", "<cmd>ClangdSwitchSourceHeader<CR>", { desc = "Switch between source and header" })
map("n", "<BS>", 'h""x', { desc = "Delete back character in normal mode" })
map("n", "<Delete>", '""x', { desc = "Delete back character in Visual mode" })
map("n", "<C-a>", "ggVG", { desc = "Select all in normal mode" })
map("n", "<A-a>", "V", { desc = "Select current line in Normal mode" })
map("n", "<C-Z>", "u", { desc = "Undo" })
map("n", "<C-Y>", "<C-R>", { desc = "Redo" })
map("n", "<A-f>", "<cmd>lua require('conform').format()<CR>", { desc = "Format" })
map("n", "<F2>", "<cmd>lua TOGGLE_MOUSE()<CR>", { desc = "Toggle mouse support" })
map("n", "<leader>o", "<cmd>lua TOGGLE_GIT_SYMBOLES()<CR>", { desc = "Symbols & git Outline" })
map("n", "<leader>gs", "<cmd>lua TOGGLE_SYMBOLES()<CR>", { desc = "Symbols Outline" })
map("n", "<leader>gg", "<cmd>lua TOGGLE_GIT()<CR>", { desc = "Git Outline" })
map("n", "<C-S-h>", "<cmd>lua require('spectre').toggle()<CR>", { desc = "Toggle Spectre" })
map("n", "<C-A-h>", "<cmd>lua OpenSpectreWithQuickfix()<CR>", { desc = "Search on current file" })
map("n", "<S-F5>", "<cmd>lua require('dap').reverse_continue()<CR>", { desc = "Reverse !!" })
map("n", "<F5>", "<cmd>lua require('dap').continue()<CR>", { desc = "Continue / Start" })
map("n", "<F6>", "<cmd>lua require('dap').run_last()<CR>", { desc = "Run Last" })
map("n", "<F7>", "<cmd>lua require('dap').down()<CR>", { desc = "Go down stack" })
map("n", "<F8>", "<cmd>lua require('dap').up()<CR>", { desc = "Go up stack" })
map("n", "<F9>", "<cmd>lua require('dap').toggle_breakpoint()<CR>", { desc = "Toggle Breakpoint" })
map("n", "<F10>", "<cmd>lua require('dap').step_over()<CR>", { desc = "Step Over" })
map("n", "<S-F10>", "<cmd>lua require('dap').goto_()<CR>", { desc = "Go to line" })
map("n", "<A-F10>", "<cmd>lua require('dap').run_to_cursor()<CR>", { desc = "Go to line ignore breakpoints" })
map("n", "<F11>", "<cmd>lua require('dap').step_into()<CR>", { desc = "Step Into" })
map("n", "<S-F11>", "<cmd>lua require('dap').step_out()<CR>", { desc = "Step Out" })
map("n", "<F12>", "<cmd>lua require('dap').repl.open()<CR>", { desc = "Open REPL" })
map("n", "<C-3>", "]c", { desc = "Jump to next diff" })
map("n", "<C-1>", "[c", { desc = "Jump to previous diff" })
map("n", "<A-Right>", "<cmd>diffget<CR>", { desc = "Get change from other buffer" })
map("n", "<A-Left>", "<cmd>diffput<CR>", { desc = "Put change to the other buffer" })

-- Insert mode mappings
map("i", "<C-a>", "<Esc>ggVG", { desc = "Select all in Insert mode" })
map("i", "<C-Z>", "<C-O>u", { desc = "Undo" })
map("i", "<C-Y>", "<C-O>:redo<CR>", { desc = "Redo" })
map("i", "<C-S>", "<Esc>:w<CR>a", { desc = "Save in insert mode" })
map("i", "<C-c>", '<C-O>"+y', { desc = "Copy in insert mode" })
map("i", "<C-x>", '<C-O>"+x', { desc = "Cut in insert mode" })
map("i", "<C-v>", "<C-R>+", { desc = "Paste in insert mode" })
map("i", "<A-a>", "<Esc>V", { desc = "Select current line in Normal mode" })
map("i", "<M-Up>", "<Plug>(copilot-suggest)", { desc = "Suggest completion" })
map("i", "<M-Right>", "<Plug>(copilot-accept-line)", { desc = "Accept line suggestion" })
map(
  "i",
  "<M-Down>",
  'copilot#Accept("\\<CR>")',
  { expr = true, replace_keycodes = false, desc = "Accept whole suggestion" }
)
map("i", "<M-Left>", "<Plug>(copilot-dismiss)", { desc = "Dismiss suggestion" })
map("i", "<M-3>", "<Plug>(copilot-next)", { desc = "Next suggestion" })
map("i", "<M-1>", "<Plug>(copilot-previous)", { desc = "Previous suggestion" })

-- Visual mode mappings
map("v", "<Tab>", ">gv", { desc = "indent" })
map("v", "<S-Tab>", "<gv", { desc = "reverse indent" })
map("v", "<A-Up>", ":move '<-2<CR>gv-gv", { desc = "Move text up" })
map("v", "<A-Down>", ":move '>+1<CR>gv-gv", { desc = "Move text down" })
map("v", "<C-A-Up>", ":'<,'>y<CR>:'<-1pu<CR>gv=gv", { desc = "Copy text up" })
map("v", "<C-A-Down>", ":'<,'>y<CR>:pu!<CR>gv=gv", { desc = "Copy text down" })
map("v", "<C-S>", "<cmd>w<CR>", { desc = "Save" })
map("v", "<C-v>", '"_d"+P', { desc = "Paste from clipboard" })
map("v", "<C-c>", '"+y', { desc = "Copy to clipboard" })
map("v", "<C-x>", '"+x', { desc = "Cut to clipboard" })
map("v", "<BS>", 'h""x', { desc = "Delete back character in visual mode" })
map("v", "<Delete>", '""x', { desc = "Delete back character in Visual mode" })
map("v", "<C-a>", "ggVG", { desc = "Select all in visual mode" })
map("v", "<A-a>", "V", { desc = "Select current line in Visual mode" })
map("v", "<C-z>", "u", { desc = "Undo" })
map("v", "<C-y>", "<C-R>", { desc = "Redo" })

-- the next two do not work
-- Additional custom mappings for gitsigns.nvim
map("n", "<C-M-Down>", "<cmd>Gitsigns next_hunk<CR>", { desc = "Next hunk" })
map("n", "<C-M-Up>", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Previous hunk" })
map("n", "<C-M-s>", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
map("n", "<C-M-u>", "<cmd>Gitsigns undo_stage_hunk<CR>", { desc = "Undo Stage hunk" })
map("n", "<C-M-d>", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
map("n", "<C-M-Right>", "<cmd>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
--
-- NOT WORKING REGION
map("v", "<C-S-f>", function()
  local text = Get_visual_selection()
  require("telescope.builtin").live_grep {
    default_text = text,
    prompt_title = "Live Grep Visual Selection",
    prompt_prefix = "Search: ",
    preview_title = "Preview",
    results_title = "Results",
    layout_strategy = "vertical",
    layout_config = {
      preview_width = 0.5,
    },
  }
end, { desc = "Live Grep selection" })
map("v", "<C-h>", function()
  Highlight_selected_word()
end, { desc = "Highlight current selection" })
map("v", "<C-g>", function()
  local text = Get_visual_selection()
  require("telescope.builtin").grep_string {
    search = text,
    prompt_title = "Grep Visual Selection",
    prompt_prefix = "Search: ",
    preview_title = "Preview",
    results_title = "Results",
    layout_strategy = "vertical",
    layout_config = {
      preview_width = 0.5,
    },
  }
end, { desc = "Grep selection" })

-- NOT WORKING REGION

-- Telescope Mappings
map("n", "<C-p>", "<cmd>lua require('telescope.builtin').find_files()<cr>", { desc = "Find all" })
map(
  "n",
  "<C-A-p>",
  "<cmd>lua require('telescope').extensions.file_browser.file_browser({hidden=true})<CR>",
  { desc = "File Browser" }
)
map("n", "<leader>p", "<cmd>lua require('telescope').extensions.projects.projects{}<CR>", { desc = "Find projects" })
map(
  "n",
  "<C-A-f>",
  "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
  { desc = "Live grep" }
)
map("n", "<C-f>", "<cmd>lua require('searchbox').match_all({title='Search'})<CR>", { desc = "Incremental search" })
map(
  "v",
  "<C-f>",
  "<Esc>:lua require('searchbox').incsearch({visual_mode=true})<CR>",
  { desc = "Highlight selected word in Visual Mode" }
)
map("n", "<C-A-o>", "<cmd>lua require('telescope.builtin').oldfiles()<CR>", { desc = "Telescope Oldfiles" })
-- NvimTree Mappings
nomap("n", "<C-n>")
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle nvimtree" })
map("v", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle nvimtree" })

-- Comment Mappings
map("n", "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment" })

map(
  "v",
  "<leader>/",
  "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
  { desc = "Toggle comment in visual mode" }
)

-- Visual mode mappings
map("v", "[", ':<C-u>normal! gv"[i]<Esc>`[f]i[<Esc>`]a]<Esc>', { desc = "Surround selection with [" })
map("v", '"', ':<C-u>normal! gv"[i"<Esc>`[f]i"<Esc>`]a"<Esc>', { desc = 'Surround selection with "' })
map("v", "'", ":<C-u>normal! gv\"[i'<Esc>`[f]i'<Esc>`]a'<Esc>", { desc = "Surround selection with '" })
map("v", "*", ':<C-u>normal! gv"[i*<Esc>`[f]i*<Esc>`]a*<Esc>', { desc = "Surround selection with *" })

-- Remove unnecessary mappings
nomap("n", "<leader>p")
