require('highlights')
require('plugins/init')
require('keymappings')
require('plugins')

vim.api.nvim_set_keymap('n', '<leader>gim', [[<cmd>lua require'telescope'.extensions.goimpl.goimpl{}<CR>]], {noremap=true, silent=true})

