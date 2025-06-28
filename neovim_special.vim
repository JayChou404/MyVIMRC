" =============================================================================
"  NEOVIM/VIM SPECIFIC EXTENSIONS
"  (Load this file only in your full Vim/Neovim config)
" =============================================================================

" =============================================================================
"  界面与外观 (UI & Appearance)
" =============================================================================
set termguicolors               " 开启终端真彩色支持


" =============================================================================
" 工作流与行为 (Workflow & Behavior)
" =============================================================================
" [优化] 增强 viminfo 功能，记录更多历史和文件标记，用于恢复光标位置等
" '1000  : 记录最近1000个文件的历史
" f1     : 记录文件标记 (file marks)，这是恢复光标位置的关键
set viminfo^='1000,f1

" =============================================================================
"  自动化与文件管理 (Automation & File Management)
"  [核心优化] 自动创建并管理临时文件目录
" =============================================================================

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
"  自定义键位绑定 (Custom Mappings)
" =============================================================================
