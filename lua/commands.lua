-- Define functions
local function TOGGLE_MOUSE()
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

local function TOGGLE_GIT_SYMBOLES()
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


-- Function to delete the image immediately
local holo_image = nil

local function Holo_del()
  if holo_image then
    holo_image:delete(0, { free = true })
    holo_image = nil
  end
end

-- Function to display the image from the current buffer's file path
local function Holo_disp()
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

-- Register each command
vim.api.nvim_create_user_command("Mouse", TOGGLE_MOUSE, { desc = "Toggle mouse mode and related UI elements" })

vim.api.nvim_create_user_command("ToggleGit", TOGGLE_GIT_SYMBOLES, { desc = "Toggle Git and Symbols" })

vim.api.nvim_create_user_command("FoldAll", function()
  require("ufo").closeAllFolds()
end, { desc = "Fold all" })

vim.api.nvim_create_user_command("UnfoldAll", function()
  require("ufo").openAllFolds()
end, { desc = "Unfold all" })

vim.api.nvim_create_user_command("FrogmouthPreview", function()
  vim.cmd "vert terminal frogmouth %" -- Open Frogmouth in a vertical terminal
  vim.cmd "wincmd p" -- Switch back to the previous window
end, { desc = "Open Frogmouth in a vertical terminal and switch back to previous window" })

local nabla_activated = false
vim.api.nvim_create_user_command("Nabla", function()
  if nabla_activated then
    require("nabla").disable_virt()
    nabla_activated = false
  else
    require("nabla").enable_virt()
    nabla_activated = true
  end
end, { desc = "Toggle Nabla" })

vim.api.nvim_create_user_command("Quarto", require("quarto").quartoPreview, { desc = "Preview Quarto" })

