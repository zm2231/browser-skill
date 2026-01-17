---
name: browser-automation
description: Automates browser interactions for web testing, form filling, screenshots, and data extraction. Use when user needs to navigate websites, interact with web pages, fill forms, take screenshots, or extract information.
requires:
  bins: [z-agent-browser]
---

# Browser Automation with z-agent-browser

## Setup

```bash
npm install -g z-agent-browser
z-agent-browser install
```

## Core Workflow

1. **Start browser**: `z-agent-browser start [--headed] [--stealth]`
2. **Navigate**: `z-agent-browser open <url>`
3. **Snapshot**: `z-agent-browser snapshot -i` (returns refs like `@e1`, `@e2`)
4. **Interact** using refs from snapshot
5. **Re-snapshot** after navigation or DOM changes
6. **Stop**: `z-agent-browser stop` when done

## Quick Reference

```bash
# Browser Lifecycle
z-agent-browser start                # Start headless browser
z-agent-browser start --headed       # Start visible browser
z-agent-browser start --stealth      # Start with anti-detection (for Google/Gmail)
z-agent-browser status               # Check current mode
z-agent-browser stop                 # Stop browser

# Navigation
z-agent-browser open <url>           # Navigate to URL
z-agent-browser back                 # Go back

# Inspection
z-agent-browser snapshot -i          # Interactive elements (recommended)
z-agent-browser screenshot [path]    # Screenshot

# Interaction (use @refs from snapshot)
z-agent-browser click @e1            # Click
z-agent-browser fill @e2 "text"      # Clear and type
z-agent-browser type @e2 "text"      # Type without clearing
z-agent-browser press Enter          # Press key

# State Persistence (login sessions)
z-agent-browser state save <path>    # Save cookies/localStorage after login
z-agent-browser state load <path>    # Restore session

# Debug
z-agent-browser console              # View console
z-agent-browser eval "js code"       # Run JavaScript
```

For complete command reference, see [reference.md](reference.md).

## Login Persistence (Recommended Approach)

Use `state save/load` to persist login sessions across browser restarts:

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

## CDP Mode (Interactive - Real Chrome)

For interactive use where user needs to watch or intervene (CAPTCHA, 2FA):

```bash
# Launch Chrome with debugging
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --remote-debugging-port=9222 &

# Connect z-agent-browser
z-agent-browser connect 9222
z-agent-browser open "https://github.com"  # Uses your real Chrome with all logins
```

**When to use CDP vs state save/load:**

| Use Case | Recommended |
|----------|-------------|
| Background automation | `start` + `state load` |
| User needs to watch | `start --headed` |
| Google/Gmail (strict detection) | Hybrid workflow (below) |
| CAPTCHA, 2FA needed | CDP (real Chrome) |
| Interactive debugging | CDP |

## Gmail/Google Login (Hybrid Workflow)

Google detects Playwright (even stealth) and blocks login. Solution: login via real Chrome, capture state, use in Playwright stealth.

```bash
# 1. Copy Chrome profile (one-time)
cp -R "$HOME/Library/Application Support/Google/Chrome" ~/.z-agent-browser/cdp-profile

# 2. Launch real Chrome with CDP
killall "Google Chrome" 2>/dev/null || true
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --remote-debugging-port=9222 \
  --user-data-dir="$HOME/.z-agent-browser/cdp-profile" &

# 3. Connect and login if needed
z-agent-browser connect 9222
z-agent-browser open "https://mail.google.com"
# Login in Chrome window if not already logged in

# 4. Save state
z-agent-browser state save ~/.z-agent-browser/gmail-state.json
z-agent-browser close && killall "Google Chrome"

# 5. Use headless stealth with saved state
z-agent-browser start --stealth
z-agent-browser state load ~/.z-agent-browser/gmail-state.json
z-agent-browser open "https://mail.google.com"  # Logged in!
```

**Why this works:** Google validates during login (detecting bots), but accepts valid cookies afterward.

## Token Efficiency: eval vs snapshot

**Use `snapshot -i` for navigation** (finding what to click):
```bash
z-agent-browser snapshot -i   # ~200-500 tokens
```

**Use `eval` for data extraction** (getting information):
```bash
z-agent-browser eval "document.querySelectorAll('.item').length"
z-agent-browser eval "[...document.querySelectorAll('a')].map(a => a.href)"
```

| Task | Best Tool | Tokens |
|------|-----------|--------|
| Find button to click | `snapshot -i` | ~200-500 |
| Count items on page | `eval` | ~10 |
| Extract all emails | `eval` | ~50-100 |
| Fill a form | `snapshot -i` + refs | ~200-500 |

**Rule**: Need to CLICK? → snapshot. Need to READ/EXTRACT? → eval.

## Important Notes

1. **Use `start` command** to configure browser mode (auto-restarts if config differs)
2. **Check mode with `status`** to see current headless/stealth settings
3. **Always use `snapshot -i`** to reduce output size
4. **Use refs (@e1, @e2)** from snapshot, not CSS selectors
5. **Re-snapshot after navigation** - refs change when page changes
6. **Save state after login** - `state save` persists sessions
