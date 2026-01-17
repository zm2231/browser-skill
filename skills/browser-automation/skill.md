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

## Important Notes

**Daemon behavior**: The browser runs as a persistent daemon. Environment variables (headed, stealth, etc.) are set at daemon startup and cannot be changed mid-session.

**Mode switching**: Close the browser to switch between headed/headless modes:
```bash
z-agent-browser open "https://site.com" --headed   # Headed session
z-agent-browser state save ~/.browser/auth.json
z-agent-browser close                              # Kill daemon

z-agent-browser state load ~/.browser/auth.json    # Fresh daemon (headless)
z-agent-browser open "https://site.com"            # Cookies preserved
```

**When to use headed mode**: Use `--headed` when you need the user to:
- Log in manually (captchas, 2FA, OAuth)
- Solve CAPTCHAs
- Verify visual state
- Debug issues

## Core Workflow

1. Navigate: `z-agent-browser open <url>`
2. Snapshot: `z-agent-browser snapshot -i` (returns elements with refs like `@e1`, `@e2`)
3. Interact using refs from snapshot
4. Re-snapshot after navigation or DOM changes

## Quick Reference

```bash
# Navigation
z-agent-browser open <url>        # Navigate
z-agent-browser back              # Go back
z-agent-browser close             # Close browser

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

## Auth Persistence

```bash
# Save after login
z-agent-browser state save ~/.browser/auth.json

# Load in future sessions
z-agent-browser state load ~/.browser/auth.json
z-agent-browser open "https://app.example.com"
```

## Backend Modes

Two backends available. Commands work the same for both.

### Native Mode (Default)

Launches dedicated Chromium. Full feature support.

```bash
z-agent-browser open "https://example.com"
```

### Playwright MCP Mode

Controls your existing Chrome via Playwright MCP extension. Useful for:
- Using your logged-in sessions and extensions
- Watching AI actions in real-time

```bash
export PLAYWRIGHT_MCP_EXTENSION_TOKEN=your-token
export AGENT_BROWSER_BACKEND=playwright-mcp
z-agent-browser open "https://example.com"
```

**Setup**: Install "Playwright MCP Bridge" Chrome extension, click icon to get token.

**Limitations**: Some features unavailable (scroll, get text/html, video recording, state save/load). See [reference.md](reference.md) for full compatibility.

## Tips

1. Always use `snapshot -i` to reduce output size
2. Use refs (@e1, @e2) rather than CSS selectors
3. Re-snapshot after navigation or DOM changes
4. Save auth state after successful login
5. Use `--headed` when you need user assistance
6. Kill daemon before changing env vars: `z-agent-browser close`
