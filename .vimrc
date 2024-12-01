"================================
" 基础配置
"================================

" set clipboard=unnamedplus
" set clipboard+=unnamedplus

" 显示代码风格化样式
syntax on

" 相关插件通用设置。够智能地识别文件类型，并为每种文件类型提供适当的编辑支持，包括语法高亮、自动缩进以及其他可能的插件特性。
set nocompatible
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on

" 设置 Vim 编辑器中的鼠标支持。a 是一个选项参数，表示 "all"（所有），意味着 Vim 将允许使用鼠标进行各种操作，比如移动光标、选择文本等。
set mouse=a

" 设置编码
set encoding=utf-8

" 让 Vim 使用空格来代替制表符，并在用户按下 Tab 键时插入空格而不是制表符字符。
let &t_ut=' '
set expandtab
" 更改tab的距离（这里更改为了2）。
set tabstop=2
set shiftwidth=2
set softtabstop=2

" 显示额外的信息，以便更好地理解文件内容。
set list
" ‣\  代表了一个制表符，而 ▫ 代表了尾随空格。
set listchars=tab:‣\ ,trail:▫ 

" 显示多少首行和尾行行滚动屏幕。
set scrolloff=5

" 控制 Vim 中的文本宽度和自动缩进行为。确保 Vim 不会对文本进行自动换行，并且使用默认的文件类型缩进来处理缩进。
set tw=0
set indentexpr=

" 允许 Backspace 键多个删除行首、行尾以及由自动缩进产生的空格。
set backspace=indent,eol,start

" 更方便地管理和浏览代码。
set foldmethod=indent
set foldlevel=99

" 根据 Vim 的当前模式来更改光标形状。
let &t_SI = "\<ESC>]50;CursorShape=1\x7"
let &t_SR = "\<ESC>]50;CursorShape=2\x7"
let &t_EI = "\<ESC>]50;CursorShape=0\x7"

" 配置 Vim 中的状态栏（statusline）的行为。活动窗口的底部显示状态栏。
set laststatus=2

" 每次打开文件时自动改变当前工作目录。
set autochdir
" 当你打开一个文件时，如果上次编辑时你停留在第二行到最后一行之间的某一行，那么这条自动命令会将光标跳转到你上次离开时的位置。
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" 显示光标行样式
set cursorline

" 显示正常模式命令，位于右下角
set showcmd

" 设置超过窗口文本，进行换行
set wrap

" 设置命令模式下，使用TAB键显示图形化选择命令
set wildmenu

" 显示行数以及相对行数
set number relativenumber

" 高亮显示搜索
set hlsearch

" 每次执行一个文件等执行"nohlsearch"命令
exec "nohlsearch"

" 动态显示高亮搜索
set incsearch

" 搜索忽略大小写，并开启智能大小写。例如: rRrr
set ignorecase smartcase

"================================
" 映射设置
"================================

" 设置自定义案件键为空格，并禁用空格键
let mapleader=" "
nnoremap <Space> <Nop>

" ↓以下为自定义快捷键配合使用

" 设置键盘映射R为刷新配置文件
map <leader>r :source ~/_vimrc<CR>

" 设置快捷键S保存
map <leader>s :w<CR>

" 设置快捷键Q退出
map <leader>q :q<CR>

" 设置分屏快捷键按下sr(right),sl(left),su(up),sd(down)分屏
map <leader>sr :set splitright<CR>:vsplit<CR>
map <leader>sl :set nosplitright<CR>:vsplit<CR>
map <leader>su :set nosplitbelow<CR>:split<CR>
map <leader>sd :set splitbelow<CR>:split<CR>

" 设置分屏切换操作
map <leader>sh <C-w>t<C-w>H
map <leader>sk <C-w>t<C-w>K

map <leader>t :tabe<CR>
map <leader>tl :+tabnext<CR>
map <leader>th :-tabnext<CR>

"↑

" 更改n、N快捷键为nzz、Nzz
noremap n nzz
noremap N Nzz

" 更改上下左右键为分屏大小修改键
map <down> :res +5<CR>
map <up> :res -5<CR>
map <right> :vertical resize+5<CR>
map <left> :vertical resize-5<CR>

"================================
" 插件设置
"================================

call plug#begin('~/vimfiles/plugged')

" 安装 gruvbox 主题
Plug 'morhetz/gruvbox'

" 安装 airline 样式插件
Plug 'vim-airline/vim-airline'

" 安装个人笔记系统
Plug 'vimwiki/vimwiki'

" 安装 nerdtree 文件目录系统
Plug 'preservim/nerdtree'

" 安装 代码补全插
Plug 'Valloric/YouCompleteMe'

call plug#end()

" 启用 gruvbox 主题
syntax enable
colorscheme gruvbox
let g:gruvbox_italic=1
" set background=dark
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX) && getenv('TERM_PROGRAM') != 'Apple_Terminal')
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" 配置 VimWiki
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

"================================
" IDEAvim 配置
"================================
