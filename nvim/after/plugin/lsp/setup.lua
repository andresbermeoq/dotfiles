local status_ok, mason, mason_lspconfig, lspconfig = pcall(function()
	return require 'mason', require 'mason-lspconfig', require 'lspconfig'
end)

if not status_ok then
	return
end

local capabilities
do
    local default_capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = {
        textDocument = {
            foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            },
            completion = {
                completionItem = {
                    snippetSupport = true,
                },
            },
            codeAction = {
                resolveSupport = {
                    properties = vim.list_extend(
                        default_capabilities.textDocument.codeAction.resolveSupport.properties,
                        {
                            "documentation",
                            "detail",
                            "additionalTextEdits",
                        }
                    ),
                },
            },
        },
    }
end

mason.setup({})

mason_lspconfig.setup({
	ensure_installed = {
		-- LUA LSP
		'lua_ls',
		-- Python LSP
		'pyright',
		'ruff',
		-- Docker
		'dockerls',
		-- Javascript, Typescript
		'tsserver',
		-- Rust
		'rust_analyzer',
		'vimls',
	},
	automatic_installation = true,
})

mason_lspconfig.setup_handlers {
	function (server_name)
            require("lspconfig")[server_name].setup {
		    capabilities = capabilities
	    }
        end,
	['pyright'] = function ()
		lspconfig.pyright.setup {
			capabilities = capabilities,
		}
	end,
	['ruff'] = function ()
		lspconfig.ruff.setup {capabilities = capabilities,}
	end,
	['rust_analyzer'] = function ()
		lspconfig.rust_analyzer.setup {
			capabilities = capabilities,
		}
	end,
	['dockerls'] = function ()
		lspconfig.dockerls.setup { capabilities = capabilities,}
	end,
	['tsserver'] = function ()
		lspconfig.tsserver.setup { capabilities = capabilities, }
	end,
	['lua_ls'] = function ()
		lspconfig.lua_ls.setup {
			capabilities = capabilities,
			settings = {
                Lua = {
                    format = {
                        enable = true,
                    },
                    hint = {
                        enable = true,
                        arrayIndex = "Disable", -- "Enable", "Auto", "Disable"
                        await = true,
                        paramName = "All", -- "All", "Literal", "Disable"
                        paramType = true,
                        semicolon = "Disable", -- "All", "SameLine", "Disable"
                        setType = true,
                    },
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        checkThirdParty = false,
                    },
                },
            },
		}
	end,
	['vimls'] = function ()
		lspconfig.vimls.setup{capabilities = capabilities}
	end,
}
