local status_ok, trouble = pcall(function()
  return require("trouble")
end)
local keymap = vim.keymap

if not status_ok then
  return
end

keymap.set("n", "<leader>xx", trouble.toggle, { desc = "Open/Close trouble list." })
