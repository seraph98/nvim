local opts = {
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = 'Lua 5.3',
				-- Setup your lua path
				path = {
					'?.lua',
					'?/init.lua',
					vim.fn.expand'~/.luarocks/share/lua/5.3/?.lua',
					vim.fn.expand'~/.luarocks/share/lua/5.3/?/init.lua',
					'/usr/share/5.3/?.lua',
					'/usr/share/lua/5.3/?/init.lua'
				},
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = {'vim'},
			},

			workspace = {
				library = {
					[vim.fn.expand'~/.luarocks/share/lua/5.3'] = true,
					['/usr/share/lua/5.3'] = true
				}
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},

}

return opts
