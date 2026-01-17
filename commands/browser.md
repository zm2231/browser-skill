---
description: "Browse the web with z-agent-browser CLI"
argument-hint: "<url>"
---

# Browser Automation

Automate web browsing using z-agent-browser CLI.

## How It Works

z-agent-browser now **auto-detects** Chrome on port 9222. If Chrome is running with `--remote-debugging-port=9222`, it connects automatically with all your logins.

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

**Check if already connected to Chrome:**

```bash
z-agent-browser get url 2>/dev/null && echo "CONNECTED" || echo "NOT_CONNECTED"
```

**If NOT_CONNECTED**, set up Chrome with your profile:

Tell user: "I'll connect to your Chrome browser with all your existing logins. I need to close Chrome first - save any work!"

Wait for user confirmation, then:

```bash
# Quit existing Chrome
pkill -9 "Google Chrome" 2>/dev/null || true
sleep 1

# Copy profile to persistent location
PROFILE="$HOME/.z-agent-browser/chrome-profile"
mkdir -p "$HOME/.z-agent-browser"
cp -R "$HOME/Library/Application Support/Google/Chrome" "$PROFILE"

# Launch Chrome with debugging
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --remote-debugging-port=9222 \
  --user-data-dir="$PROFILE" &

sleep 2

# Connect z-agent-browser (or it will auto-connect on first command)
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
| Navigate | `z-agent-browser open <url>` |
| Navigate (visible) | `z-agent-browser open <url> --headed` |
| Get elements | `z-agent-browser snapshot -i` |
| Click | `z-agent-browser click @ref` |
| Fill | `z-agent-browser fill @ref "text"` |
| Press key | `z-agent-browser press Enter` |
| Screenshot | `z-agent-browser screenshot` |
| Close daemon | `z-agent-browser close` |
| Connect to Chrome | `z-agent-browser connect 9222` |

## Important Notes

- **CDP Auto-detection**: z-agent-browser checks port 9222 first - if Chrome is there, it connects
- **Profile location**: `~/.z-agent-browser/chrome-profile`
- **Always re-snapshot** after clicks that cause navigation
- **Use refs** (`@e1`) not CSS selectors
- Chrome profile copy preserves all logins, cookies, localStorage, extensions

For full reference, see [skill.md](../skills/browser-automation/skill.md).
