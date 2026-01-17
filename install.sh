#!/bin/bash
set -e

echo "Browser Skill Installer"
echo "======================="
echo ""

echo "Checking dependencies..."

if ! command -v node &> /dev/null; then
    echo "  [missing] node: install from https://nodejs.org/"
    exit 1
fi
echo "  [ok] node"

echo ""
echo "Which z-agent-browser version?"
echo "  1) Enhanced fork (recommended): stealth mode, auto-persist, profile mode, etc."
echo "  2) Upstream npm: basic features only"
echo "  3) Skip: already installed"
read -p "Choice [1]: " CLI_CHOICE
CLI_CHOICE=${CLI_CHOICE:-1}

case $CLI_CHOICE in
    1)
        echo ""
        echo "Installing enhanced fork..."
        if [ -d "/tmp/agent-browser-install" ]; then
            rm -rf /tmp/agent-browser-install
        fi
        git clone https://github.com/zm2231/agent-browser.git /tmp/agent-browser-install
        cd /tmp/agent-browser-install
        
        if ! command -v pnpm &> /dev/null; then
            echo "  Installing pnpm..."
            npm install -g pnpm
        fi
        
        pnpm install
        pnpm build
        
        if command -v rustc &> /dev/null; then
            echo "  Building native CLI (Rust found)..."
            pnpm build:native
        else
            echo "  [skip] Native CLI: Rust not found (optional, install from https://rustup.rs)"
        fi
        
        npm link
        z-agent-browser install
        cd - > /dev/null
        echo "  [ok] Enhanced fork installed"
        ;;
    2)
        echo ""
        echo "Installing upstream npm..."
        npm install -g agent-browser
        agent-browser install
        echo "  [ok] Upstream installed"
        ;;
    3)
        if command -v z-agent-browser &> /dev/null; then
            echo "  [ok] z-agent-browser already installed"
        else
            echo "  [warning] z-agent-browser not found in PATH"
        fi
        ;;
esac

echo ""
echo "Creating data directories..."
mkdir -p ~/.browser
mkdir -p ~/.z-agent-browser/sessions
echo "  [ok] ~/.browser/"
echo "  [ok] ~/.z-agent-browser/sessions/"

echo ""
echo "Where should skill files be installed?"
echo "  1) Claude Code: ~/.claude/skills/"
echo "  2) Custom path"
echo "  3) Skip (copy manually)"
read -p "Choice [1]: " SKILL_CHOICE
SKILL_CHOICE=${SKILL_CHOICE:-1}

case $SKILL_CHOICE in
    1)
        DEST=~/.claude/skills/browser-automation
        mkdir -p "$DEST"
        cp skills/browser-automation/skill.md skills/browser-automation/reference.md "$DEST/"
        echo "  [ok] Installed to $DEST"
        ;;
    2)
        read -p "Enter path: " CUSTOM_PATH
        mkdir -p "$CUSTOM_PATH"
        cp skills/browser-automation/skill.md skills/browser-automation/reference.md "$CUSTOM_PATH/"
        echo "  [ok] Installed to $CUSTOM_PATH"
        ;;
    3)
        echo "  Skipped. Copy skills/browser-automation/*.md to your skills directory."
        ;;
esac

echo ""
echo "Installation complete."
echo ""
echo "Quick test:"
echo "  z-agent-browser open https://example.com --headed"
echo "  z-agent-browser snapshot -i"
echo "  z-agent-browser close"
echo ""
echo "Enhanced features (if installed from fork):"
echo "  z-agent-browser --stealth open https://bot.sannysoft.com"
echo "  z-agent-browser --persist open https://github.com --headed"
echo "  z-agent-browser --profile ~/.browser/my-profile open https://example.com"
echo ""
echo "Data locations:"
echo "  ~/.browser/              Auth state files"
echo "  ~/.z-agent-browser/        Auto-persist sessions"
echo ""
echo "Optional: For persistent Chrome between sessions:"
echo "  brew install tmux"
echo "  ./scripts/start-chrome.sh"
