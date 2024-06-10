local status_ok, venv_selector = pcall(function()
  return require("venv-selector")
end)
local keymap = vim.keymap

if not status_ok then
  return
end

venv_selector.setup({})

-- keymaps
keymap.set("n", "<leader>v", "<CMD>VenvSelect<CR>", { desc = "Open Python Environments." })
