---
description: "Browse the web, fill forms, manage sessions. Usage: /browser [url] or /browser status"
argument-hint: "[url|status|save|load|close]"
---

# Browser Automation

For complete details, see [browser-automation skill](../skills/browser-automation/skill.md).

## Command Usage

### `/browser [url]`
Navigate to URL and get interactive elements:
```bash
z-agent-browser open "[url]"
z-agent-browser snapshot -i
```

### `/browser [url] --headed`
Open visible browser (for manual login):
```bash
z-agent-browser open "[url]" --headed
z-agent-browser snapshot -i
```

### `/browser status`
Check if browser is running:
```bash
z-agent-browser session
```

### `/browser save [path]`
Save auth state (cookies, localStorage):
```bash
z-agent-browser state save ~/.browser/auth.json
```

### `/browser load [path]`
Load saved auth state:
```bash
z-agent-browser state load ~/.browser/auth.json
```

### `/browser close`
Close browser daemon:
```bash
z-agent-browser close
```

## Quick Reference

```bash
z-agent-browser open <url>        # Navigate
z-agent-browser snapshot -i       # Get elements with refs (@e1, @e2)
z-agent-browser click @e1         # Click by ref
z-agent-browser fill @e2 "text"   # Fill input
z-agent-browser close             # Close browser
```
