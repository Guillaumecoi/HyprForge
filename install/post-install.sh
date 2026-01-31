#!/usr/bin/env bash
#
# HyprForge Post-Installation Setup Script
# Run this after installing NixOS if Home Manager wasn't set up automatically
#
# Usage: bash post-install.sh
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

print_banner() {
    echo -e "${CYAN}"
    echo -e "╔════════════════════════════════════════════════════════════════╗"
    echo -e "║                                                                ║"
    echo -e "║     ${BOLD}HyprForge Post-Installation Setup${NC}${CYAN}                     ║"
    echo -e "║                                                                ║"
    echo -e "╚════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "\n${BLUE}[${1}]${NC} ${BOLD}${2}${NC}"
}

print_info() {
    echo -e "${CYAN}  → ${NC}${1}"
}

print_success() {
    echo -e "${GREEN}  ✓ ${NC}${1}"
}

print_warning() {
    echo -e "${YELLOW}  ⚠ ${NC}${1}"
}

print_error() {
    echo -e "${RED}  ✗ ${NC}${1}"
}

confirm() {
    echo -e -n "${YELLOW}$1 [y/N]: ${NC}"
    read -r response
    [[ "$response" =~ ^[Yy]$ ]]
}

# Check if running as root
check_not_root() {
    if [[ $EUID -eq 0 ]]; then
        print_error "This script should NOT be run as root"
        print_info "Run it as your regular user: bash post-install.sh"
        exit 1
    fi
}

# Check if HyprForge directory exists in home
check_hyprforge() {
    print_step "1/4" "Checking HyprForge installation"

    if [[ -d "$HOME/HyprForge" ]]; then
        print_success "HyprForge found at $HOME/HyprForge"
        return 0
    fi

    print_warning "HyprForge not found in $HOME"

    # Check if it exists in /etc/nixos
    if [[ -d "/etc/nixos" ]]; then
        print_info "Found HyprForge in /etc/nixos"

        if confirm "Copy HyprForge from /etc/nixos to $HOME/HyprForge?"; then
            print_info "Copying configuration..."
            cp -r /etc/nixos "$HOME/HyprForge"
            print_success "HyprForge copied to $HOME/HyprForge"
        else
            print_error "Cannot proceed without HyprForge in home directory"
            exit 1
        fi
    else
        print_error "HyprForge configuration not found"
        print_info "Please clone the repository first:"
        echo -e "  ${BOLD}git clone https://github.com/GuillaumeCoi/HyprForge.git ~/HyprForge${NC}"
        exit 1
    fi
}

# Check if home-manager is available
check_home_manager() {
    print_step "2/4" "Checking Home Manager"

    if command -v home-manager &> /dev/null; then
        print_success "Home Manager is installed"
    else
        print_warning "Home Manager not found in PATH"
        print_info "This should have been installed with the system"
        print_info "Trying to continue anyway (it may be available via nix-shell)..."
    fi
}

# Show what will be set up
show_summary() {
    print_step "3/4" "Setup Summary"
    echo ""
    echo -e "${BOLD}This will:${NC}"
    echo "  • Configure your user environment with Home Manager"
    echo "  • Install user applications (kitty, firefox, rofi, etc.)"
    echo "  • Set up Hyprland window manager with keybindings"
    echo "  • Configure development tools (neovim, git, zsh, etc.)"
    echo "  • Apply Catppuccin Mocha theme"
    echo ""
    echo -e "${BOLD}Configuration:${NC}"
    echo "  • Username: $(whoami)"
    echo "  • Hostname: $(hostname)"
    echo "  • Config:   $HOME/HyprForge"
    echo ""

    if ! confirm "Proceed with Home Manager setup?"; then
        print_info "Aborted."
        exit 0
    fi
}

# Run home-manager switch
setup_home_manager() {
    print_step "4/4" "Running Home Manager"
    echo ""
    print_info "This may take 5-15 minutes on the first run..."
    print_info "Home Manager will download and install all user applications"
    echo ""

    cd "$HOME/HyprForge"

    # Use the simple username target (preferred). Fall back to nix-shell only.
    local username=$(whoami)

    print_info "Running: home-manager switch --flake $HOME/HyprForge#${username} -b old"
    echo ""
    if home-manager switch --flake "$HOME/HyprForge#${username} -b old"; then
        print_success "Home Manager setup complete!"
        return 0
    fi

    print_warning "Direct home-manager command failed, trying with nix-shell..."
    echo ""
    if nix-shell -p home-manager --run "home-manager switch --flake $HOME/HyprForge#${username} -b old"; then
        print_success "Home Manager setup complete!"
        return 0
    fi

    print_error "Home Manager setup failed"
    echo ""
    print_info "You can try manually with:"
    echo -e "  ${BOLD}cd ~/HyprForge${NC}"
    echo -e "  ${BOLD}home-manager switch --flake .#$(whoami) -b old${NC}"
    echo ""
    print_info "Or via nix-shell:"
    echo -e "  ${BOLD}nix-shell -p home-manager --run 'home-manager switch --flake ~/HyprForge#$(whoami) -b old'${NC}"
    exit 1
}

# Print completion message
print_complete() {
    echo ""
    echo -e "${GREEN}"
    echo -e "╔════════════════════════════════════════════════════════════════╗"
    echo -e "║                                                                ║"
    echo -e "║     ${BOLD}Setup Complete!${NC}${GREEN}                                        ║"
    echo -e "║                                                                ║"
    echo -e "╚════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    print_info "Your HyprForge environment is now ready!"
    echo ""
    print_success "All applications and settings are installed"
    echo ""
    print_info "Quick tips:"
    echo -e "  • ${BOLD}SUPER + T${NC}     → Open terminal (kitty)"
    echo -e "  • ${BOLD}SUPER + Q${NC}     → Close window"
    echo -e "  • ${BOLD}SUPER + A${NC}     → Application launcher (rofi)"
    echo -e "  • ${BOLD}SUPER + SLASH${NC} → Show all keybindings"
    echo -e "  • ${BOLD}SUPER + E${NC}     → File manager"
    echo ""
    print_info "Configuration locations:"
    echo "  • System: /etc/nixos"
    echo "  • User:   ~/HyprForge"
    echo ""
    print_info "To update your user environment:"
    echo -e "  ${BOLD}cd ~/HyprForge && home-manager switch --flake .#$(whoami)@$(hostname)${NC}"
    echo ""
    print_warning "You may need to logout and login (or reboot) for all changes to take effect"
    echo ""

    if confirm "Logout now?"; then
        # Try to logout using various methods
        if command -v hyprctl &> /dev/null; then
            hyprctl dispatch exit
        elif command -v loginctl &> /dev/null; then
            loginctl terminate-user $(whoami)
        else
            print_info "Please logout manually"
        fi
    fi
}

# Main flow
main() {
    print_banner
    check_not_root
    check_hyprforge
    check_home_manager
    show_summary
    setup_home_manager
    print_complete
}

main "$@"
