#!/usr/bin/env bash

# ============================================================================
# Senterm One-Line Installer for macOS
# 
# Usage:
#   curl -sSfL https://raw.githubusercontent.com/BitSpecterCore/senterm-release/main/install.sh | bash
#
# Or with specific version:
#   curl -sSfL https://raw.githubusercontent.com/BitSpecterCore/senterm-release/main/install.sh | bash -s -- --version 20251218
#
# ============================================================================

set -e

# Configuration - Release-only repository
REPO_OWNER="BitSpecterCore"
REPO_NAME="senterm-release"
BINARY_NAME="senterm"
COMMAND_NAME="x"
INSTALL_DIR="/usr/local/bin"
BASE_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Parse arguments
VERSION=""
while [[ $# -gt 0 ]]; do
    case $1 in
        --version|-v)
            VERSION="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

echo ""
echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}${BOLD}║         Senterm One-Line Installer for macOS                 ║${NC}"
echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Detect architecture
ARCH=$(uname -m)
OS=$(uname -s)

if [[ "$OS" != "Darwin" ]]; then
    echo -e "${RED}✗ This installer is for macOS only${NC}"
    echo "For Linux, use: curl -sSfL https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/install-linux.sh | bash"
    exit 1
fi

echo -e "${GREEN}✓${NC} Detected: macOS ($ARCH)"

# Get latest version if not specified
if [[ -z "$VERSION" ]]; then
    echo -e "${BLUE}→${NC} Fetching latest release..."
    VERSION=$(curl -sSf "${BASE_URL}/latest.txt" 2>/dev/null | tr -d '[:space:]')
    
    if [[ -z "$VERSION" ]]; then
        echo -e "${RED}✗ Failed to get latest version${NC}"
        echo "Try specifying version manually: curl ... | bash -s -- --version 20251218"
        exit 1
    fi
fi

echo -e "${GREEN}✓${NC} Version: ${VERSION}"

# Construct download URL (from release repository)
ASSET_NAME="${BINARY_NAME}-macos-universal.tar.gz"
DOWNLOAD_URL="${BASE_URL}/${VERSION}/${ASSET_NAME}"

echo -e "${BLUE}→${NC} Downloading from: ${DOWNLOAD_URL}"

# Create temp directory
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

cd "$TEMP_DIR"

# Download
if ! curl -sSfL -o "${ASSET_NAME}" "${DOWNLOAD_URL}"; then
    echo -e "${RED}✗ Download failed${NC}"
    echo ""
    echo "Possible reasons:"
    echo "  - Version ${VERSION} may not exist"
    echo "  - Release assets may not be uploaded yet"
    echo ""
    echo "Check available releases at:"
    echo "  https://github.com/${REPO_OWNER}/${REPO_NAME}"
    exit 1
fi

echo -e "${GREEN}✓${NC} Download complete"

# Extract
echo -e "${BLUE}→${NC} Extracting..."
tar -xzf "${ASSET_NAME}"

# Find the binary
if [[ -f "${BINARY_NAME}" ]]; then
    SOURCE_BINARY="${BINARY_NAME}"
else
    echo -e "${RED}✗ Binary not found in archive${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} Extracted successfully"

# Verify binary
if file "${SOURCE_BINARY}" | grep -q "Mach-O"; then
    if file "${SOURCE_BINARY}" | grep -q "universal"; then
        echo -e "${GREEN}✓${NC} Universal binary verified (x86_64 + arm64)"
    else
        echo -e "${GREEN}✓${NC} Binary verified"
    fi
else
    echo -e "${RED}✗ Invalid binary format${NC}"
    exit 1
fi

# Check install directory
if [[ ! -d "${INSTALL_DIR}" ]]; then
    echo -e "${BLUE}→${NC} Creating ${INSTALL_DIR}..."
    sudo mkdir -p "${INSTALL_DIR}"
fi

# Install
echo -e "${BLUE}→${NC} Installing to ${INSTALL_DIR}/${COMMAND_NAME}..."

if [[ -w "${INSTALL_DIR}" ]]; then
    cp "${SOURCE_BINARY}" "${INSTALL_DIR}/${COMMAND_NAME}"
    chmod +x "${INSTALL_DIR}/${COMMAND_NAME}"
else
    echo -e "${YELLOW}→${NC} Administrator privileges required..."
    sudo cp "${SOURCE_BINARY}" "${INSTALL_DIR}/${COMMAND_NAME}"
    sudo chmod +x "${INSTALL_DIR}/${COMMAND_NAME}"
fi

# Verify installation
echo ""
if command -v "${COMMAND_NAME}" &> /dev/null; then
    echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}${BOLD}║              Installation Complete!                          ║${NC}"
    echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}✓${NC} '${COMMAND_NAME}' command is now available"
    echo ""
    echo -e "  ${BOLD}Usage:${NC}"
    echo -e "    ${CYAN}${COMMAND_NAME}${NC}              Start file manager in current directory"
    echo -e "    ${CYAN}${COMMAND_NAME} <path>${NC}       Start file manager in specified path"
    echo ""
    echo -e "  ${BOLD}API Key Setup:${NC}"
    echo -e "    Add to ~/.zshrc or ~/.bashrc:"
    echo -e "    ${CYAN}export OPENAI_API_KEY=\"your-key\"${NC}"
    echo -e "    ${CYAN}export GEMINI_API_KEY=\"your-key\"${NC}"
    echo ""
    echo -e "  ${BOLD}Uninstall:${NC}"
    echo -e "    ${CYAN}sudo rm ${INSTALL_DIR}/${COMMAND_NAME}${NC}"
    echo ""
else
    echo -e "${YELLOW}⚠${NC} Installation complete, but '${COMMAND_NAME}' not found in PATH"
    echo ""
    echo "Add the following to your shell profile (~/.zshrc):"
    echo -e "  ${CYAN}export PATH=\"\$PATH:${INSTALL_DIR}\"${NC}"
    echo ""
    echo "Then restart your terminal or run:"
    echo -e "  ${CYAN}source ~/.zshrc${NC}"
fi

