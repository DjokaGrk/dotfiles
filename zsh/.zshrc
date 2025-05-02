#!/usr/bin/env zsh

# ===== ZSHRC Configuration =====
# This file configures the Zsh shell with modern best practices and
# integrates with tmux and Warp terminal.

# ===== Environment Variables =====
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export MANPAGER="less -X"
export TERM="xterm-256color"
export KEYTIMEOUT=1  # Reduce delay for key sequences

# ===== Path Configuration =====
# Add local bins to path
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
# Add cargo bin if it exists
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"
# Add Go binaries if Go is installed
[[ -d "/usr/local/go/bin" ]] && export PATH="/usr/local/go/bin:$PATH"
[[ -d "$HOME/go/bin" ]] && export PATH="$HOME/go/bin:$PATH"

# ===== History Configuration =====
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY          # Store timestamp and duration
setopt HIST_EXPIRE_DUPS_FIRST    # Remove duplicates first when HISTFILE size exceeds HISTSIZE
setopt HIST_IGNORE_DUPS          # Ignore duplicated commands in history
setopt HIST_IGNORE_SPACE         # Don't store commands starting with space
setopt HIST_VERIFY               # Show command with history expansion before running it
setopt SHARE_HISTORY             # Share history between sessions
setopt APPEND_HISTORY            # Append to history file instead of overwriting
setopt INC_APPEND_HISTORY        # Add commands as they are typed, not at shell exit

# ===== Directory Navigation =====
setopt AUTO_CD                   # If command is a directory path, cd to it
setopt AUTO_PUSHD                # Push the current directory onto the stack
setopt PUSHD_IGNORE_DUPS         # Don't push multiple copies of the same directory
setopt PUSHD_SILENT              # Don't print directory stack after pushd/popd
DIRSTACKSIZE=10                  # Limit directory stack size

# ===== Completion System =====
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select                       # Use menu selection for completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive matching
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # Colored completion
zstyle ':completion:*' group-name ''                     # Group results by category
zstyle ':completion:*:descriptions' format '%F{yellow}%B%d%b%f' # Format category headers
zstyle ':completion:*:warnings' format '%F{red}No matches found%f' # Format for no matches
zstyle ':completion:*' use-cache on                      # Use caching for completion
zstyle ':completion:*' cache-path "$HOME/.cache/zsh/zcompcache" # Cache path
# Create cache directory if it doesn't exist
[[ ! -d "$HOME/.cache/zsh/zcompcache" ]] && mkdir -p "$HOME/.cache/zsh/zcompcache"

# ===== Key Bindings =====
# Use vim keybindings
bindkey -v

# Allow editing the command line with $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# Additional key bindings for navigation
bindkey '^[[1;5C' forward-word   # Ctrl+Right
bindkey '^[[1;5D' backward-word  # Ctrl+Left
bindkey '^[[H' beginning-of-line # Home
bindkey '^[[F' end-of-line       # End
bindkey '^[[3~' delete-char      # Delete
bindkey '^?' backward-delete-char # Backspace

# ===== Aliases =====
# General
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'
alias vim='nvim'
alias zshrc='$EDITOR ~/.zshrc'
alias sudo='sudo '  # Allow using aliases with sudo

# Directory shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'  # Return to previous directory

# Git shortcuts
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gs='git status'
alias gl='git log --oneline --graph --decorate'
alias gp='git push'
alias gpl='git pull'
alias gd='git diff'

# tmux shortcuts
alias t='tmux'
alias ta='tmux attach -t'
alias tls='tmux list-sessions'
alias tn='tmux new-session -s'
alias tk='tmux kill-session -t'

# Utility functions
alias h='history'
alias j='jobs -l'
alias df='df -h'
alias du='du -h'
alias free='free -m'
alias myip='curl http://ipecho.net/plain; echo'
alias update='sudo apt update && sudo apt upgrade -y'

# Make directory and cd into it
mcd() {
  mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# ===== Plugin Support =====
# This section can be expanded with plugin managers like
# zplug, zinit, antigen, etc. For simplicity, we're not
# including them by default.

# If you want to add plugins later, consider using zinit:
# Example zinit setup (commented out)
# if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
#     mkdir -p "$HOME/.zinit" && chmod g-rwX "$HOME/.zinit"
#     git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin"
# fi
# source "$HOME/.zinit/bin/zinit.zsh"
# zinit light zsh-users/zsh-autosuggestions
# zinit light zsh-users/zsh-syntax-highlighting
# zinit light zsh-users/zsh-completions

# ===== Tmux Integration =====
# Auto-start tmux if not already in a tmux session
# Commented out to allow the user to decide if they want this behavior
# if [[ -z "$TMUX" && -z "$INSIDE_EMACS" && -z "$EMACS" && -z "$VIM" && -z "$VSCODE_PID" && -z "$WARP_SESSION" ]]; then
#   exec tmux
# fi

# ===== Starship Prompt =====
# Initialize Starship prompt if it's installed
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
else
  # Fallback prompt if Starship is not installed
  autoload -Uz promptinit && promptinit
  prompt redhat
fi

# ===== Warp Terminal Integration =====
# Warp-specific settings
if [[ -n "$WARP_IS_INTERACTIVE_SHELL" ]]; then
  # Enable Warp directory list. Shows directories on the right side-bar
  alias cd='cd "$@" && ls'
fi

# If we're running in Warp, let's optimize for it
if [[ -n "$WARP_SESSION" ]]; then
  # Disable certain features that might conflict with Warp
  export DISABLE_UPDATE_PROMPT=true
  
  # Enable Warp-specific features
  # Set the cursor style to match Warp's default
  echo -ne '\e[5 q'
  
  # Add any other Warp-specific configurations here
fi

# ===== SSH Agent ===== 
# Start SSH agent if not already running
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)" > /dev/null
fi

# ===== Custom Scripts =====
# Source any additional local configuration
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# ===== Final Setup =====
# Ensure unique paths (remove duplicates)
typeset -U path

# Load zsh-syntax-highlighting if installed (should be sourced at the end)
if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

