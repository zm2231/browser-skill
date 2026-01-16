---
name: browser-automation
description: Automates browser interactions for web testing, form filling, screenshots, video recording, and data extraction. Use when user needs to navigate websites, interact with web pages, fill forms, take screenshots, test web applications, or extract information from web pages.
requires:
  bins: [z-agent-browser]
  platform: darwin
---

# Browser Automation with z-agent-browser

## Setup (First Time Only)

```bash
# Enhanced fork (recommended): stealth mode, auto-persistence, profile mode
git clone https://github.com/zm2231/agent-browser.git /tmp/agent-browser-install
cd /tmp/agent-browser-install
pnpm install && pnpm build && pnpm build:native && npm link
z-agent-browser install
mkdir -p ~/.browser

# Or upstream npm (basic features only):
# npm install -g z-agent-browser && z-agent-browser install && mkdir -p ~/.browser
```

## Quick Start

```bash
z-agent-browser open <url>        # Navigate to page
z-agent-browser snapshot -i       # Get interactive elements with refs
z-agent-browser click @e1         # Click element by ref
z-agent-browser fill @e2 "text"   # Fill input by ref
z-agent-browser close             # Close browser
```

## Core Workflow

1. Navigate: `z-agent-browser open <url>`
2. Snapshot: `z-agent-browser snapshot -i` (returns elements with refs like `@e1`, `@e2`)
3. Interact using refs from the snapshot
4. Re-snapshot after navigation or significant DOM changes

## Modes

### Headless (Default)
Fast, invisible, good for scraping and automation.
```bash
z-agent-browser open "https://example.com"
```

### Headed (Visible Window)
User can watch and assist with login or captcha.
```bash
z-agent-browser open "https://example.com" --headed
```

### CDP (Connect to Existing Chrome)
For persistent Chrome that survives between sessions; requires Chrome launched with `--remote-debugging-port=9222`.
```bash
z-agent-browser --cdp 9222 open "https://example.com"
```

### CDP with `connect` Command (Enhanced Fork)
If using the enhanced fork (zm2231/agent-browser), use `connect` once then omit `--cdp`:
```bash
z-agent-browser connect 9222
z-agent-browser open "https://example.com"   # no --cdp needed
z-agent-browser snapshot -i
z-agent-browser close
```

## Commands

### Navigation
```bash
z-agent-browser open <url>      # Navigate to URL
z-agent-browser open <url> --headed  # With visible window
z-agent-browser back            # Go back
z-agent-browser forward         # Go forward
z-agent-browser reload          # Reload page
z-agent-browser close           # Close browser
```

### Snapshot (Page Analysis)
```bash
z-agent-browser snapshot            # Full accessibility tree
z-agent-browser snapshot -i         # Interactive elements only (recommended)
z-agent-browser snapshot -c         # Compact output
z-agent-browser snapshot -d 3       # Limit depth to 3
z-agent-browser snapshot -s "#main" # Scope to CSS selector
```

### Interactions (Use @refs from Snapshot)
```bash
z-agent-browser click @e1           # Click
z-agent-browser dblclick @e1        # Double-click
z-agent-browser focus @e1           # Focus element
z-agent-browser fill @e2 "text"     # Clear and type
z-agent-browser type @e2 "text"     # Type without clearing
z-agent-browser press Enter         # Press key
z-agent-browser press Control+a     # Key combination
z-agent-browser keydown Shift       # Hold key down
z-agent-browser keyup Shift         # Release key
z-agent-browser hover @e1           # Hover
z-agent-browser check @e1           # Check checkbox
z-agent-browser uncheck @e1         # Uncheck checkbox
z-agent-browser select @e1 "value"  # Select dropdown
z-agent-browser scroll down 500     # Scroll page
z-agent-browser scrollintoview @e1  # Scroll element into view
z-agent-browser drag @e1 @e2        # Drag and drop
z-agent-browser upload @e1 file.pdf # Upload files
```

### Get Information
```bash
z-agent-browser get text @e1        # Get element text
z-agent-browser get html @e1        # Get innerHTML
z-agent-browser get value @e1       # Get input value
z-agent-browser get attr @e1 href   # Get attribute
z-agent-browser get title           # Get page title
z-agent-browser get url             # Get current URL
z-agent-browser get count ".item"   # Count matching elements
z-agent-browser get box @e1         # Get bounding box
```

### Check State
```bash
z-agent-browser is visible @e1      # Check if visible
z-agent-browser is enabled @e1      # Check if enabled
z-agent-browser is checked @e1      # Check if checked
```

