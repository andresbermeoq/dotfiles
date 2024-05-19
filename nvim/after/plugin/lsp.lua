local lsp_zero = require('lsp-zero')
local lspconfig_status_ok, lpsconfig = pcall(function ()
	return require('lspconfig')
end)

if not lspconfig_status_ok then
	return
end

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)


require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = {'dockerls', 'pyright', 'rust_analyzer', 'tsserver', 'volar', 'lua_ls'},
	handlers = {
		function(server_name)
			lpsconfig[server_name].setup({})
		end,
	},
})
