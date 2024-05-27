local status_ok, ibl = pcall(function()
  return require("ibl")
end)

if not status_ok then
  return
end

ibl.setup({
  indent = {
    char = "▏",
    highlight = { "Function", "Label" },
    priority = 2,
  },
  scope = {
    show_start = false,
    show_end = false,
  },
})
