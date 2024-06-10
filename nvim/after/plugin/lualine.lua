local status_ok, lualine = pcall(function()
  return require("lualine")
end)

if not status_ok then
  return
end

lualine.setup({
  options = {
    theme = "horizon",
    globalstatus = true,
  },
  sections = {
    lualine_b = { "branch", "diff" },
    lualine_c = { "filename" },
    lualine_x = {
      { "filetype", separator = { right = "" }, right_padding = 0 },
    },
    lualine_y = { "diagnostics" },
  },
  winbar = {
    lualine_c = { "filename" },
  },
  extensions = {
    "fugitive",
  },
})
