---
description: "Browse the web with z-agent-browser CLI"
argument-hint: "<url>"
---

# Browser Automation

Automate web browsing using z-agent-browser CLI. Uses system Chrome by default, falls back to bundled Chromium.

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

**Ensure auth persistence is configured:**

```bash
if [ -z "$AGENT_BROWSER_PERSIST" ]; then
  if ! grep -q "AGENT_BROWSER_PERSIST" ~/.zshrc 2>/dev/null; then
    echo 'export AGENT_BROWSER_PERSIST=1' >> ~/.zshrc
    echo "Added AGENT_BROWSER_PERSIST=1 to ~/.zshrc"
  fi
  export AGENT_BROWSER_PERSIST=1
fi
echo "AGENT_BROWSER_PERSIST=$AGENT_BROWSER_PERSIST"
```

**Check if credentials exist:**

```bash
ls ~/.z-agent-browser/state/ 2>/dev/null || echo "NO_SAVED_AUTH"
```

**If NO_SAVED_AUTH**, prompt user with options:

> "This is your first time using browser automation. How would you like to set up authentication?
> 
> **Option 1: Import Chrome profile** (recommended) - Copies all your existing logins, cookies, localStorage, and saved passwords from Chrome.
> 
> **Option 2: Fresh login** - Log into sites manually in a new browser window.
> 
> Which do you prefer?"

**If Option 1 (Import Chrome profile):**

```bash
# Quit Chrome first
pkill -9 "Google Chrome" 2>/dev/null || true

# Copy profile
cp -R "$HOME/Library/Application Support/Google/Chrome" /tmp/chrome-profile-copy

# Launch with debugging
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --remote-debugging-port=9222 \
  --user-data-dir="/tmp/chrome-profile-copy" &

# Wait for Chrome to start
sleep 2

# Connect z-agent-browser
z-agent-browser connect 9222
```

Tell user: "Connected to your Chrome profile with all your existing logins!"

**If Option 2 (Fresh login):**

```bash
z-agent-browser open "$ARGUMENTS" --headed
```

Tell user: "Please log into any accounts you need. Let me know when you're done."

After user confirms:
```bash
z-agent-browser close
```

State auto-saves with PERSIST=1. Continue to Phase 1.

### Phase 1: Open URL

Navigate to the target URL:

```bash
z-agent-browser open "$ARGUMENTS"
```

**If daemon is already running in different mode**, close first:
```bash
z-agent-browser close
z-agent-browser open "$ARGUMENTS"
```

### Phase 2: Get Page State

Get interactive elements with refs:

```bash
z-agent-browser snapshot -i
```

This returns elements with refs like `@e1`, `@e2` for interaction.

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

1. **Close daemon and reopen headed**:
   ```bash
   z-agent-browser close
   z-agent-browser open "$URL" --headed
   ```

2. **Tell user to log in** in the visible browser window

3. **Save auth state** after user completes login:
   ```bash
   z-agent-browser state save ~/.z-agent-browser/auth.json
   ```

4. **Close and continue headless**:
   ```bash
   z-agent-browser close
   z-agent-browser open "$URL"  # Auth restored if AGENT_BROWSER_PERSIST=1
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
| Close | `z-agent-browser close` |
| Save auth | `z-agent-browser state save <path>` |

## Important Notes

- **Daemon locks mode at startup**: Can't switch headed/headless without closing
- **Always re-snapshot** after clicks that cause navigation
- **Use refs** (`@e1`) not CSS selectors
- Enable `AGENT_BROWSER_PERSIST=1` for auto-save/restore cookies

For full reference, see [skill.md](../skills/browser-automation/skill.md).
