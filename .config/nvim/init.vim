" ======================================================
"  Neovim Main Entry Point
"  File: ~/.config/nvim/init.vim
"  This file's job is to assemble the configuration.
" ======================================================

" 1. 调用“通用核心”配置
"    source 命令的作用就是“在此处加载并执行指定文件的内容”
source ../../.config/vim_core/common_settings.vim

" 2. 调用“Neovim专属”配置
source ../../.config/vim_core/neovim_special.vim

" 3. (未来) 在这里添加 Neovim 插件管理器和其他高级设置
"    比如 lazy.nvim 或者 packer.nvim 的启动代码