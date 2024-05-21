local status_ok, mason, mason_tool = pcall(function()
  return require 'mason', require 'mason-tool-installer'
end)

if not status_ok then
  return
end

mason.setup({
  max_concurrent_installers = 4,
  log_level = vim.log.levels.DEBUG,
  ui = {
    check_outdated_packages_on_open = false,
    icons = {
      package_installed = "",
      package_pending = "",
      package_uninstalled = "",
    }
  },
})


mason_tool.setup({
  ensure_installed = {
    'stylua',
    'ruff',
  }
})
