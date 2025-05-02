#!/usr/bin/env bash

# Dotfiles Installation Script
# This script installs and configures Neovim and tmux setups

# Exit on error
set -e

# Color definitions
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
RESET='\033[0m'

# Logging functions
log_info() {
  echo -e "${BLUE}[INFO]${RESET} $1"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${RESET} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${RESET} $1" >&2
}

log_warning() {
  echo -e "${YELLOW}[WARNING]${RESET} $1"
}

# Create log file
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="dotfiles_install_${TIMESTAMP}.log"
touch "$LOG_FILE"

# Log both to console and file
exec > >(tee -a "$LOG_FILE") 2>&1

# Header
echo "======================================================="
echo "           Dotfiles Installation Script                "
echo "======================================================="
echo "Started at: $(date)"
echo "Log file: $LOG_FILE"
echo

# Check if running as root and warn
if [ "$EUID" -eq 0 ]; then
  log_warning "Running as root is not recommended. Consider running as a regular user with sudo privileges."
  read -p "Continue anyway? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log_error "Installation aborted by user"
    exit 1
  fi
fi

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to install package if it doesn't exist
install_package() {
  if ! command_exists "$1"; then
    log_info "Installing $1..."
    sudo apt-get update
    sudo apt-get install -y "$1"
    if command_exists "$1"; then
      log_success "$1 installed successfully"
    else
      log_error "Failed to install $1"
      exit 1
    fi
  else
    log_info "$1 is already installed"
  fi
}

# Function to backup existing config
backup_config() {
  local path="$1"
  local name="$2"
  
  if [ -e "$path" ]; then
    local backup_dir="$HOME/.dotfiles_backup_$TIMESTAMP"
    mkdir -p "$backup_dir"
    
    log_info "Backing up existing $name configuration to $backup_dir"
    cp -r "$path" "$backup_dir/"
    log_success "Backup of $name created in $backup_dir"
  else
    log_info "No existing $name configuration found at $path"
  fi
}

# Create all component install scripts if they don't exist
create_install_scripts() {
  # Create nvim/install.sh if it doesn't exist
  if [ ! -f "nvim/install.sh" ]; then
    log_info "Creating nvim/install.sh..."
    
    mkdir -p nvim
    cat > nvim/install.sh << 'EOF'
#!/usr/bin/env bash

# Neovim Installation Script

# Color definitions
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
RESET='\033[0m'

# Logging functions
log_info() {
  echo -e "${BLUE}[INFO]${RESET} $1"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${RESET} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${RESET} $1" >&2
}

log_warning() {
  echo -e "${YELLOW}[WARNING]${RESET} $1"
}

# Header
echo "======================================================="
echo "           Neovim Configuration Installation           "
echo "======================================================="

# Install neovim if not present
if ! command -v nvim >/dev/null 2>&1; then
  log_info "Installing Neovim..."
  sudo apt-get update
  sudo apt-get install -y neovim
  if ! command -v nvim >/dev/null 2>&1; then
    log_error "Failed to install Neovim via apt"
    log_info "Trying to install Neovim from the official PPA..."
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo apt-get update
    sudo apt-get install -y neovim
    if ! command -v nvim >/dev/null 2>&1; then
      log_error "Failed to install Neovim. Please install it manually and try again."
      exit 1
    fi
  fi
  log_success "Neovim installed successfully"
else
  log_info "Neovim is already installed"
fi

# Install dependencies
log_info "Installing Neovim dependencies..."
sudo apt-get install -y python3-pip ripgrep fd-find xclip
pip3 install pynvim

# Check if stow is installed
if ! command -v stow >/dev/null 2>&1; then
  log_error "stow is not installed. Please run the main install script."
  exit 1
fi

# Create .config directory if it doesn't exist
mkdir -p "$HOME/.config"

# Use stow to create symlinks
log_info "Creating symlinks for Neovim configuration..."
stow -v -t "$HOME" nvim

log_success "Neovim configuration installed successfully"
echo
echo "To finalize the installation, please run nvim and wait for plugins to install."
echo "You may see some errors on the first run while plugins are being installed."
echo
EOF
    
    chmod +x nvim/install.sh
    log_success "Created nvim/install.sh"
  else
    log_info "nvim/install.sh already exists"
  fi

  # Create tmux/install.sh if it doesn't exist
  if [ ! -f "tmux/install.sh" ]; then
    log_info "Creating tmux/install.sh..."
    
    mkdir -p tmux
    cat > tmux/install.sh << 'EOF'
#!/usr/bin/env bash

# Tmux Installation Script

# Color definitions
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
RESET='\033[0m'

# Logging functions
log_info() {
  echo -e "${BLUE}[INFO]${RESET} $1"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${RESET} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${RESET} $1" >&2
}

log_warning() {
  echo -e "${YELLOW}[WARNING]${RESET} $1"
}

# Header
echo "======================================================="
echo "            Tmux Configuration Installation            "
echo "======================================================="

# Install tmux if not present
if ! command -v tmux >/dev/null 2>&1; then
  log_info "Installing tmux..."
  sudo apt-get update
  sudo apt-get install -y tmux
  if ! command -v tmux >/dev/null 2>&1; then
    log_error "Failed to install tmux. Please install it manually and try again."
    exit 1
  fi
  log_success "tmux installed successfully"
else
  log_info "tmux is already installed"
fi

# Check if stow is installed
if ! command -v stow >/dev/null 2>&1; then
  log_error "stow is not installed. Please run the main install script."
  exit 1
fi

# Use stow to create symlinks
log_info "Creating symlinks for tmux configuration..."
stow -v -t "$HOME" tmux

log_success "tmux configuration installed successfully"
echo
echo "You can now start tmux with the 'tmux' command."
echo "Remember: The prefix key is Ctrl+a (instead of the default Ctrl+b)"
echo
EOF
    
    chmod +x tmux/install.sh
    log_success "Created tmux/install.sh"
  else
    log_info "tmux/install.sh already exists"
  fi
}

