# install.py (v2 - Cross-Platform Intelligent Installer)
import os
import sys
import shutil
from pathlib import Path
from datetime import datetime

# --- 1. 系统环境检测 ---
IS_WINDOWS = sys.platform == "win32"
IS_LINUX = sys.platform == "linux"
IS_MACOS = sys.platform == "darwin"

# --- 2. 路径和文件配置 ---
# 获取仓库的根目录 (即 install.py 所在的目录)
DOTFILES_DIR = Path(__file__).parent.resolve()
HOME_DIR = Path.home()

# 为不同系统定义 Neovim 的配置路径
if IS_WINDOWS:
    NEOVIM_CONFIG_TARGET = HOME_DIR / "AppData/Local/nvim/init.vim"
else: # Linux or macOS
    NEOVIM_CONFIG_TARGET = HOME_DIR / ".config/nvim/init.vim"

# 定义 IdeaVim 的模板和目标文件
IDEAVIM_TEMPLATE_SOURCE = DOTFILES_DIR / ".ideavimrc.template"
IDEAVIM_TARGET = HOME_DIR / ".ideavimrc"

# 定义需要被符号链接的文件 (Neovim入口文件)
NEOVIM_CONFIG_SOURCE = DOTFILES_DIR / ".config/nvim/init.vim"

# --- 3. 核心功能函数 ---

def backup_file(target: Path, backup_root: Path):
    """如果目标文件存在，则备份它"""
    if target.exists() or target.is_symlink():
        # 构建一个在备份目录中保持其原始目录结构的路径
        relative_path = target.relative_to(HOME_DIR)
        backup_path = backup_root / relative_path
        print(f"  -> Backing up existing file: {target} to {backup_path}")
        backup_path.parent.mkdir(parents=True, exist_ok=True)
        shutil.move(str(target), str(backup_path))

def create_symlink(source: Path, target: Path):
    """为 Neovim 创建符号链接"""
    print(f"Processing Neovim link: {target}...")
    target.parent.mkdir(parents=True, exist_ok=True)
    try:
        os.symlink(source, target)
        print(f"  -> Successfully linked {source} to {target}")
    except OSError as e:
        print(f"  -> ERROR: Could not create symlink for {target}. On Windows, this may require Admin rights or Developer Mode.", file=sys.stderr)
    except Exception as e:
        print(f"  -> ERROR: An unexpected error occurred: {e}", file=sys.stderr)


def generate_ideavimrc(template: Path, target: Path, repo_path: Path):
    """为 IdeaVim 从模板生成配置文件"""
    print(f"Processing IdeaVim config: {target}...")
    try:
        # 读取模板文件内容
        content = template.read_text(encoding="utf-8")
        
        # 将占位符替换为仓库的真实路径 (统一使用正斜杠)
        repo_path_str = str(repo_path).replace("\\", "/")
        content = content.replace("%%DOTFILES_PATH%%", repo_path_str)
        
        # 将生成的内容写入目标文件
        target.write_text(content, encoding="utf-8")
        print(f"  -> Successfully generated {target}")
    except Exception as e:
        print(f"  -> ERROR: Failed to generate {target}: {e}", file=sys.stderr)

# --- 4. 主程序入口 ---
if __name__ == "__main__":
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_dir = HOME_DIR / f"MyVimrc_backup_{timestamp}"
    
    print(f"🚀 Starting MyVimrc setup for {sys.platform}...")
    print(f"Repository location: {DOTFILES_DIR}")
    print(f"Backups will be stored in: {backup_dir}")
    print("-" * 40)
    
    # --- 为 IdeaVim 生成配置文件 (所有平台通用) ---
    backup_file(IDEAVIM_TARGET, backup_dir)
    generate_ideavimrc(IDEAVIM_TEMPLATE_SOURCE, IDEAVIM_TARGET, DOTFILES_DIR)
    
    print("-" * 40)
    
    # --- 为 Neovim 创建符号链接 (路径根据系统变化) ---
    backup_file(NEOVIM_CONFIG_TARGET, backup_dir)
    create_symlink(NEOVIM_CONFIG_SOURCE, NEOVIM_CONFIG_TARGET)
    
    print("-" * 40)
    print("✅ Setup complete!")