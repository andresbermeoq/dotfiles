local status_ok, noice = pcall(function()
  return require("noice")
end)

if not status_ok then
  return
end

noice.setup({})
