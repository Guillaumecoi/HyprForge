#!/usr/bin/env bash
set -euo pipefail

TEMPLATE_DIRS=("$HOME/Templates/dev-templates/local" "$HOME/Templates/dev-templates/nix")

# Show usage if no arguments
if [ $# -eq 0 ]; then
  echo "🚀 Development Environment Initializer"
  echo
  echo "Usage: dev-init <template>"
  echo
  echo "Available templates:"
  declare -A _seen
  found=0
  for d in "${TEMPLATE_DIRS[@]}"; do
    if [ -d "$d" ]; then
      for template in "$d"/*; do
        if [ -d "$template" ]; then
          template_name=$(basename "$template")
          if [ -z "${_seen[$template_name]+x}" ]; then
            echo "  📦 $template_name"
            _seen[$template_name]=1
            found=1
          fi
        fi
      done
    fi
  done
  if [ $found -eq 0 ]; then
    echo "  ❌ No template directories found in: ${TEMPLATE_DIRS[*]}"
  fi
  echo
  echo "Examples:"
  echo "  dev-init python-ml    # Initialize Python ML environment"
  echo "  dev-init python-web   # Initialize Python web environment"
  echo "  dev-init nodejs       # Initialize Node.js environment"
  exit 0
fi

TEMPLATE="$1"
TEMPLATE_PATH=""
for d in "${TEMPLATE_DIRS[@]}"; do
  if [ -d "$d/$TEMPLATE" ]; then
    TEMPLATE_PATH="$d/$TEMPLATE"
    break
  fi
done

if [ -z "$TEMPLATE_PATH" ]; then
  echo "❌ Template '$TEMPLATE' not found"
  echo "Available templates:"
  declare -A _seen2
  for d in "${TEMPLATE_DIRS[@]}"; do
    if [ -d "$d" ]; then
      for template in "$d"/*; do
        if [ -d "$template" ]; then
          template_name=$(basename "$template")
          if [ -z "${_seen2[$template_name]+x}" ]; then
            echo "  📦 $template_name"
            _seen2[$template_name]=1
          fi
        fi
      done
    fi
  done
  exit 1
fi

# Check if flake.nix already exists
if [ -f "flake.nix" ]; then
  echo "⚠️  flake.nix already exists in current directory"
  echo -n "Overwrite? (y/N): "
  read -r response
  if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo "Cancelled"
    exit 0
  fi
fi

# Copy template files
echo "📋 Copying template '$TEMPLATE'..."
cp -r "$TEMPLATE_PATH"/* .

# Fix permissions (files from Nix store are read-only)
echo "🔧 Fixing permissions..."
chmod -R u+w .

# Ask flake.nix has been edited to fit the project
echo "✏️  Please edit 'flake.nix' to customize it for your project."
echo "   Press Enter when done..."
read -r

# Create .envrc for direnv
echo "📝 Creating .envrc..."
echo "use flake" > .envrc

# Allow direnv to load the environment
echo "🔄 Allowing direnv..."
direnv allow

echo "✅ Development environment initialized!"
echo "💡 Run 'nix develop' or just 'cd .' to enter the environment"

# Show what was created
echo
echo "Created files:"
echo "  📄 flake.nix (development environment)"
echo "  📄 .envrc (direnv configuration)"
echo
echo "The environment will automatically load when you enter this directory."
