#!/bin/bash

# install.sh - Setup script for bulk parallel copy utility

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BULK_SCRIPT="$SCRIPT_DIR/bulk"
INSTALL_PATH="/usr/local/bin/bulk"

echo "=== Bulk Utility Installer ==="
echo ""

# Check if bulk script exists
if [[ ! -f "$BULK_SCRIPT" ]]; then
    echo "ERROR: bulk script not found at $BULK_SCRIPT"
    exit 1
fi

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    echo "WARNING: Running as root. Installing system-wide."
    SUDO_CMD=""
else
    echo "Installing bulk utility to $INSTALL_PATH (requires sudo)"
    SUDO_CMD="sudo"
fi

# Check dependencies
echo "[1/4] Checking dependencies..."
MISSING_DEPS=()

command -v rsync >/dev/null 2>&1 || MISSING_DEPS+=("rsync")
command -v find >/dev/null 2>&1 || MISSING_DEPS+=("findutils")
command -v xargs >/dev/null 2>&1 || MISSING_DEPS+=("findutils")

if [[ ${#MISSING_DEPS[@]} -gt 0 ]]; then
    echo "ERROR: Missing dependencies: ${MISSING_DEPS[*]}"
    echo ""
    echo "Install with:"
    echo "  Ubuntu/Debian: sudo apt install ${MISSING_DEPS[*]}"
    echo "  RHEL/CentOS:   sudo yum install ${MISSING_DEPS[*]}"
    echo "  Arch:          sudo pacman -S ${MISSING_DEPS[*]}"
    exit 1
fi
echo "✓ All dependencies available"

# Copy script to system location
echo "[2/4] Installing bulk script..."
$SUDO_CMD cp "$BULK_SCRIPT" "$INSTALL_PATH"
$SUDO_CMD chmod +x "$INSTALL_PATH"
echo "✓ Installed to $INSTALL_PATH"

# Verify installation
echo "[3/4] Verifying installation..."
if [[ -x "$INSTALL_PATH" ]]; then
    echo "✓ bulk is executable"
else
    echo "ERROR: Installation failed - $INSTALL_PATH not executable"
    exit 1
fi

# Check if in PATH
echo "[4/4] Checking PATH..."
if command -v bulk >/dev/null 2>&1; then
    echo "✓ bulk is available in PATH"
else
    echo "⚠ bulk not found in PATH"
    echo ""
    echo "Add /usr/local/bin to your PATH by adding this line to your shell profile:"
    echo "  ~/.bashrc, ~/.zshrc, or ~/.profile:"
    echo ""
    echo "    export PATH=\"/usr/local/bin:\$PATH\""
    echo ""
    echo "Then reload your shell:"
    echo "    source ~/.bashrc    # or ~/.zshrc"
    echo "    # OR start a new terminal"
fi

echo ""
echo "🎉 Installation complete!"
echo ""
echo "Usage examples:"
echo "  bulk /source/dir/ /dest/dir/                    # Basic parallel copy"
echo "  bulk -j 8 /media/usb/ /backup/                  # Limit to 8 parallel jobs"
echo "  bulk -v /large-dataset/ /destination/           # Verbose progress"
echo "  bulk -n /source/ /dest/                         # Dry run (preview only)"
echo "  bulk --help                                     # Show all options"
echo ""
echo "Perfect for:"
echo "  • Large datasets with many files"
echo "  • USB/external drive transfers"
echo "  • Network storage operations"
echo "  • Any scenario where cp -r is too slow"