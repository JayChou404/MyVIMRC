-- =============================================================================
--  NEOVIM LUA CONFIGURATION ENTRY POINT
--  File: init.lua
--  Purpose: Modern, fast, and future-proof entry point for Neovim.
--  It locates the dotfiles repository, sources legacy Vimscript modules,
--  and prepares for native Lua modules and plugin management.
-- =============================================================================

-- -----------------------------------------------------------------------------
--  1. 动态路径计算 (Dynamic Path Calculation in Lua)
-- -----------------------------------------------------------------------------

-- vim.fn.expand('<sfile>:p') 可以在 Lua 中调用 Vim 的函数来获取当前文件路径
local this_file_path = vim.fn.expand('<sfile>:p')

-- vim.fn.fnamemodify 同样可以被调用来获取目录
-- 因为 init.lua 在仓库根目录，所以获取它的目录就是仓库的根目录
local dotfiles_root = vim.fn.fnamemodify(this_file_path, ':h')

-- (可选) 调试时取消下面这行的注释
-- vim.notify("Dotfiles root detected at: " .. dotfiles_root)


-- -----------------------------------------------------------------------------
--  2. 加载旧的 Vimscript 配置模块 (Sourcing Vimscript from Lua)
--  我们使用 vim.cmd() 函数来执行任何 Vim 命令，包括 source。
--  这是连接新旧世界的桥梁。
-- -----------------------------------------------------------------------------

-- 使用 '..' 在 Lua 中进行字符串拼接
local common_settings_path = dotfiles_root .. '/vim_core/common_settings.vim'
local neovim_special_path = dotfiles_root .. '/vim_core/neovim_special.vim'

vim.cmd('source ' .. common_settings_path)
vim.cmd('source ' .. neovim_special_path)


-- -----------------------------------------------------------------------------
--  3. 加载新的 Lua 配置模块 (The Future is Lua)
--  这是推荐的未来方向。你应该逐步将 vim_core 中的配置迁移到 lua/ 目录下的 .lua 文件中。
--  使用 require() 来加载它们。
-- -----------------------------------------------------------------------------

-- require() 会自动在 'lua/' 目录下查找。'core.options' 对应 'lua/core/options.lua'
-- local status_ok, options = pcall(require, "core.options")
-- if not status_ok then
--   vim.notify("Failed to load core.options")
-- end


-- -----------------------------------------------------------------------------
--  4. 插件管理器 (Plugin Manager - lazy.nvim)
--  Lua 配置使得与现代插件管理器的集成变得极其简单和高效。
-- -----------------------------------------------------------------------------

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 加载插件配置 (假设你的插件配置在 lua/plugins.lua 文件中)
require('lazy').setup('plugins')


-- =============================================================================
--  Configuration Loading Complete
-- =============================================================================