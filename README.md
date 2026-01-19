# Browser Skill for AI Agents

Web browser automation for Claude Code, OpenCode, and AI agents. Uses your Chrome logins via CDP auto-detection.

## Installation

**Step 1: Install the CLI**
```bash
npm install -g z-agent-browser
z-agent-browser install
```

**Step 2: Install the skill**
```
/plugin marketplace add zm2231/browser-skill
/plugin install browser-skill@browser-skill-marketplace
```

### LLM Agents

Paste this into a fresh Claude Code / OpenCode session:
```
Install and configure browser automation by following the instructions at https://raw.githubusercontent.com/zm2231/browser-skill/main/README.md
```

<details>
<summary>Instructions for LLM Agents (click to expand)</summary>

If you're an LLM Agent helping set up browser-skill, follow these steps:

#### Step 1: Install z-agent-browser

```bash
npm install -g z-agent-browser
z-agent-browser install
```

#### Step 2: Install the skill

Prompt user to run these commands (copy-paste for them):

```
/plugin marketplace add zm2231/browser-skill
/plugin install browser-skill@browser-skill-marketplace
```

Wait for user to confirm they ran the commands.

#### Step 3: Verify

```bash
z-agent-browser open "https://example.com"
z-agent-browser snapshot -i
z-agent-browser close
```

#### Step 4: Confirm to user

Say: "Browser automation is ready! Key commands: `open`, `snapshot -i`, `click @ref`, `fill @ref "text"`, `close`."

</details>

## Quick Start

```bash
z-agent-browser open "https://example.com"
z-agent-browser snapshot -i                    # Get interactive elements with refs
z-agent-browser click @e1                      # Click by ref
z-agent-browser fill @e2 "text"                # Fill input
z-agent-browser close
```

## Login Persistence

### Option 1: State Save/Load (Recommended)

Save login sessions to a JSON file and restore them later:

```bash
# First time: Login manually in headed mode
z-agent-browser start --headed
z-agent-browser open "https://github.com"
# [User logs in manually]
z-agent-browser state save ~/.z-agent-browser/github.json
z-agent-browser stop

# Later: Restore session headlessly
z-agent-browser start
z-agent-browser state load ~/.z-agent-browser/github.json
z-agent-browser open "https://github.com"  # Already logged in!
```

**Key points:**
- Saves cookies, localStorage, sessionStorage to JSON
- Portable and simple
- Works on both Mac and Linux

### Option 2: CDP Mode (For Real Chrome)

Connect to your actual Chrome browser with saved passwords.

> **Important**: Chrome 136+ blocks CDP on the default profile for security. You must use `--user-data-dir` pointing to a separate directory.

**First-time setup** (copy your Chrome profile once):
```bash
# macOS
mkdir -p ~/.z-agent-browser
cp -R "$HOME/Library/Application Support/Google/Chrome" ~/.z-agent-browser/chrome-profile

# Linux
cp -R ~/.config/google-chrome ~/.z-agent-browser/chrome-profile
```

**Launch Chrome with CDP**:
```bash
# 1. Quit all Chrome instances
pkill -9 "Google Chrome"

# 2. Launch Chrome with debugging + custom profile
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --remote-debugging-port=9222 \
  --user-data-dir="$HOME/.z-agent-browser/chrome-profile" &

# 3. z-agent-browser auto-connects!
z-agent-browser open "https://github.com"  # You're logged in!
```

**When to use which:**

| Use Case | Recommended Mode |
|----------|------------------|
| Background automation | State Save/Load (headless) |
| User needs to see what's happening | `start --headed` |
| Sites needing saved Chrome passwords | CDP Mode |
| User needs to interact (CAPTCHA, 2FA) | CDP Mode |
| **Google/Gmail** | **CDP Mode** (detects headless) |

## Core Workflow

1. `z-agent-browser open <url>` - Navigate to page
2. `z-agent-browser snapshot -i` - Get interactive elements with refs (@e1, @e2)
3. Interact using refs from snapshot
4. Re-snapshot after navigation or DOM changes

## Key Features

| Feature | Command |
|---------|---------|
| Navigate | `open <url>` |
| Get elements | `snapshot -i` |
| Click | `click @e1` |
| Fill input | `fill @e2 "text"` |
| Screenshot | `screenshot [path]` |
| Headed mode | `open <url> --headed` |
| Connect CDP | `connect 9222` |
| Close | `close` |

## Important Notes

**Daemon behavior**: z-agent-browser runs as a persistent daemon. To switch modes, close first with `z-agent-browser close`.

**When to use headed mode**: Use `--headed` when user needs to log in manually, solve CAPTCHAs, or verify visual state.

## Enhanced Features

| Feature | Usage |
|---------|-------|
| Stealth mode | `--stealth` or `AGENT_BROWSER_STEALTH=1` |
| State save | `state save ~/.z-agent-browser/site.json` |
| State load | `state load ~/.z-agent-browser/site.json` |
| CDP mode | `connect 9222` (for real Chrome) |
| Video recording | `record start ./demo.webm` / `record stop` |

## Full Documentation

- [skill.md](skills/browser-automation/skill.md) - AI agent instructions
- [reference.md](skills/browser-automation/reference.md) - Complete command reference

## License

MIT
