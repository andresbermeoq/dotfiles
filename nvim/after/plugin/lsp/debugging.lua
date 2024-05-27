local status_ok, python_dap, dap, dapui = pcall(function()
  return require("dap-python"), require("dap"), require("dapui")
end)

local keymap = vim.keymap

if not status_ok then
  return
end

python_dap.setup("python", {})

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint." })
keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue the debug." })
