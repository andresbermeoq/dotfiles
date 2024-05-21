local status_ok, blame_line = pcall(function()
  return require("blame_line")
end)

if not status_ok then
  return
end

blame_line.setup({})
