local status_ok, cmp_autopairs, nvim_autopairs, cmp = pcall(function()
  return require("nvim-pairs"), require("nvim-autopairs.completion.cmp"), require("nvim-autopairs"), require("cmp")
end)

if not status_ok then
  return
end

nvim_autopairs.setup({
  check_ts = true,
  ts_config = {
    lua = { "string" },
    javascript = { "template_string" },
    java = false,
  },
})

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
