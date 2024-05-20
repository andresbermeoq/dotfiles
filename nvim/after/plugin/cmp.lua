local status_ok, cmp = pcall(require, "cmp")

if not status_ok then
	return
end

cmp.setup({
	sources = {
		{ name = 'nvim_lsp'},
		{ name = 'path'},
		{ name = 'luasnip'},
		{ name = 'buffer'},
  },
  mapping = {
	  --LSP Mappping
    ['<Enter>'] = cmp.mapping.confirm({select = false}),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<Up>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
    ['<Down>'] = cmp.mapping.select_next_item({behavior = 'select'}),
    ['<C-m>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item({behavior = 'insert'})
      else
        cmp.complete()
      end
    end),
    ['<C-n>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item({behavior = 'insert'})
      else
        cmp.complete()
      end
    end),
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
})

-- Use cmdline & path source for ':' in the commands line
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{name = 'path'}
	}, {
		{name = 'cmdline'}
	})
})
