---
description: "Browse the web, fill forms, manage sessions. Usage: /browser [url] or /browser connect"
argument-hint: "[url|connect|disconnect|status]"
---

# Browser Automation

@skills/browser-automation/skill.md

## Command Usage

Based on the argument provided:

### `/browser [url]`
Navigate to URL and take snapshot:
```
browser_connect()
browser_open({ url: "[url]" })
browser_snapshot({ interactive: true })
```

### `/browser connect`
Connect to Chrome (headed mode):
```
browser_connect()
```

### `/browser disconnect`  
Switch to headless mode:
```
browser_disconnect()
```

### `/browser status`
Check browser and auth state:
```
browser_state_exists()
```
Report whether auth is saved and if Chrome is running.

### `/browser save`
Save current auth state:
```
browser_state_save()
```

### `/browser load`
Load saved auth state:
```
browser_state_load()
```
