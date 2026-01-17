---
description: "Browse the web with z-agent-browser CLI"
argument-hint: "<url>"
---

# Browser Automation

Automate web browsing using z-agent-browser CLI.

## CRITICAL: Browser Profiles

`z-agent-browser open` uses your system Chrome binary but with an **isolated profile** (no existing logins).

**To use existing logins**, you MUST connect to Chrome with a profile copy. Always do this unless user explicitly requests "fresh/isolated browser".

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

**Check if already connected to Chrome:**

```bash
z-agent-browser get url 2>/dev/null && echo "CONNECTED" || echo "NOT_CONNECTED"
```

**If NOT_CONNECTED**, set up Chrome profile (default):

Tell user: "I'll connect to your Chrome browser with all your existing logins. I need to close Chrome first - save any work!"

Wait for user confirmation, then:

```bash
# Quit Chrome
pkill -9 "Google Chrome" 2>/dev/null || true
sleep 1

# Copy profile to temp location
cp -R "$HOME/Library/Application Support/Google/Chrome" /tmp/chrome-profile-copy

# Launch Chrome with debugging
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --remote-debugging-port=9222 \
  --user-data-dir="/tmp/chrome-profile-copy" &

sleep 2

# Connect z-agent-browser
z-agent-browser connect 9222
```

Tell user: "Connected to your Chrome with all your existing logins!"

**Only if user explicitly requests "fresh browser" or "Chrome for Testing":**

```bash
z-agent-browser open "$ARGUMENTS" --headed
```

This opens isolated Chromium with no saved logins.

### Phase 1: Navigate to URL

After Chrome is connected, navigate:

```bash
z-agent-browser open "$ARGUMENTS"
```

This navigates the connected Chrome (with your logins) to the target URL.

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

- **NEVER use Chrome for Testing** unless user explicitly requests it - always connect to their real Chrome
- **Always re-snapshot** after clicks that cause navigation
- **Use refs** (`@e1`) not CSS selectors
- Chrome profile copy preserves all logins, cookies, localStorage, extensions

For full reference, see [skill.md](../skills/browser-automation/skill.md).
