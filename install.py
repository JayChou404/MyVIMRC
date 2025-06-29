# install.py (v3.0 - The Final Architecture)
# This script uses a template-based approach for all configurations,
# eliminating the need for symlinks and runtime path detection.

import os
import sys
import shutil
from pathlib import Path
from datetime import datetime

# --- 1. 系统环境检测与路径配置 ---
IS_WINDOWS = sys.platform == "win32"
DOTFILES_DIR = Path(__file__).parent.resolve()
HOME_DIR = Path.home()

# 为不同系统定义 Neovim 的配置路径
if IS_WINDOWS:
    NEOVIM_CONFIG_TARGET = HOME_DIR / "AppData/Local/nvim/init.lua"
else: # Linux or macOS
    NEOVIM_CONFIG_TARGET = HOME_DIR / ".config/nvim/init.lua"

# 定义 IdeaVim 的模板和目标文件
IDEAVIM_TEMPLATE_SOURCE = DOTFILES_DIR / ".ideavimrc.template"
IDEAVIM_TARGET = HOME_DIR / ".ideavimrc"

# 定义 Neovim 的模板和目标文件
NEOVIM_TEMPLATE_SOURCE = DOTFILES_DIR / "init.lua.template"


# --- 2. 核心功能函数 ---

def generate_config_from_template(template_path: Path, target_path: Path, repo_path: Path):
    """从模板生成配置文件，并将占位符替换为仓库的绝对路径。"""
    print(f"Processing config for: {target_path}...")
    
    # 确保目标目录存在
    target_path.parent.mkdir(parents=True, exist_ok=True)
    
    try:
        # 读取模板文件内容
        content = template_path.read_text(encoding="utf-8")
        
        # 将占位符替换为仓库的真实路径 (统一使用正斜杠)
        repo_path_str = str(repo_path).replace("\\", "/")
        content = content.replace("%%DOTFILES_PATH%%", repo_path_str)
        
        # 备份可能已存在的旧文件
        if target_path.exists():
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            backup_file_name = f"{target_path.name}.backup_{timestamp}"
            backup_path = target_path.with_name(backup_file_name)
            print(f"  -> Backing up existing file to {backup_path}")
            shutil.move(str(target_path), str(backup_path))
        
        # 将生成的内容写入目标文件
        target_path.write_text(content, encoding="utf-8")
        print(f"  -> Successfully generated {target_path.name}")
    except Exception as e:
        print(f"  -> ERROR: Failed to generate {target_path.name}: {e}", file=sys.stderr)

# --- 3. 主程序入口 ---
if __name__ == "__main__":
    print(f"🚀 Starting MyVimrc setup for {sys.platform}...")
    print(f"Repository location: {DOTFILES_DIR}")
    print("-" * 40)
    
    # --- 为 IdeaVim 生成配置文件 ---
    generate_config_from_template(IDEAVIM_TEMPLATE_SOURCE, IDEAVIM_TARGET, DOTFILES_DIR)
    
    print("-" * 40)
    
    # --- 为 Neovim 生成配置文件 ---
    generate_config_from_template(NEOVIM_TEMPLATE_SOURCE, NEOVIM_CONFIG_TARGET, DOTFILES_DIR)
    
    print("-" * 40)
    print("✅ Setup complete!")