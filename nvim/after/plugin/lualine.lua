local status_ok, lualine = pcall(function()
  return require("lualine")
end)

if not status_ok then
  return
end

local function attached_clients()
  return "(" .. vim.tbl_count(vim.lsp.get_active_clients()) .. ")"
end

local function cwd()
  return vim.fn.fnamemodify(vim.loop.cwd(), ":~")
end

lualine.setup({
  options = {
    globalstatus = true,
  },
  sections = {
    lualine_b = { "branch", "diff", cwd },
    lualine_c = { { "filename", file_status = true, path = 1 } },
    lualine_x = {
      { "diagnostics", sources = { "nvim_diagnostic" } },
      "filesize",
      "encoding",
      { "filetype", separator = { right = "" }, right_padding = 0 },
      { attached_clients, separator = { left = "" }, left_padding = 0 },
    },
  },
  winbar = {
    lualine_c = { "filename" },
  },
  extensions = {
    "fugitive",
  },
})
