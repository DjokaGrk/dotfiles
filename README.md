---
title: "Dotfiles Configuration"
date: 2025-05-01
tags: [dotfiles, tmux, lazyvim, neovim, configuration]
category: development
modified: 2025-05-01
status: active
---

# Dotfiles

> Personal configuration files for development environment, focusing on LazyVim (Neovim) and tmux. These dotfiles provide a consistent, portable, and version-controlled setup across different machines.

## 📝 Main Content

### Overview

This repository contains configuration files ("dotfiles") for:

- **tmux**: Terminal multiplexer with customized key bindings and appearance
- **LazyVim**: Neovim configuration with plugins and customizations

### Prerequisites

- **Git**: For cloning and version control
- **stow**: For managing symlinks (`sudo apt install stow`)
- **tmux**: Terminal multiplexer (`sudo apt install tmux`)
- **Neovim**: Text editor (`sudo apt install neovim`)
- **LazyVim**: Neovim configuration framework (https://www.lazyvim.org/)
- **xclip**: For clipboard integration (`sudo apt install xclip`)
- **zsh**: Shell (optional, but recommended)

### Installation

#### 1. Clone the repository

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

#### 2. Install dependencies

```bash
sudo apt update
sudo apt install stow tmux neovim xclip
```

#### 3. Create symlinks using stow

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

Alternatively, you can create symlinks manually:

```bash
# For tmux
ln -sf ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf

# For LazyVim
ln -sf ~/dotfiles/nvim/.config/nvim ~/.config/nvim
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

## 🔗 Related Links

- [LazyVim Documentation](https://www.lazyvim.org/)
- [Tmux Cheat Sheet](https://tmuxcheatsheet.com/)
- [Neovim Documentation](https://neovim.io/doc/)
- [Stow Manual](https://www.gnu.org/software/stow/manual/stow.html)
- [Dotfiles Guide by GitHub](https://dotfiles.github.io/)

## 📊 Examples

### Usage with Warp Terminal

While Warp Terminal provides many advanced features, tmux offers additional capabilities:

- Session persistence across terminal restarts
- Advanced window management
- Split panes and layouts
- Session sharing

To start a new tmux session:
```bash
tmux
```

To attach to an existing session:
```bash
tmux attach
```

### Common tmux Commands

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

### Updating tmux config

1. Edit `~/dotfiles/tmux/.tmux.conf`
2. Reload the config:
   - From within tmux: `prefix r`
   - Or from command line: `tmux source-file ~/.tmux.conf`

### Updating LazyVim

1. Edit files in `~/dotfiles/nvim/.config/nvim/`
2. Restart Neovim or use `:LvimReload` to reload configuration

## 📌 Tasks

- [ ] Add aliases for zsh/bash
- [ ] Configure Git settings
- [ ] Setup SSH configuration
- [ ] Create install script for automated setup
- [ ] Add color schemes for terminal
- [ ] Document keyboard shortcuts for LazyVim
- [x] Setup tmux configuration
- [x] Configure LazyVim

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
