" ======================================================
"  Neovim Main Entry Point
" ======================================================

" 获取当前文件(init.vim)所在的目录
let s:this_file_dir = fnamemodify(expand('<sfile>:p'), ':h')
" 推算出 dotfiles 的根目录 (init.vim 在 .config/nvim/ 下，所以需要回退两级)
let s:dotfiles_root = s:this_file_dir . '/../../'

" 使用拼接出来的绝对路径来 source
execute 'source' s:dotfiles_root . '/vim_core/common_settings.vim'
execute 'source' s:dotfiles_root . '/vim_core/neovim_special.vim'