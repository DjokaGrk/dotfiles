---
title: "Dotfiles Configuration"
date: 2025-05-01
tags: [dotfiles, tmux, lazyvim, neovim, zsh, starship, warp, configuration]
category: development
modified: 2025-05-02
status: active
---

# Dotfiles

> Personal configuration files for development environment, featuring LazyVim (Neovim), tmux, Zsh with Starship prompt, and Warp terminal. These dotfiles provide a consistent, portable, and version-controlled setup across different machines.

## 📝 Main Content

### Overview

This repository contains configuration files ("dotfiles") for:

- **tmux**: Terminal multiplexer with customized key bindings and appearance
- **LazyVim**: Neovim configuration with plugins and customizations
- **Zsh**: Shell configuration with aliases, functions, and plugins
- **Starship**: Cross-shell prompt with useful information and Git integration
- **Warp**: Modern terminal emulator with productivity features

### Prerequisites

- **Git**: For cloning and version control
- **stow**: For managing symlinks (`sudo apt install stow`)
- **curl**: For downloading installation scripts and packages
- **Zsh**: Modern shell with powerful features (`sudo apt install zsh`)
- **tmux**: Terminal multiplexer (`sudo apt install tmux`)
- **Neovim**: Text editor (`sudo apt install neovim`)
- **LazyVim**: Neovim configuration framework (https://www.lazyvim.org/)
- **Starship**: Cross-shell prompt (installed automatically by the script)
- **Warp**: Modern terminal emulator (installed automatically by the script)
- **xclip**: For clipboard integration (`sudo apt install xclip`)
- **GPG**: For secure key importing (`sudo apt install gpg`)

### Installation

#### 1. Clone the repository

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

#### 2. Run the automated installer

The repository includes a comprehensive installation script that handles all components:

```bash
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

This script will:
- Install all required dependencies
- Back up any existing configurations
- Set up tmux, Neovim/LazyVim, Zsh, Starship, and Warp
- Configure everything with sensible defaults

#### 3. Manual installation (alternative)

If you prefer to install components individually, you can use stow:

For tmux:
```bash
cd ~/dotfiles
stow tmux
```

For Neovim/LazyVim:
```bash
cd ~/dotfiles
stow nvim
```

For Zsh and Starship:
```bash
cd ~/dotfiles
stow zsh
```

For Warp terminal:
```bash
cd ~/dotfiles
./warp/install.sh
```

Alternatively, you can create symlinks manually:

```bash
# For tmux
ln -sf ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf

# For LazyVim
ln -sf ~/dotfiles/nvim/.config/nvim ~/.config/nvim

# For Zsh
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc

# For Starship
ln -sf ~/dotfiles/zsh/.config/starship/starship.toml ~/.config/starship.toml
```

### Configuration Details

#### tmux

The tmux configuration (`~/.tmux.conf`) includes:

- Prefix key changed from `Ctrl+b` to `Ctrl+a`
- Vi mode for navigation and copy mode
- Mouse support enabled
- Windows and panes starting at index 1
- Improved status bar
- Custom split pane shortcuts:
  - `prefix |` for horizontal split
  - `prefix -` for vertical split
- Reload config with `prefix r`

#### LazyVim (Neovim)

The LazyVim configuration preserves the existing structure:

- `init.lua`: Entry point for Neovim configuration
- `lua/config/`: Core configuration files
  - `autocmds.lua`: Automatic commands
  - `keymaps.lua`: Custom key mappings
  - `lazy.lua`: Plugin manager configuration
  - `options.lua`: Neovim options
- `lua/craftzdog/`: Custom modules
- `lua/plugins/`: Plugin configurations
- `lua/util/`: Utility functions

#### Zsh

The Zsh configuration (`~/.zshrc`) includes:

- Comprehensive history management with deduplication
- Intelligent directory navigation
- Advanced completion system
- Vim-style keybindings with additional shortcuts
- Useful aliases for common tasks and Git operations
- Functions for extraction, directory creation, and more
- Integration with tmux and Warp terminal
- Plugin support (commented examples included)
- SSH agent configuration
- Automatic loading of syntax highlighting and autosuggestions if installed

#### Starship Prompt

The Starship configuration (`~/.config/starship/starship.toml`) includes:

- Clean, informative prompt design
- Git branch and status information
- Command execution duration tracking
- Directory display with smart truncation
- Programming language version detection
- System status indicators
- Battery level warnings
- Background job indicators
- Optimized for performance and responsiveness

#### Warp Terminal

The Warp terminal configuration includes:

- Installation from official sources
- Integration with Zsh, tmux, and Starship
- Custom theme settings
- Keybinding configurations
- Performance optimizations
- Feature configuration for AI assistance and command palette

## 🔗 Related Links

- [LazyVim Documentation](https://www.lazyvim.org/)
- [Tmux Cheat Sheet](https://tmuxcheatsheet.com/)
- [Neovim Documentation](https://neovim.io/doc/)
- [Zsh Documentation](https://zsh.sourceforge.io/Doc/)
- [Starship Documentation](https://starship.rs/guide/)
- [Warp Terminal Documentation](https://docs.warp.dev/)
- [Stow Manual](https://www.gnu.org/software/stow/manual/stow.html)
- [Dotfiles Guide by GitHub](https://dotfiles.github.io/)

## 📊 Examples

### Integrated Tools and Workflow

This dotfiles setup creates a seamless integrated development environment with the following components:

#### Warp Terminal

Warp is a modern, Rust-based terminal emulator with productivity features:

- Blazing fast performance with GPU acceleration
- Command history and search
- Auto-suggestions and command palettes
- Integrated AI assistance
- Blocks for organizing command output
- Seamless integration with Zsh, tmux, and Starship

To start Warp after installation:
```bash
warp
```

Warp and tmux work together, with tmux offering additional capabilities:

To start a new tmux session:
```bash
tmux
```

To attach to an existing session:
```bash
tmux attach
```

### Common Command Reference

#### tmux Commands

```bash
# Start a new session
tmux

# Start a new named session
tmux new -s mysession

# List sessions
tmux ls

# Attach to a session
tmux attach -t mysession

# Detach from session (inside tmux)
Ctrl+a d

# Split pane horizontally (inside tmux)
Ctrl+a |

# Split pane vertically (inside tmux)
Ctrl+a -

# Navigate between panes
Ctrl+a h/j/k/l

# Create a new window
Ctrl+a c

# Switch to previous/next window
Ctrl+a p/n
```

#### Zsh Features

```bash
# Directory navigation
.. # Go up one directory (alias)
... # Go up two directories (alias)
take folder/ # Create folder and cd into it

# Extraction function
extract archive.tar.gz # Auto-extract based on file extension

# Git shortcuts
g # alias for git
gs # git status
ga # git add
gc # git commit
gp # git push

# Directory stack
cd -  # Go to previous directory
dirs -v  # List directory stack
pushd /path  # Push directory to stack and cd to it
popd  # Pop directory from stack and cd to it
```

#### Starship Capabilities

Starship prompt shows:
- Current git branch and status
- Python/Node/Rust/Go versions in project directories
- Command execution duration (for commands that take >2s)
- Error status for the previous command
- Background job indicator
- Battery warning when low

### Updating Configurations

#### Updating tmux config

1. Edit `~/dotfiles/tmux/.tmux.conf`
2. Reload the config:
   - From within tmux: `prefix r`
   - Or from command line: `tmux source-file ~/.tmux.conf`

#### Updating LazyVim

1. Edit files in `~/dotfiles/nvim/.config/nvim/`
2. Restart Neovim or use `:LvimReload` to reload configuration

#### Updating Zsh configuration

1. Edit `~/dotfiles/zsh/.zshrc`
2. Source the updated configuration:
   ```bash
   source ~/.zshrc
   ```

#### Updating Starship configuration

1. Edit `~/dotfiles/zsh/.config/starship/starship.toml`
2. Changes take effect in new terminal sessions or after sourcing Zsh config

#### Updating Warp settings

1. Most settings can be adjusted through Warp's GUI preferences
2. For theme/config edits, modify files in `~/dotfiles/warp/.warp/`

## 📌 Tasks

- [x] Add aliases for zsh
- [ ] Configure Git settings
- [x] Setup SSH configuration (via SSH agent in zshrc)
- [x] Create install script for automated setup

## 🛠️ Maintenance

To add new dotfiles to the repository:

1. Move the configuration file to the appropriate subdirectory in `~/dotfiles/`
2. Create a symlink from the original location to the file in your dotfiles repo
3. Commit the changes to git

Example:
```bash
# For a new config file ~/.config/foo/config
mkdir -p ~/dotfiles/foo/.config/foo
mv ~/.config/foo/config ~/dotfiles/foo/.config/foo/
ln -sf ~/dotfiles/foo/.config/foo/config ~/.config/foo/config
cd ~/dotfiles && git add foo && git commit -m "Add foo config"
```

### Backup

Remember to regularly push your changes to a remote repository:

```bash
cd ~/dotfiles
git push
```

This ensures your configurations are backed up and can be easily restored on a new machine.

## 🏷️ Tags

#dotfiles #tmux #lazyvim #neovim #configuration #development #linux

---

## 📅 Log

- 2025-05-01: Created dotfiles repository
- 2025-05-01: Added tmux configuration
- 2025-05-01: Added LazyVim configuration
