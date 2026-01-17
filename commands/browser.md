---
description: "Browse the web with z-agent-browser CLI"
argument-hint: "<url>"
---

# Browser Automation

Automate web browsing using z-agent-browser CLI.

## How It Works

z-agent-browser supports multiple browser modes:

| Mode | Command | Best For |
|------|---------|----------|
| **Headless** | `start` | Background automation |
| **Headed** | `start --headed` | When user needs to watch/login |
| **Stealth** | `start --stealth` | Sites with bot detection |
| **CDP** | `connect 9222` | Interactive debugging, real Chrome |

## Execution Protocol

### Phase 0: Prerequisites (First Run Only)

**Check if z-agent-browser is installed:**

```bash
which z-agent-browser || echo "NOT INSTALLED"
```

**If not installed**, install it:

```bash
npm install -g z-agent-browser
z-agent-browser install
```

### Recommended: Use `start` Command

The `start` command configures browser mode explicitly (auto-restarts if already running):

```bash
# Background automation (headless)
z-agent-browser start
z-agent-browser open "$ARGUMENTS"

# User needs to watch or login
z-agent-browser start --headed
z-agent-browser open "$ARGUMENTS"

# With anti-detection (sites that block bots)
z-agent-browser start --stealth
z-agent-browser open "$ARGUMENTS"
```

**Check current mode:** `z-agent-browser status`

### Login Persistence (State Save/Load)

To persist logins across sessions:

```bash
# First time: Login manually in headed mode
z-agent-browser start --headed
z-agent-browser open "https://site.com"
# [User logs in manually]
z-agent-browser state save ~/.z-agent-browser/site.json
z-agent-browser stop

# Later: Restore session headlessly
z-agent-browser start
z-agent-browser state load ~/.z-agent-browser/site.json
z-agent-browser open "https://site.com"  # Already logged in!
```

### Alternative: CDP Mode (Interactive)

**For interactive use** where user needs their real Chrome with saved passwords:

Tell user: "I'll connect to your Chrome browser. I need to close Chrome first - save any work!"

Wait for user confirmation, then:

```bash
# Quit existing Chrome
pkill -9 "Google Chrome" 2>/dev/null || true
sleep 1

# Launch Chrome with debugging (visible browser)
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --remote-debugging-port=9222 &

sleep 2

# Connect z-agent-browser
z-agent-browser connect 9222
```

Tell user: "Connected to your Chrome with all your existing logins!"

**Only if user explicitly requests "fresh browser" or "isolated":**

```bash
z-agent-browser close  # Kill daemon first
z-agent-browser open "$ARGUMENTS" --headed
```

This opens isolated Chromium with no saved logins.

### Phase 1: Navigate to URL

```bash
z-agent-browser open "$ARGUMENTS"
```

If Chrome is running on port 9222, z-agent-browser auto-connects to it.

### Phase 2: Get Page State

```bash
z-agent-browser snapshot -i
```

Returns elements with refs like `@e1`, `@e2` for interaction.

### Phase 3: Interact

Use refs from snapshot:

```bash
z-agent-browser click @e1           # Click element
z-agent-browser fill @e2 "text"     # Clear and type
z-agent-browser press Enter         # Press key
```

**Re-snapshot after navigation or DOM changes.**

### Phase 4: Handle Login (If Needed)

If page requires login that can't be automated:

1. **Open headed browser**:
   ```bash
   z-agent-browser close
   z-agent-browser open "$URL" --headed
   ```

2. **Tell user to log in** in the visible browser window

3. **Continue after login**:
   ```bash
   z-agent-browser snapshot -i
   ```

## Quick Reference

| Action | Command |
|--------|---------|
| Start headless | `z-agent-browser start` |
| Start headed | `z-agent-browser start --headed` |
| Start with stealth | `z-agent-browser start --stealth` |
| Check mode | `z-agent-browser status` |
| Navigate | `z-agent-browser open <url>` |
| Get elements | `z-agent-browser snapshot -i` |
| Click | `z-agent-browser click @ref` |
| Fill | `z-agent-browser fill @ref "text"` |
| Press key | `z-agent-browser press Enter` |
| Screenshot | `z-agent-browser screenshot` |
| Save login state | `z-agent-browser state save <path>` |
| Load login state | `z-agent-browser state load <path>` |
| Stop browser | `z-agent-browser stop` |
| Connect to Chrome (CDP) | `z-agent-browser connect 9222` |

## Important Notes

- **State save/load** - Saves cookies, localStorage, sessionStorage to JSON file
- **CDP Mode** - For real Chrome with saved passwords (headless/headed depends on how Chrome was launched)
- **Always re-snapshot** after clicks that cause navigation
- **Use refs** (`@e1`) not CSS selectors

For full reference, see [skill.md](../skills/browser-automation/skill.md).
