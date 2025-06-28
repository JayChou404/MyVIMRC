# install.py
import os
import sys
import shutil
from pathlib import Path
from datetime import datetime

# --- 配置区 ---
# 定义你的配置文件和它们应该被链接到的目标位置
# Path.home() 会自动获取当前用户的主目录 (e.g., /home/user or C:\Users\user)
DOTFILES = {
    ".ideavimrc": Path.home() / ".ideavimrc",
    ".config/nvim/init.vim": Path.home() / ".config/nvim/init.vim",
    # 未来可添加更多, e.g., ".zshrc": Path.home() / ".zshrc"
}
# --- 配置区结束 ---

def setup_symlink(source: Path, target: Path):
    """安全地创建符号链接，并备份已存在的文件。"""
    print(f"Processing: {target}...")

    # 1. 确保目标目录存在
    target.parent.mkdir(parents=True, exist_ok=True)

    # 2. 如果目标位置已存在文件或链接，先备份
    if target.exists() or target.is_symlink():
        backup_path = backup_dir / target.relative_to(Path.home())
        print(f"  -> Backing up existing file to {backup_path}")
        backup_path.parent.mkdir(parents=True, exist_ok=True)
        # 使用 shutil.move 来原子性地移动文件或目录
        shutil.move(str(target), str(backup_path))

    # 3. 创建新的符号链接
    try:
        # os.symlink 在 Python 3.8+ 中有 target_is_directory 参数
        # 在 Windows 上创建符号链接通常需要管理员权限或开启“开发人员模式”
        os.symlink(source, target)
        print(f"  -> Successfully linked {source} to {target}")
    except OSError as e:
        print(f"  -> ERROR: Could not create symlink for {target}. On Windows, this may require Admin rights or Developer Mode.", file=sys.stderr)
        print(f"  -> Details: {e}", file=sys.stderr)
    except Exception as e:
        print(f"  -> ERROR: An unexpected error occurred: {e}", file=sys.stderr)


if __name__ == "__main__":
    # 获取仓库的根目录 (即 install.py 所在的目录)
    dotfiles_dir = Path(__file__).parent.resolve()

    # 创建一个统一的备份目录
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_dir = Path.home() / f"dotfiles_backup_{timestamp}"
    print(f"🚀 Starting Dotfiles setup...")
    print(f"Source directory: {dotfiles_dir}")
    print(f"Backups will be stored in: {backup_dir}")
    print("-" * 30)

    for source_name, target_path in DOTFILES.items():
        source_path = dotfiles_dir / source_name
        if source_path.exists():
            setup_symlink(source_path, target_path)
        else:
            print(f"  -> WARNING: Source file not found, skipping: {source_path}", file=sys.stderr)

    print("-" * 30)
    print("✅ Dotfiles setup complete!")