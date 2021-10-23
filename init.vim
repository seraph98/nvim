set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936

set termencoding=utf-8
set encoding=utf-8
"set clipboard=unnamed
set conceallevel=1
" 设置 vimrc 修改保存后立刻生效，不用在重新打开
" 建议配置完成后将这个关闭
"autocmd BufWritePost ~/.config/nvim/init.vim source ~/.config/nvim/init.vim
" 解决插入模式下delete/backspce键失效问题
set backspace=2
"set scroll=5
" 打开鼠标功能
" set mouse=a
" 关闭兼容模式
set nocompatible

set autoread

" 关闭搜索高亮
set nohlsearch

"
set nu " 设置行号
" 关闭烦人的提示音 close noisy bell ring ~
set vb t_vb=
set cursorline "突出显示当前行
" set cursorcolumn " 突出显示当前列
set showmatch " 显示括号匹配

" tab 缩进
set tabstop=4 " 设置Tab长度为4空格
set shiftwidth=4 " 设置自动缩进长度为4空格
set autoindent " 继承前一行的缩进方式，适用于多行注释


" 定义快捷键的前缀，即<Leader>
let mapleader=";"

vmap d "_x
vmap y :'<,'>call QuickCopy()<CR><CR>

"resize split window
"
nnoremap <C-h> :call ExpandLeft()<CR>
nnoremap <C-l> :call ExpandRight()<CR>
nnoremap <C-j> :call ExpandDown()<CR>
nnoremap <C-k> :call ExpandUp()<CR>

"
"开启实时搜索
set incsearch
" 搜索时大小写不敏感
set ignorecase
syntax enable
syntax on                    " 开启文件类型侦测
filetype plugin indent on    " 启用自动补全

" 退出插入模式指定类型的文件自动保存
au InsertLeave *.go,*.sh,*.php write
	


call plug#begin()

" 远程复制
Plug 'ojroques/vim-oscyank'


" 自动补全
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'


" 语义解析
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

" " 用来提供一个导航目录的侧边栏
Plug 'scrooloose/nerdtree'

" " 可以使 nerdtree 的 tab 更加友好些
Plug 'jistr/vim-nerdtree-tabs'
"
" " 可以在导航目录中看到 git 版本信息
Plug 'Xuyuanp/nerdtree-git-plugin'
"
" scroll smoothly
Plug 'psliwka/vim-smoothie'
Plug 'Xuyuanp/nerdtree-git-plugin' " show git info
Plug 'ryanoasis/vim-devicons' "Adds filetype-specific icons to NERDTree files and folders
Plug 'tiagofumo/vim-nerdtree-syntax-highlight' "Adds syntax highlighting to NERDTree based on filetype.


" " 下面两个插件要配合使用，可以自动生成代码块
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" " 配色方案
" " colorscheme neodark
Plug 'KeitaNakamura/neodark.vim'
" " colorscheme monokai
Plug 'crusoexia/vim-monokai'
" " colorscheme github
Plug 'acarapetis/vim-colors-github'
" " colorscheme one
Plug 'rakr/vim-one'


" 全局搜索
"
Plug 'dyng/ctrlsf.vim'

" 注释插件
Plug 'preservim/nerdcommenter'


" show current function you are in
Plug 'tyru/current-func-info.vim'

" neovim build-in lsp
Plug 'neovim/nvim-lspconfig'

" " 可以快速对齐的插件
Plug 'junegunn/vim-easy-align'

" " 自动补全括号的插件，包括小括号，中括号，以及花括号
Plug 'jiangmiao/auto-pairs'

" ctags 插件
Plug 'ludovicchabant/vim-gutentags'


" fugtive
Plug 'tpope/vim-fugitive'


" 找到函数name
Plug 'tyru/current-func-info.vim'

call plug#end()



function ExpandRight()
	let num = winnr()
	if HasRightNeighbor()
		wincmd l
		if HasRightNeighbor()
			execute num . "wincmd w"
			:vertical res +3
		else
			:vertical res -3
			execute num . "wincmd w"
		endif
	else
		:vertical res -3
	endif
endfunction


function ExpandLeft()
	if HasLeftNeighbor()
		wincmd h
		:vertical res -3
		wincmd p
	else
		:vertical res -3
	endif
endfunction

function ExpandDown()
	:res +2
endfunction

function ExpandUp()
	if HasUpNeighbor()
		wincmd k
		:res -2
		wincmd p
	else
		:res -2
	endif
endfunction


function HasRightNeighbor()
	let winnum = winnr()
	wincmd l
	if winnum != winnr()
		wincmd p
		return 1
	else
		return 0
	endif
endfunction


function HasLeftNeighbor()
	let winnum = winnr()
	wincmd h
	if winnum != winnr()
		wincmd p
		return 1
	else
		return 0
	endif
endfunction

function HasUpNeighbor()
	let winnum = winnr()
	wincmd k
	if winnum != winnr()
		wincmd p
		return 1
	else
		return 0
	endif
endfunction

function HasDownNeighbor()
	let winnum = winnr()
	wincmd j
	if winnum != winnr()
		wincmd p
		return 1
	else
		return 0
	endif
endfunction



"==============================================================================
" 主题配色
"==============================================================================

" 开启24bit的颜色，开启这个颜色会更漂亮一些
set termguicolors
" 配色方案, 可以从上面插件安装中的选择一个使用

let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
colorscheme one " 主题
set background=dark " 主题背景 dark-深色; light-浅色

