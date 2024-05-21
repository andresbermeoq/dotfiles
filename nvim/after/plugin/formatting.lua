local status_ok, conform = pcall(function()
  return require("conform")
end)

if not status_ok then
  return
end

conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_fix", "ruff_format" },
  },
  format_on_save = {
    lsp_fallback = true,
    async = false,
    timeout_ms = 1000,
  },
})