### Screenshots, PDF, and Video
```bash
z-agent-browser screenshot              # Screenshot to stdout
z-agent-browser screenshot path.png     # Save to file
z-agent-browser screenshot --full       # Full page
z-agent-browser pdf output.pdf          # Save as PDF
z-agent-browser record start ./demo.webm    # Start video recording
z-agent-browser record stop                 # Stop and save video
z-agent-browser record restart ./take2.webm # Stop current, start new
```

Recording creates a fresh context but preserves cookies and storage from your session. If no URL is provided it automatically returns to your current page.

### Wait
```bash
z-agent-browser wait @e1                     # Wait for element
z-agent-browser wait 2000                    # Wait milliseconds
z-agent-browser wait --text "Success"        # Wait for text
z-agent-browser wait --url "**/dashboard"    # Wait for URL pattern
z-agent-browser wait --load networkidle      # Wait for network idle
z-agent-browser wait --fn "window.ready"     # Wait for JS condition
```

### Auth State (Persist Logins)
```bash
z-agent-browser state save ~/.browser/auth.json    # Save cookies, localStorage, sessionStorage
z-agent-browser state load ~/.browser/auth.json    # Load saved state (works at runtime!)
```

### Stealth Mode (Enhanced Fork)
```bash
z-agent-browser --stealth open "https://bot.sannysoft.com"  # Bypass bot detection
```
Uses playwright-extra with stealth plugin. Evades WebDriver detection, Chrome automation flags, and other fingerprinting.

### Auto-Persistence (Enhanced Fork)
```bash
z-agent-browser --persist open "https://example.com"  # Auto-save/load state
z-agent-browser --state ~/auth.json open "https://example.com"  # Explicit state file
```

### Profile Mode (Enhanced Fork)
```bash
z-agent-browser --profile ~/.browser/my-profile open "https://example.com"
```
Use a persistent Chrome profile directory (keeps extensions, bookmarks, passwords).

### HTTPS Errors (Enhanced Fork)
```bash
z-agent-browser --ignore-https-errors open "https://localhost:8443"
```
Skip certificate validation for local dev servers with self-signed certs.

### Sessions (Parallel Browsers)
```bash
z-agent-browser --session test1 open site-a.com
z-agent-browser --session test2 open site-b.com
z-agent-browser session list
```

Each session has its own browser instance, cookies, storage, and history.

### Mouse Control
```bash
z-agent-browser mouse move 100 200      # Move mouse
z-agent-browser mouse down left         # Press button
z-agent-browser mouse up left           # Release button
z-agent-browser mouse wheel 100         # Scroll wheel
```

### Semantic Locators (Alternative to Refs)
```bash
z-agent-browser find role button click --name "Submit"
z-agent-browser find text "Sign In" click
z-agent-browser find label "Email" fill "user@test.com"
z-agent-browser find first ".item" click
z-agent-browser find nth 2 "a" text
```

### Browser Settings
```bash
z-agent-browser set viewport 1920 1080      # Set viewport size
z-agent-browser set device "iPhone 14"      # Emulate device
z-agent-browser set geo 37.7749 -122.4194   # Set geolocation
z-agent-browser set offline on              # Toggle offline mode
z-agent-browser set headers '{"X-Key":"v"}' # Extra HTTP headers
z-agent-browser set credentials user pass   # HTTP basic auth
z-agent-browser set media dark              # Emulate color scheme
```

### Cookies and Storage
```bash
z-agent-browser cookies                     # Get all cookies
z-agent-browser cookies set name value      # Set cookie
z-agent-browser cookies clear               # Clear cookies
z-agent-browser storage local               # Get all localStorage
z-agent-browser storage local key           # Get specific key
z-agent-browser storage local set k v       # Set value
z-agent-browser storage local clear         # Clear all
```

### Network
```bash
z-agent-browser network route <url>              # Intercept requests
z-agent-browser network route <url> --abort      # Block requests
z-agent-browser network route <url> --body '{}'  # Mock response
z-agent-browser network unroute [url]            # Remove routes
z-agent-browser network requests                 # View tracked requests
z-agent-browser network requests --filter api    # Filter requests
```

### Tabs and Windows
```bash
z-agent-browser tab                 # List tabs
z-agent-browser tab new [url]       # New tab
z-agent-browser tab 2               # Switch to tab
z-agent-browser tab close           # Close tab
z-agent-browser window new          # New window
```

### Frames
```bash
z-agent-browser frame "#iframe"     # Switch to iframe
z-agent-browser frame main          # Back to main frame
```

