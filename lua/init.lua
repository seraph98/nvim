require('highlights')
require('keymappings')
require('plugins')
require('plugins/init')

vim.api.nvim_set_keymap('n', '<leader>im', [[<cmd>lua require'telescope'.extensions.goimpl.goimpl{}<CR>]], {noremap=true, silent=true})

