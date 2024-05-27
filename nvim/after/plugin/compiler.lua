local status_ok, compiler, overseer = pcall(function()
  return require("compiler"), require("overseer")
end)

if not status_ok then
  return
end

overseer.setup({
  task_list = {
    direction = "bottom",
    max_width = { 100, 0.2 },
    min_width = { 40, 0.1 },
    default_detail = 1,
  },
})

compiler.setup({})
