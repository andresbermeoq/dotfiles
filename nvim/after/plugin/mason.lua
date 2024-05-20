local status_ok, mason = pcall(require, "mason")

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
