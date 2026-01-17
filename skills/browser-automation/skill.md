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

**Enable auth persistence** (auto-configured on first `/browser` command):

```bash
export AGENT_BROWSER_PERSIST=1  # Add to ~/.zshrc if not present
```

This auto-saves/restores cookies between sessions.

## Default Behavior

**Auto-detects system Chrome** - Uses your installed Chrome/Chromium automatically. Falls back to bundled Chromium only if no system browser found.

## Important Notes

**Daemon behavior**: The browser runs as a persistent daemon. Settings (headed/headless, stealth, etc.) are locked at daemon startup.

**To change modes**: Close the daemon first, then reopen:
```bash
z-agent-browser close
z-agent-browser open "https://site.com" --headed   # Now in headed mode
```

**When to use headed mode**: 
- User needs to log in manually
- CAPTCHAs or 2FA
- Debugging visual issues

## Core Workflow

1. Navigate: `z-agent-browser open <url>`
2. Snapshot: `z-agent-browser snapshot -i` (returns refs like `@e1`, `@e2`)
3. Interact using refs from snapshot
4. Re-snapshot after navigation or DOM changes

## Quick Reference

```bash
# Navigation
z-agent-browser open <url>        # Navigate (headless by default)
z-agent-browser open <url> --headed  # Visible browser
z-agent-browser back              # Go back
z-agent-browser close             # Close browser daemon

# Inspection
z-agent-browser snapshot -i       # Interactive elements (recommended)
z-agent-browser screenshot [path] # Screenshot

# Interaction (use @refs from snapshot)
z-agent-browser click @e1         # Click
z-agent-browser fill @e2 "text"   # Clear and type
z-agent-browser type @e2 "text"   # Type without clearing
z-agent-browser press Enter       # Press key
z-agent-browser select @e1 "val"  # Select dropdown

# Tabs
z-agent-browser tab               # List tabs
z-agent-browser tab new [url]     # New tab

# Debug
z-agent-browser console           # View console
z-agent-browser eval "js code"    # Run JavaScript
```

For complete command reference, see [reference.md](reference.md).

## Auth Workflow

With `AGENT_BROWSER_PERSIST=1` set (recommended):

```bash
# First time: login in headed mode
z-agent-browser open "https://github.com/login" --headed
# User logs in manually...
z-agent-browser close   # Auth auto-saved

# Later: auth auto-restored
z-agent-browser open "https://github.com"   # Already logged in!
```

Without persist, use manual state save/load:
```bash
z-agent-browser state save ~/.browser/github.json
z-agent-browser state load ~/.browser/github.json
```

## Browser Modes

### System Chrome + Persist (Recommended)

Uses your actual Chrome with your cookies and extensions:

```bash
export AGENT_BROWSER_EXECUTABLE_PATH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
export AGENT_BROWSER_PERSIST=1
z-agent-browser open "https://example.com"
```

### Bundled Chromium (Default if no executable set)

Uses Playwright's "Chrome for Testing" - isolated, no existing cookies:

```bash
z-agent-browser open "https://example.com"
```

### CDP Mode (Control existing Chrome)

Connect to Chrome you launched with `--remote-debugging-port`:

```bash
# In another terminal:
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --remote-debugging-port=9222 &

# Connect:
z-agent-browser connect 9222
z-agent-browser open "https://example.com"
```

### Playwright MCP Mode (Experimental)

Control your daily-driver Chrome via extension:

```bash
export AGENT_BROWSER_BACKEND=playwright-mcp
export PLAYWRIGHT_MCP_EXTENSION_TOKEN=<from extension>
z-agent-browser open "https://example.com"
```

Limited feature support - see [reference.md](reference.md).

## Tips

1. Always use `snapshot -i` to reduce output size
2. Use refs (@e1, @e2) rather than CSS selectors
3. Re-snapshot after navigation or DOM changes
4. Use `--headed` when you need user assistance
5. Close daemon before changing modes: `z-agent-browser close`
