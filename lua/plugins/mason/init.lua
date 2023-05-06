local util = require('lspconfig/util')
local gopath = os.getenv("GOPATH")
if gopath == nil then
	gopath = ""
end

vim.o.completeopt = 'menuone,noselect'

require('go').setup()

local gopathmod = gopath .. '/pkg/mod'
require("mason").setup()
-- Setup language servers.
local lspconfig = require('lspconfig')
lspconfig.pyright.setup {}

lspconfig.lua_ls.setup {}
lspconfig.yamlls.setup {}


local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

lspconfig.gopls.setup {
	cmd = { "gopls", "--remote=auto" },
	filetypes = { "go", "gomod" },
	root_dir = function(fname)
		local fullpath = vim.fn.expand(fname, ':p')
		if string.find(fullpath, gopathmod) and LastRootPath ~= nil then
			return LastRootPath
		end
		LastRootPath = util.root_pattern("go.mod", ".git", ".gitignore")(fname)
		return LastRootPath
	end,
	settings = {
		gopls = {
			buildFlags = { "-tags=prod" },
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
			usePlaceholders = true,
		}
	},
	on_attach = on_attach
}
lspconfig.rust_analyzer.setup {
	-- Server-specific settings. See `:help lspconfig-setup`
	settings = {
		['rust-analyzer'] = {},
	},
}



-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', '<leader>impl', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set('n', '<space>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', '<space>f', function()
			vim.lsp.buf.format { async = true }
		end, opts)

		vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
	end,
})



-- auto completion : https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
local use = require('packer').use
require('packer').startup(function()
	use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
	use 'hrsh7th/nvim-cmp'      -- Autocompletion plugin
	use 'hrsh7th/cmp-nvim-lsp'  -- LSP source for nvim-cmp
	use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
	use 'L3MON4D3/LuaSnip'      -- Snippets plugin
end)

-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup {
		-- on_attach = my_custom_on_attach,
		capabilities = capabilities,
	}
end

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
		['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
		-- C-b (back) C-f (forward) for snippet placeholder navigation.
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		--[[
       [['<Tab>'] = cmp.mapping(function(fallback)
       [  if cmp.visible() then
       [    cmp.select_next_item()
       [  elseif luasnip.expand_or_jumpable() then
       [    luasnip.expand_or_jump()
       [  else
       [    fallback()
       [  end
       [end, { 'i', 's' }),
	   ]]
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),
	}),
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'ultisnips' },
	},
}

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
	'confirm_done',
	cmp_autopairs.on_confirm_done()
)

vim.api.nvim_command(
	'hi LspReferenceText cterm=bold,underline ctermfg=168 ctermbg=16 gui=bold,underline guifg=#98c379 guibg=#4b5263')
vim.api.nvim_command(
	'hi LspReferenceRead cterm=bold,underline ctermfg=168 ctermbg=16 gui=bold,underline guifg=#98c379 guibg=#4b5263')
vim.api.nvim_command(
	'hi LspReferenceWrite cterm=bold,underline ctermfg=168 ctermbg=16 gui=bold,underline guifg=#98c379 guibg=#4b5263')


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

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader>ref', vim.lsp.buf.references)
vim.keymap.set('n', '<leader>k', toggle_document_highlight)


-- json
--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require 'lspconfig'.jsonls.setup {
	capabilities = capabilities,
}
