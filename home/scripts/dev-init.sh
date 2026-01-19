#!/usr/bin/env bash
set -euo pipefail

TEMPLATE_DIR="$HOME/Templates/dev-templates"

# Show usage if no arguments
if [ $# -eq 0 ]; then
  echo "🚀 Development Environment Initializer"
  echo
  echo "Usage: dev-init <template>"
  echo
  echo "Available templates:"
  if [ -d "$TEMPLATE_DIR" ]; then
    for template in "$TEMPLATE_DIR"/*; do
      if [ -d "$template" ]; then
        template_name=$(basename "$template")
        echo "  📦 $template_name"
      fi
    done
  else
    echo "  ❌ Template directory not found: $TEMPLATE_DIR"
  fi
  echo
  echo "Examples:"
  echo "  dev-init python-ml    # Initialize Python ML environment"
  echo "  dev-init python-web   # Initialize Python web environment"
  echo "  dev-init nodejs       # Initialize Node.js environment"
  exit 0
fi

TEMPLATE="$1"
TEMPLATE_PATH="$TEMPLATE_DIR/$TEMPLATE"

# Check if template exists
if [ ! -d "$TEMPLATE_PATH" ]; then
  echo "❌ Template '$TEMPLATE' not found"
  echo "Available templates:"
  for template in "$TEMPLATE_DIR"/*; do
    if [ -d "$template" ]; then
      template_name=$(basename "$template")
      echo "  📦 $template_name"
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
cp "$TEMPLATE_PATH/flake.nix" .

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