### Dialogs
```bash
z-agent-browser dialog accept [text]  # Accept dialog
z-agent-browser dialog dismiss        # Dismiss dialog
```

### JavaScript
```bash
z-agent-browser eval "document.title"   # Run JavaScript
```

### Debugging
```bash
z-agent-browser open example.com --headed   # Show browser window
z-agent-browser console                     # View console messages
z-agent-browser console --clear             # Clear console
z-agent-browser errors                      # View page errors
z-agent-browser errors --clear              # Clear errors
z-agent-browser highlight @e1               # Highlight element
z-agent-browser trace start                 # Start recording trace
z-agent-browser trace stop trace.zip        # Stop and save trace
```

## Example: Form Submission

```bash
z-agent-browser open https://example.com/form
z-agent-browser snapshot -i
# Output shows: textbox "Email" [ref=e1], textbox "Password" [ref=e2], button "Submit" [ref=e3]

z-agent-browser fill @e1 "user@example.com"
z-agent-browser fill @e2 "password123"
z-agent-browser click @e3
z-agent-browser wait --load networkidle
z-agent-browser snapshot -i
```

## Example: Authentication with Saved State

```bash
# First time: log in manually with headed mode
z-agent-browser open https://app.example.com/login --headed
z-agent-browser snapshot -i
z-agent-browser fill @e1 "username"
z-agent-browser fill @e2 "password"
z-agent-browser click @e3
z-agent-browser wait --url "**/dashboard"
z-agent-browser state save ~/.browser/auth.json

# Later sessions: load saved state
z-agent-browser state load ~/.browser/auth.json
z-agent-browser open https://app.example.com/dashboard
```

## Example: Human-in-the-Loop Login

When a site requires login and you need user assistance:

```bash
z-agent-browser open "https://github.com/login" --headed
z-agent-browser snapshot -i
# If snapshot shows login form, tell user:
# "Please sign into GitHub in the Chrome window. Let me know when done."
# After user confirms:
z-agent-browser state save ~/.browser/auth-github.json
```

## Example: Video Recording Demo

```bash
z-agent-browser open https://example.com --headed
# Explore the site first to find what you want to record
z-agent-browser snapshot -i
z-agent-browser click @e1

# When ready, start recording (preserves cookies, returns to current page)
z-agent-browser record start ./demo.webm
z-agent-browser fill @e2 "demo input"
z-agent-browser click @e3
z-agent-browser wait --load networkidle
z-agent-browser record stop
# Video saved to ./demo.webm
```

## JSON Output (For Parsing)

Add `--json` for machine-readable output:
```bash
z-agent-browser snapshot -i --json
z-agent-browser get text @e1 --json
```

## Data Locations

| Path | Purpose |
|------|---------|
| `~/.browser/auth.json` | Default saved auth state |
| `~/.browser/auth-{site}.json` | Per-site auth (optional) |
| `~/.browser/chrome-profile/` | CDP mode Chrome data |
| `~/.z-agent-browser/sessions/` | Auto-persist state files (--persist flag) |
| `/tmp/chrome-profile-copy/` | Copied Chrome profile (see below) |

## Import Existing Chrome Logins

Chrome blocks remote debugging on your default profile for security. To use your existing logins, copy your profile:

```bash
# 1. Quit all Chrome instances
pkill -9 "Google Chrome"

# 2. Copy your Chrome profile
cp -R "$HOME/Library/Application Support/Google/Chrome" /tmp/chrome-profile-copy

# 3. Launch Chrome with debugging using the copy
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --remote-debugging-port=9222 \
  --user-data-dir="/tmp/chrome-profile-copy" &

# 4. Connect z-agent-browser
z-agent-browser --cdp 9222 open "https://github.com"
z-agent-browser snapshot -i
```

The copy includes all your cookies, saved passwords, localStorage, extensions, and settings. Note: changes in the copied profile do not sync back to your real Chrome.

### Alternative: Use Chrome Canary

Run Chrome Canary for automation while keeping your main Chrome open:

```bash
"/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary" \
  --remote-debugging-port=9222 \
  --user-data-dir="/tmp/chrome-canary-automation" &

z-agent-browser --cdp 9222 open "https://example.com"
```

## Tips

1. Always use `snapshot -i` to reduce output size (interactive elements only)
2. Use refs from snapshot (@e1, @e2) rather than CSS selectors when possible
3. Re-snapshot after any navigation or action that changes the page
4. Save auth state after login so users do not need to log in again
5. Use `--headed` when you need user assistance with login or captcha
6. The daemon persists between commands so the browser stays alive automatically
