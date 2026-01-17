---
name: browser-automation
description: Automates browser interactions for web testing, form filling, screenshots, video recording, and data extraction. Use when user needs to navigate websites, interact with web pages, fill forms, take screenshots, test web applications, or extract information from web pages.
requires:
  bins: [z-agent-browser]
  platform: darwin
---

# Browser Automation with z-agent-browser

## Setup

```bash
npm install -g z-agent-browser
z-agent-browser install
```

## CDP Auto-Detection (New!)

z-agent-browser now **auto-detects** Chrome on port 9222:
- If Chrome is running with `--remote-debugging-port=9222` → auto-connects with your logins
- If no Chrome on 9222 → launches fresh isolated browser

This means if you set up Chrome once with your profile, z-agent-browser will use it automatically.

## Core Workflow

1. Navigate: `z-agent-browser open <url>`
2. Snapshot: `z-agent-browser snapshot -i` (returns refs like `@e1`, `@e2`)
3. Interact using refs from snapshot
4. Re-snapshot after navigation or DOM changes

## Quick Reference

```bash
# Navigation
z-agent-browser open <url>           # Auto-connects to Chrome on 9222 if available
z-agent-browser open <url> --headed  # Force visible browser
z-agent-browser back                 # Go back
z-agent-browser close                # Close browser daemon

# Inspection
z-agent-browser snapshot -i          # Interactive elements (recommended)
z-agent-browser screenshot [path]    # Screenshot

# Interaction (use @refs from snapshot)
z-agent-browser click @e1            # Click
z-agent-browser fill @e2 "text"      # Clear and type
z-agent-browser type @e2 "text"      # Type without clearing
z-agent-browser press Enter          # Press key
z-agent-browser select @e1 "val"     # Select dropdown

# Tabs
z-agent-browser tab                  # List tabs
z-agent-browser tab new [url]        # New tab

# Debug
z-agent-browser console              # View console
z-agent-browser eval "js code"       # Run JavaScript
```

For complete command reference, see [reference.md](reference.md).

## Using Your Chrome Logins

To browse with all your existing logins, set up Chrome with CDP once:

```bash
# 1. Quit existing Chrome
pkill -9 "Google Chrome"

# 2. Copy profile
cp -R "$HOME/Library/Application Support/Google/Chrome" ~/.z-agent-browser/chrome-profile

# 3. Launch Chrome with debugging
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --remote-debugging-port=9222 \
  --user-data-dir="$HOME/.z-agent-browser/chrome-profile" &

# 4. Now z-agent-browser auto-connects!
z-agent-browser open "https://github.com"  # You're logged in!
```

Profile location: `~/.z-agent-browser/chrome-profile`

## Important Notes

1. **CDP Auto-detection**: Checks port 9222 first, uses Chrome if available
2. **Daemon behavior**: Browser runs as persistent daemon. Close with `z-agent-browser close`
3. **To change modes**: Close daemon first, then reopen
4. **Always use `snapshot -i`**: Reduces output size
5. **Use refs (@e1, @e2)**: Not CSS selectors
6. **Re-snapshot after navigation**: Refs change when page changes

## Tips

1. When user needs to log in manually → use `--headed` flag
2. For CAPTCHAs or 2FA → headed mode
3. Profile copy preserves: logins, cookies, localStorage, extensions
