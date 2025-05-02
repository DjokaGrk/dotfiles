#!/usr/bin/env bash

# Warp Terminal Installation Script
# This script installs and configures Warp terminal for Ubuntu

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

# Header
echo "======================================================="
echo "            Warp Terminal Installation                  "
echo "======================================================="

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to backup existing Warp config if it exists
backup_warp_config() {
  local warp_config_dir="$HOME/.warp"
  
  if [ -d "$warp_config_dir" ]; then
    local backup_dir="$HOME/.dotfiles_backup_warp_$(date +%Y%m%d_%H%M%S)"
    log_info "Backing up existing Warp configuration to $backup_dir"
    
    mkdir -p "$backup_dir"
    cp -r "$warp_config_dir"/* "$backup_dir/" 2>/dev/null || true
    
    log_success "Warp configuration backup created"
  else
    log_info "No existing Warp configuration found"
  fi
}

# Function to check system compatibility
check_system_compatibility() {
  # Check for Ubuntu
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ "$ID" != "ubuntu" ]]; then
      log_warning "This script is designed for Ubuntu, but detected $ID"
      log_warning "Installation may fail or behave unexpectedly"
      
      read -p "Continue anyway? (y/n) " -n 1 -r
      echo
      if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_error "Installation aborted by user"
        exit 1
      fi
    else
      log_info "Detected Ubuntu $VERSION_ID, proceeding with installation"
    fi
  else
    log_warning "Unable to determine OS distribution"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      log_error "Installation aborted by user"
      exit 1
    fi
  fi
  
  # Check for required dependencies
  log_info "Checking for required dependencies..."
  local deps=("curl" "gpg" "apt-transport-https" "ca-certificates")
  local missing_deps=()
  
  for dep in "${deps[@]}"; do
    if ! command_exists "$dep"; then
      missing_deps+=("$dep")
    fi
  done
  
  if [ ${#missing_deps[@]} -gt 0 ]; then
    log_info "Installing required dependencies: ${missing_deps[*]}"
    sudo apt-get update
    sudo apt-get install -y "${missing_deps[@]}"
  else
    log_info "All required dependencies are already installed"
  fi
}

# Function to install Warp
install_warp() {
  if command_exists warp; then
    log_info "Warp is already installed"
    return 0
  fi
  
  log_info "Installing Warp terminal..."
  
  # Add Warp GPG key
  log_info "Adding Warp repository GPG key..."
  curl -sSL https://releases.warp.dev/apt/gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/warp-archive-keyring.gpg > /dev/null
  
  # Add Warp repository
  log_info "Adding Warp repository..."
  echo "deb [signed-by=/usr/share/keyrings/warp-archive-keyring.gpg] https://releases.warp.dev/apt stable main" | sudo tee /etc/apt/sources.list.d/warp.list > /dev/null
  
  # Update package lists
  log_info "Updating package lists..."
  sudo apt-get update
  
  # Install Warp
  log_info "Installing Warp package..."
  sudo apt-get install -y warp-terminal
  
  # Verify installation
  if command_exists warp; then
    log_success "Warp terminal installed successfully"
  else
    log_error "Failed to install Warp terminal"
    return 1
  fi
  
  return 0
}

# Function to configure Warp integration with other tools
configure_warp_integrations() {
  log_info "Configuring Warp integrations..."
  
  # Create Warp directory if it doesn't exist
  mkdir -p "$HOME/.warp/themes"
  
  # Check for Zsh
  if command_exists zsh; then
    log_info "Detected Zsh, configuring Warp for Zsh integration"
    # Warp automatically detects and uses the default shell
    # No additional configuration needed for basic integration
  else
    log_warning "Zsh not detected. For best results, install Zsh and configure it as your default shell"
  fi
  
  # Check for tmux
  if command_exists tmux; then
    log_info "Detected tmux, Warp can integrate with existing tmux sessions"
    # Warp has built-in support for tmux, no additional configuration needed
  fi
  
  # Check for starship
  if command_exists starship; then
    log_info "Detected Starship prompt, which should work well with Warp"
  fi
  
  log_success "Warp integration configuration completed"
}

# Function to set up Warp themes and configuration
setup_warp_config() {
  log_info "Setting up Warp configuration..."
  
  # Create Warp configuration directories
  mkdir -p "$HOME/.warp/themes"
  mkdir -p "$HOME/.warp/keybindings"
  
  # Copy any local configurations if they exist
  if [ -d "$(dirname "$0")/config" ]; then
    log_info "Copying Warp configurations from dotfiles repository"
    cp -r "$(dirname "$0")/config/"* "$HOME/.warp/" 2>/dev/null || true
    log_success "Warp configuration files copied successfully"
  else
    log_info "No local Warp configurations found in the dotfiles repository"
  fi
  
  log_success "Warp configuration setup completed"
}

# Main function
main() {
  # Check system compatibility
  check_system_compatibility
  
  # Backup existing Warp configuration
  backup_warp_config
  
  # Install Warp
  if install_warp; then
    # Configure Warp integration with other tools
    configure_warp_integrations
    
    # Set up Warp configuration
    setup_warp_config
    
    log_success "Warp terminal installation and configuration completed successfully!"
    echo
    echo "You can now launch Warp by running 'warp' in your terminal"
    echo "or by finding it in your application menu."
    echo
    echo "For more information and documentation, visit: https://docs.warp.dev"
    echo "======================================================="
  else
    log_error "Warp terminal installation failed. Please check the error messages above."
    exit 1
  fi
}

# Check if script is being run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  # Trap errors
  trap 'log_error "An error occurred. Installation failed."' ERR
  
  # Run the main function
  main
fi