# Function to install Starship prompt
install_starship() {
  if command_exists starship; then
    log_info "Starship prompt is already installed"
  else
    log_info "Installing Starship prompt..."
    
    # Install Starship using the official installer
    curl -sSf https://starship.rs/install.sh | sh -s -- -y
    
    if command_exists starship; then
      log_success "Starship prompt installed successfully"
    else
      log_error "Failed to install Starship prompt"
      log_info "You can try installing it manually later: https://starship.rs/guide/#%F0%9F%9A%80-installation"
      read -p "Continue without Starship? (y/n) " -n 1 -r
      echo
      if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_error "Installation aborted by user"
        exit 1
      fi
    fi
  fi
  
  # Create .config directory if it doesn't exist
  mkdir -p "$HOME/.config"
  
  # Use stow to symlink Starship configuration
  log_info "Creating symlinks for Starship configuration..."
  stow -v -t "$HOME" zsh
  
  log_success "Starship prompt configuration installed successfully"
}

# Function to set up Zsh configuration
setup_zsh_config() {
  log_info "Setting up Zsh configuration..."
  
  # Use stow to symlink Zsh configuration files
  stow -v -t "$HOME" zsh
  
  # Check if Zsh is the default shell
  if [[ "$SHELL" != *"zsh"* ]]; then
    log_info "Zsh is not the default shell. Would you like to set it as the default?"
    read -p "Set Zsh as default shell? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      # Get path to zsh
      ZSH_PATH=$(which zsh)
      
      # Check if zsh is in /etc/shells
      if ! grep -q "$ZSH_PATH" /etc/shells; then
        log_info "Adding $ZSH_PATH to /etc/shells..."
        echo "$ZSH_PATH" | sudo tee -a /etc/shells > /dev/null
      fi
      
      # Change default shell to zsh
      log_info "Changing default shell to Zsh..."
      chsh -s "$ZSH_PATH"
      log_success "Default shell changed to Zsh. You may need to log out and log back in for the changes to take effect."
    else
      log_info "Zsh will not be set as the default shell"
    fi
  else
    log_info "Zsh is already the default shell"
  fi
  
  log_success "Zsh configuration setup completed"
}

# Main Installation Process
main() {
  # Step 1: Check and install dependencies
  log_info "Checking dependencies..."
  
  # Essential dependencies
  for pkg in stow git curl gpg apt-transport-https ca-certificates; do
    install_package "$pkg"
  done
  
  # Check for zsh
  if ! command_exists zsh; then
    log_info "Installing Zsh..."
    sudo apt-get update
    sudo apt-get install -y zsh
    if ! command_exists zsh; then
      log_error "Failed to install Zsh. Please install it manually and try again."
      exit 1
    fi
    log_success "Zsh installed successfully"
  else
    log_info "Zsh is already installed"
  fi
  
  # Create installation scripts if needed
  create_install_scripts
  
  # Step 2: Backup existing configurations
  log_info "Checking for existing configurations to backup..."
  backup_config "$HOME/.config/nvim" "Neovim"
  backup_config "$HOME/.tmux.conf" "tmux"
  backup_config "$HOME/.zshrc" "Zsh"
  backup_config "$HOME/.config/starship.toml" "Starship"
  backup_config "$HOME/.warp" "Warp"
  
  # Step 3: Run nvim installation
  log_info "Installing Neovim configuration..."
  if [ -x "nvim/install.sh" ]; then
    ./nvim/install.sh
  else
    chmod +x nvim/install.sh
    ./nvim/install.sh
  fi
  
  # Step 4: Run tmux installation
  log_info "Installing tmux configuration..."
  if [ -x "tmux/install.sh" ]; then
    ./tmux/install.sh
  else
    chmod +x tmux/install.sh
    ./tmux/install.sh
  fi
  
  # Step 5: Install Starship prompt
  log_info "Installing Starship prompt..."
  install_starship
  
  # Step 6: Set up Zsh configuration
  log_info "Setting up Zsh configuration..."
  setup_zsh_config
  
  # Step 7: Install Warp terminal
  log_info "Installing Warp terminal..."
  if [ -x "warp/install.sh" ]; then
    ./warp/install.sh
  else
    chmod +x warp/install.sh
    ./warp/install.sh
  fi
  
  # Final success message
  log_success "Dotfiles installation completed successfully!"
  echo
  echo "======================================================="
  echo "                 Installation Summary                  "
  echo "======================================================="
  echo "- Dependencies: stow, git, curl"
  echo "- Neovim configuration installed"
  echo "- Dependencies: stow, git, curl, and others"
  echo "- Neovim configuration installed"
  echo "- tmux configuration installed"
  echo "- Starship prompt installed"
  echo "- Zsh configuration installed"
  echo "- Warp terminal installed"
  echo
  echo "For more information, see README.md"
  echo "======================================================="
}

# Check if script is being run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  # Trap errors
  trap 'log_error "An error occurred. Installation failed."' ERR
  
  # Run the main function
  main
fi