"==============================================================================
" NERDTree 插件
"==============================================================================

" 打开和关闭NERDTree快捷键
nnoremap <Leader>l  :NERDTreeToggle<CR>
nnoremap <Leader>f  :NERDTreeFind<CR>
" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p  | endif




" 使用 esc 退出终端命令行
tnoremap <Esc> <C-\><C-n>

" 自动进入 insert 模式
autocmd TermOpen * startinsert

"
"" 显示行号
let NERDTreeShowLineNumbers=0
" 打开文件时是否显示目录
let NERDTreeAutoCenter=1
" 是否显示隐藏文件
let NERDTreeShowHidden=1
" 设置宽度
" let NERDTreeWinSize=31
" 忽略一下文件的显示
let NERDTreeIgnore=['\.pyc','\~$','\.swp']
" 打开 vim 文件及显示书签列表
let NERDTreeShowBookmarks=2

" 在终端启动vim时，共享NERDTree
let g:nerdtree_tabs_open_on_console_startup=1


"==============================================================================
"  majutsushi/tagbar 插件
"==============================================================================

" majutsushi/tagbar 插件打开关闭快捷键
nnoremap <Leader>r :TagbarToggle<CR>
highlight TagbarSignature ctermfg=114 guifg=#98c379
" CtrlSF 配置
"
nnoremap <C-s> :CtrlSF 
nnoremap <Leader>s :CtrlSFToggle<CR>
"
"let g:tagbar_position = 'below'

let g:tagbar_width = 60
let g:tagbar_wrap = 1



"==============================================================================
"  nerdtree-git-plugin 插件
"==============================================================================
let g:NERDTreeIndicatorMapCustomm = {
			\ "Modified"  : "✹",
			\ "Staged"    : "✚",
			\ "Untracked" : "✭",
			\ "Renamed"   : "➜",
			\ "Unmerged"  : "═",
			\ "Deleted"   : "✖",
			\ "Dirty"     : "✗",
			\ "Clean"     : "✔︎",
			\ 'Ignored'   : '☒',
			\ "Unknown"   : "?"
			\ }

let g:NERDTreeGitStatusShowIgnored = 1


nmap <Leader>test :call QuickTest()<CR>

nmap <Leader>debug :call QuickDebug()<CR>

nmap <Leader>run :call QuickRun()<CR>


function QuickTest()
	let func_name = cfi#format("%s", "")
	if &filetype == "go"
		try
			let path = split(expand("%:p:h"), "go/src/")[1]
		catch
			echo "wrong path:".expand("%:p:h")
		endtry
		let param = "^".func_name."$ ".path
		"execute "tabnew | term go test -gcflags=all=-l -count=1 -v -run ^".func_name."$ %:h/*.go |sed_color"
		execute "tabnew | term go test -gcflags=all=-l -count=1 -v -run ".param." |sed_color"
	endif

endfunction

function QuickRun()
	let file_name = expand('%:t')
	if &filetype == "cpp"
		execute "tabnew | term gcc ".file_name." -lstdc++ -o atemp.out && ./atemp.out"
		:silent !rm ./atemp.out
	else
		echom "un supported file type"
	endif

endfunction

function QuickDebug()
	let func_name = cfi#format("%s", "")
	if &filetype == "go"
		try
			let path = split(expand("%:p:h"), "go/src/")[1]
		catch
			echo "wrong path:".expand("%:p:h")
		endtry
		execute "tabnew | term dlv test --build-flags='".path."' -- -test.run ^".func_name."$"
	endif

endfunction


" 使用pbcopy
" v 模式下复制内容到系统剪切板

xnoremap <leader>a :<C-U> call GetVisualSelection(visualmode())<Cr>

function! GetVisualSelection(mode)
    " call with visualmode() as the argument
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end]     = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if a:mode ==# 'v'
        " Must trim the end before the start, the beginning will shift left.
        let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
        let lines[0] = lines[0][column_start - 1:]
    elseif  a:mode ==# 'V'
        " Line mode no need to trim start or end
    elseif  a:mode == "\<c-v>"
        " Block mode, trim every line
        let new_lines = []
        let i = 0
        for line in lines
            let lines[i] = line[column_start - 1: column_end - (&selection == 'inclusive' ? 1 : 2)]
            let i = i + 1
        endfor
    else
        return ''
    endif
    for line in lines
        echom line
    endfor
    return join(lines, "\n")
endfunction

function QuickCut() range
	exe "normal! d"
endfunction

function QuickCopy() range
	":!(echo text | pbcopy)
	"let $TEMP_CLIP = join(getline(a:firstline, a:lastline), "\n")
	":!(echo $TEMP_CLIP | it2copy)
	let $TEMP_CLIP = GetVisualSelection(visualmode())
	let @" = $TEMP_CLIP
	:OSCYank
	":!(echo $TEMP_CLIP | it2copy)
endfunction



set re=2


" quick list 跳转
nnoremap <C-n> :cn<CR>
nnoremap <C-m> :cp<CR>
nnoremap <Leader>a :cclose<CR>

"==============================================================================
"  其他插件配置
"==============================================================================

" tab 标签页切换快捷键
:nn 1 1gt
:nn 2 2gt
:nn 3 3gt
:nn 4 4gt
:nn 5 5gt
:nn 6 6gt
:nn 7 7gt
:nn 8 8gt
:nn 9 8gt
:nn tt :tab split<CR>

lua << EOF
require('init')
EOF


" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
