-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
--vim.api.nvim_set_keymap('n', '<leader>im', [[<cmd>lua require'telescope'.extensions.goimpl.goimpl{}<CR>]], { noremap = true, silent = true })

-- 设置 EJS 文件类型
vim.api.nvim_create_autocmd("BufRead", {
	pattern = "*.ejs",
	command = "setlocal filetype=html"
})

vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = "*.ejs",
	command = "setlocal filetype=html"
})


-- network issue: https://github.com/nvim-treesitter/nvim-treesitter/issues/3232

require("nvim-treesitter.install").prefer_git = true
require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'
	use '~/.local/share/nvim/site/pack/packer/start/packer.nvim'
	use "williamboman/mason.nvim"

	use {
		'nvim-telescope/telescope.nvim',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}

	use {
		'edolphin-ydf/goimpl.nvim',
		requires = {
			{ 'nvim-lua/plenary.nvim' },
			{ 'nvim-lua/popup.nvim' },
			{ 'nvim-telescope/telescope.nvim' },
			{ 'nvim-treesitter/nvim-treesitter' },
		},
		config = function()
			require 'telescope'.load_extension 'goimpl'
		end,
	}

	use {
		"windwp/nvim-autopairs",
		config = function() require("nvim-autopairs").setup {} end
	}


	use("quangnguyen30192/cmp-nvim-ultisnips")

	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"quangnguyen30192/cmp-nvim-ultisnips",
			config = function()
				-- optional call to setup (see customization section)
				require("cmp_nvim_ultisnips").setup {}
			end,
			-- If you want to enable filetype detection based on treesitter:
			-- requires = { "nvim-treesitter/nvim-treesitter" },
		},
		config = function()
			local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
			require("cmp").setup({
				snippet = {
					expand = function(args)
						vim.fn["UltiSnips#Anon"](args.body)
					end,
				},
				sources = {
					{ name = "ultisnips" },
					-- more sources
				},
				-- recommended configuration for <Tab> people:
				mapping = {
					["<Tab>"] = cmp.mapping(
						function(fallback)
							cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
						end,
						{ "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
					),
					["<S-Tab>"] = cmp.mapping(
						function(fallback)
							cmp_ultisnips_mappings.jump_backwards(fallback)
						end,
						{ "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
					),
				},
			})
		end,
	})
end)
require('highlights')
require('keymappings')
require('plugins/init')
return
