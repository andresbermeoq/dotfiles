local status_ok, which_key = pcall(function()
  return require("which-key")
end)

if not status_ok then
  return
end

vim.o.timeout = true
vim.o.timeoutlen = 300

which_key.setup({})
