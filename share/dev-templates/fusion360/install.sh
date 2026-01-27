#!/usr/bin/env bash
# Autodesk Fusion 360 for Linux Installation Script

set -e

echo "🍷 Installing Autodesk Fusion 360 for Linux..."
echo ""
echo "This script will download and run the official installer from:"
echo "https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux"
echo ""

# Download the installer
echo "Downloading installer..."
curl -L https://raw.githubusercontent.com/cryinkfly/Autodesk-Fusion-360-for-Linux/main/files/setup/autodesk_fusion_installer_x86-64.sh -o "autodesk_fusion_installer.sh"

# Make it executable
chmod +x autodesk_fusion_installer.sh

echo ""
echo "Installer downloaded successfully!"
echo ""
echo "Choose installation type:"
echo "  1) Basic installation (recommended)"
echo "  2) Full installation (with all tested extensions)"
echo ""
read -p "Enter choice (1 or 2): " choice

case $choice in
  1)
    echo ""
    echo "Running basic installation..."
    ./autodesk_fusion_installer.sh --install --default
    ;;
  2)
    echo ""
    echo "Running full installation with extensions..."
    ./autodesk_fusion_installer.sh --install --default --full
    ;;
  *)
    echo ""
    echo "Invalid choice. Please run this script again and select 1 or 2."
    exit 1
    ;;
esac

echo ""
echo "✅ Installation complete!"
echo ""
echo "System Requirements:"
echo "  - 4+ GB RAM (6+ GB recommended)"
echo "  - 3 GB disk space"
echo "  - DirectX11 capable GPU (1+ GB VRAM)"
echo "  - Active Fusion 360 license required"
echo ""
echo "For troubleshooting and more information:"
echo "https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux"
