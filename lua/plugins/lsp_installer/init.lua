local common = require("plugins/lsp_installer.common")
local file_util = require("util.file")
local home = os.getenv("HOME")
local base = home .. "/.config/nvim/lua/plugins/lsp_installer/"

local use = require('packer').use
require('packer').startup(function()
	use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
	use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
	use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
	use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
	use 'L3MON4D3/LuaSnip' -- Snippets plugin
end)

local lsp_installer = require("nvim-lsp-installer")
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

lsp_installer.on_server_ready(function(server)
	local opts = {}
	-- (optional) Customize the options passed to the server
	local module = "plugins/lsp_installer." .. server.name
	local path = base .. server.name .. ".lua"
	if file_util.file_exists(path) then
		opts = require(module)
	end

	opts.on_attach = common.on_attach
	opts.capabilities = common.capabilities
	opts.flags = common.flags
	-- This setup() function is exactly the same as lspconfig's setup function.
	-- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
	server:setup(opts)
end)


-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	mapping = {
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		['<Up>'] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end,
		['<Down>'] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	},
}


vim.api.nvim_command('hi LspReferenceText cterm=bold,underline ctermfg=168 ctermbg=16 gui=bold,underline guifg=#98c379 guibg=#4b5263')
vim.api.nvim_command('hi LspReferenceRead cterm=bold,underline ctermfg=168 ctermbg=16 gui=bold,underline guifg=#98c379 guibg=#4b5263')
vim.api.nvim_command('hi LspReferenceWrite cterm=bold,underline ctermfg=168 ctermbg=16 gui=bold,underline guifg=#98c379 guibg=#4b5263')


local document_hight_toggle = 0

function toggle_document_highlight()
	if document_hight_toggle == 0 then
		vim.api.nvim_command('lua vim.lsp.buf.document_highlight()')
		document_hight_toggle = 1
	else
		vim.api.nvim_command('lua vim.lsp.buf.clear_references()')
		document_hight_toggle = 0
	end
end
