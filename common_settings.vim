" =============================================================================
"  VIM CONFIGURATION by Gemini
"  Last Updated: 2025-06-28
"  Features: Self-creating directories, modern workflow enhancements.
" =============================================================================

" =============================================================================
"  1. 核心启动与文件类型 (Core Foundation)
" =============================================================================
set nocompatible              " 彻底关闭兼容VI模式，拥抱Vim的强大功能
filetype plugin indent on     " 启用文件类型检测、相关插件和智能缩进
syntax on                     " 开启语法高亮，让代码五彩斑斓

" =============================================================================
"  2. 编码设置 (Encoding)
" =============================================================================
set encoding=utf-8
set termencoding=utf-8
set cmdencoding=utf-8
set fileencodings=ucs-bom,utf-8,prc,gb18030,taiwan,japan,korea,latin1

" =============================================================================
"  3. 界面与外观 (UI & Appearance)
" =============================================================================
set number relativenumber       " [优化] 结合绝对与相对行号，导航更高效
set cursorline                  " 高亮显示光标所在的行
set ruler                       " 在右下角显示光标位置
set showcmd                     " 在右下角实时显示你正在输入的命令
set showmode                    " 在左下角显示当前模式
set wildmenu                    " 开启命令模式的下拉菜单
set wildoptions=list:longest
set wrap                        " 自动折行显示过长的行
set scrolloff=10                " [优化] 光标上下保留10行上下文，阅读更流畅
set cmdheight=2                 " [新增] 命令区高度设为2行，避免信息被截断
set termguicolors               " 开启终端真彩色支持

" =============================================================================
"  4. 编辑与缩进 (Editing & Indentation)
" =============================================================================
set autoindent
set smartindent
set expandtab                   " 使用空格替代Tab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set backspace=indent,eol,start

" =============================================================================
"  5. 搜索功能 (Search)
" =============================================================================
set hlsearch
set incsearch
set ignorecase
set smartcase
set wrapscan                    " [新增] 搜索到文件末尾后，从头开始继续搜索

" =============================================================================
"  6. 工作流与行为 (Workflow & Behavior)
" =============================================================================
set hidden                      " [新增] 允许不保存就切换文件，提升多文件工作流效率
set mouse=a
set autoread

" [优化] 增强 viminfo 功能，记录更多历史和文件标记，用于恢复光标位置等
" '1000  : 记录最近1000个文件的历史
" f1     : 记录文件标记 (file marks)，这是恢复光标位置的关键
set viminfo^='1000,f1

" =============================================================================
"  7. 自动化与文件管理 (Automation & File Management)
"  [核心优化] 自动创建并管理临时文件目录
" =============================================================================
" 自动将当前目录切换到正在编辑的文件所在的目录
set autochdir

" --- 集中管理临时文件 ---
" 我们将所有临时文件（撤销历史、备份、交换文件）都存放在 ~/.vim/tmp/ 目录下
" 下面的代码会检查这些目录是否存在，如果不存在，则在Vim启动时自动创建它们。
let s:vim_tmp_dir = expand('~/.vim/tmp')

" 1. 撤销历史 (Undo History)
if has("persistent_undo")
    let s:undo_dir = s:vim_tmp_dir . '/undo'
    if !isdirectory(s:undo_dir)
        call mkdir(s:undo_dir, "p", 0700)
    endif
    let &undodir = s:undo_dir
    set undofile
endif

" 2. 备份文件 (Backup Files)
let s:backup_dir = s:vim_tmp_dir . '/backup'
if !isdirectory(s:backup_dir)
    call mkdir(s:backup_dir, "p", 0700)
endif
set backupdir=~/.vim/tmp/backup
set backup

" 3. 交换文件 (Swap Files)
let s:swap_dir = s:vim_tmp_dir . '/swap'
if !isdirectory(s:swap_dir)
    call mkdir(s:swap_dir, "p", 0700)
endif
set directory=~/.vim/tmp/swap
set writebackup

" =============================================================================
"  8. 自定义键位绑定 (Custom Mappings)
" =============================================================================
" --- Leader 键设置 ---
let mapleader = " "
nnoremap <Space> <Nop>

" --- 实用快捷键 ---
" <Leader>w : 快速保存
nnoremap <leader>w :w<CR>
" <Leader>q : 快速关闭窗口
nnoremap <leader>q :q<CR>
" <Leader><Space> : 清除搜索高亮
nnoremap <leader><space> :nohlsearch<CR>

" 在普通模式下按Esc，可以清除上次搜索留下的高亮
" (保留这个，因为它更符合直觉)
nnoremap <Esc> :nohlsearch<CR>

" --- 取消光标位置恢复的旧方法 ---
" au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" 上面这行已被更现代的 `set viminfo` 方式取代，故注释掉或删除。
