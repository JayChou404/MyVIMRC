#!/bin/bash
# =============================================================================
#  Dotfiles Installation Bootstrap Script
#  This script creates symlinks from the home directory to the dotfiles in
#  this repository.
# =============================================================================

# 获取仓库的绝对路径
# $(pwd) 会获取当前脚本所在的目录
DOTFILES_DIR=$(pwd)
BACKUP_DIR=~/dotfiles_backup_$(date +%Y%m%d_%H%M%S)

echo "🚀 Starting Dotfiles setup..."
echo "---------------------------------"

# 一个安全的创建符号链接的函数
# 参数1: 源文件 (在dotfiles仓库里)
# 参数2: 目标文件 (在你电脑的home目录里)
setup_symlink() {
    local source_file=$1
    local target_file=$2
    local target_dir=$(dirname "${target_file}")

    # --- 1. 确保目标目录存在 ---
    if [ ! -d "${target_dir}" ]; then
        echo "Creating directory: ${target_dir}"
        mkdir -p "${target_dir}"
    fi

    # --- 2. 如果目标位置已经存在文件或链接，先备份它 ---
    if [ -e "${target_file}" ] || [ -L "${target_file}" ]; then
        echo "Backing up existing file: ${target_file}"
        # 确保备份目录存在
        mkdir -p "$(dirname "${BACKUP_DIR}${target_file}")"
        mv "${target_file}" "${BACKUP_DIR}${target_file}"
    fi

    # --- 3. 创建新的符号链接 ---
    echo "Linking ${source_file} to ${target_file}"
    ln -s "${source_file}" "${target_file}"
}

# --- 开始执行链接 ---

# 链接 .ideavimrc
setup_symlink "${DOTFILES_DIR}/.ideavimrc" "${HOME}/.ideavimrc"

# 链接 Neovim 的 init.vim
setup_symlink "${DOTFILES_DIR}/.config/nvim/init.vim" "${HOME}/.config/nvim/init.vim"

# ... 未来你可以按此格式添加任何其他想要管理的配置文件 ...
# 例如：setup_symlink "${DOTFILES_DIR}/.zshrc" "${HOME}/.zshrc"

echo "---------------------------------"
echo "✅ Dotfiles setup complete!"
echo "Old files have been backed up to: ${BACKUP_DIR}"