---
description: "Browse the web with z-agent-browser CLI"
argument-hint: "[url]"
---

# Browser Automation

When user wants to browse the web:

1. **Check if persist is enabled** (auto-loads saved cookies):
   ```bash
   echo $AGENT_BROWSER_PERSIST
   ```

2. **Open the URL**:
   ```bash
   z-agent-browser open "<url>"
   ```

3. **Get interactive elements**:
   ```bash
   z-agent-browser snapshot -i
   ```

4. **Interact using refs** from snapshot (@e1, @e2, etc.):
   ```bash
   z-agent-browser click @e1
   z-agent-browser fill @e2 "text"
   ```

5. **Re-snapshot after navigation** or DOM changes

## If login is needed

Open headed so user can log in manually:
```bash
z-agent-browser open "<url>" --headed
```

Then save auth for future sessions:
```bash
z-agent-browser state save ~/.browser/auth.json
z-agent-browser close
```

## Key commands

| Action | Command |
|--------|---------|
| Navigate | `z-agent-browser open <url>` |
| Get elements | `z-agent-browser snapshot -i` |
| Click | `z-agent-browser click @ref` |
| Fill | `z-agent-browser fill @ref "text"` |
| Close | `z-agent-browser close` |

For full reference, see [skill.md](../skills/browser-automation/skill.md).
