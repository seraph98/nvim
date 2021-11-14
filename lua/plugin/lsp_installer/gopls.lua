local util = require('lspconfig/util')
local gopath = os.getenv("GOPATH")
if gopath == nil then
	gopath = ""
end
local gopathmod = gopath..'/pkg/mod'

local opts = {
	cmd = {"gopls", "--remote=auto"},
	filetypes = { "go", "gomod" },
	root_dir = function(fname)
		local fullpath = vim.fn.expand(fname, ':p')
		if string.find(fullpath, gopathmod) and LastRootPath ~= nil then
			return LastRootPath
		end
		LastRootPath = util.root_pattern("go.mod", ".git", ".gitignore")(fname)
		return LastRootPath
	end,
	init_options = {
		allowModfileModifications = true,
		experimentalWorkspaceModule= true,
	},
}

function GoImports(timeout_ms)
	local context = { only = { "source.organizeImports" } }
	vim.validate { context = { context, "t", true } }

	local params = vim.lsp.util.make_range_params()
	params.context = context

	-- See the implementation of the textDocument/codeAction callback
	-- (lua/vim/lsp/handler.lua) for how to do this properly.
	local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
	if not result or result == nil or next(result) == nil then return end
	if result[1] == nil then return end
	local actions = result[1].result
	if not actions then return end
	local action = actions[1]

	-- textDocument/codeAction can return either Command[] or CodeAction[]. If it
	-- is a CodeAction, it can have either an edit, a command or both. Edits
	-- should be executed first.
	if action.edit or type(action.command) == "table" then
		if action.edit then
			vim.lsp.util.apply_workspace_edit(action.edit)
		end
		if type(action.command) == "table" then
			vim.lsp.buf.execute_command(action.command)
		end
	else
		vim.lsp.buf.execute_command(action)
	end
end

local au = require('au')
au.BufEnter = {
	'*.go',
	function()
		vim.api.nvim_command('autocmd BufWritePre * lua GoImports(1000)')
	end,
}
return opts

