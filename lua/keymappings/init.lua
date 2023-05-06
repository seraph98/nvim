-- highlight the current cursor line
vim.api.nvim_exec(
	[[
" Using Lua functions
nnoremap <space>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <space>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <space>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <space>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
]], false)
