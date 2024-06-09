local status_ok, venv_selector = pcall(function()
  return require("venv-selector")
end)
local keymap = vim.keymap

if not status_ok then
  return
end

venv_selector.setup({ stay_on_this_version = true })

-- keymaps
keymap.set("n", "<leader>v", "<cmd>VenvSelect<cr>", { desc = "Open Python Environments." })
