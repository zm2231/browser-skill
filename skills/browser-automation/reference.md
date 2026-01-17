# Browser Automation Reference

Complete command reference for z-agent-browser CLI.

## Command Syntax

```bash
z-agent-browser [options] <command> [arguments]
```

### Global Options

| Option | Description |
|--------|-------------|
| `--headed` | Show visible browser window |
| `--cdp <port>` | Connect to Chrome via DevTools Protocol |
| `--session <name>` | Use isolated session |
| `--json` | Output as JSON (for automation) |
| `--debug` | Show debug output |

### Enhanced Fork Options

| Option | Description |
|--------|-------------|
| `--stealth` | Bypass bot detection (playwright-extra stealth plugin) |
| `--profile <path>` | Use persistent Chrome profile directory |
| `--ignore-https-errors` | Skip SSL certificate validation |
| `--persist` | Auto-save/load state to `~/.z-agent-browser/sessions/` |
| `--state <path>` | Use specific state file path |
| `--args <csv>` | Comma-separated browser launch args |
| `--user-agent <string>` | Custom User-Agent string |

---

## Navigation

```bash
z-agent-browser open <url> [--headed]     # Navigate to URL
z-agent-browser open <url> --headers '{"Authorization": "Bearer token"}'
z-agent-browser back                       # Go back
z-agent-browser forward                    # Go forward
z-agent-browser reload                     # Reload page
z-agent-browser close                      # Close browser
```

### Special URL Schemes (Enhanced Fork)

```bash
z-agent-browser open "about:blank"         # Blank page
z-agent-browser open "data:text/html,<h1>Hello</h1>"  # Data URL
z-agent-browser open "file:///path/to/file.html"     # Local file
```

---

## Inspection

```bash
z-agent-browser snapshot                   # Full accessibility tree
z-agent-browser snapshot -i                # Interactive elements only (recommended)
z-agent-browser snapshot -i -c             # Interactive + compact
z-agent-browser snapshot -d 3              # Limit depth to 3
z-agent-browser snapshot -s "#main"        # Scope to selector

z-agent-browser screenshot [path]          # Screenshot (default: /tmp)
z-agent-browser screenshot --full [path]   # Full page screenshot
z-agent-browser pdf <path>                 # Save as PDF

z-agent-browser get text <ref|selector>    # Get text content
z-agent-browser get html <ref|selector>    # Get innerHTML
z-agent-browser get value <ref|selector>   # Get input value
z-agent-browser get attr <ref> <attr>      # Get attribute (href, src, etc.)
z-agent-browser get title                  # Page title
z-agent-browser get url                    # Current URL
z-agent-browser get count <selector>       # Count matching elements
z-agent-browser get box <ref|selector>     # Bounding box
```

---

## Interaction

```bash
z-agent-browser click <ref|selector>       # Click element
z-agent-browser dblclick <ref|selector>    # Double-click
z-agent-browser fill <ref|selector> <text> # Clear and fill
z-agent-browser type <ref|selector> <text> # Type character by character
z-agent-browser press <key>                # Press key (Enter, Tab, Escape)
z-agent-browser press Control+a            # Key combo
z-agent-browser keydown <key>              # Hold key
z-agent-browser keyup <key>                # Release key
z-agent-browser hover <ref|selector>       # Hover over element
z-agent-browser focus <ref|selector>       # Focus element
z-agent-browser select <ref> <value>       # Select dropdown option
z-agent-browser check <ref|selector>       # Check checkbox
z-agent-browser uncheck <ref|selector>     # Uncheck checkbox
z-agent-browser drag <from> <to>           # Drag and drop
z-agent-browser upload <ref> <files>       # Upload files (comma-separated)
```

---

## Wait

```bash
z-agent-browser wait <selector>            # Wait for element visible
z-agent-browser wait <ms>                  # Wait milliseconds
z-agent-browser wait --text "Welcome"      # Wait for text to appear
z-agent-browser wait --url "**/dashboard"  # Wait for URL pattern
z-agent-browser wait --load networkidle    # Wait for network idle
z-agent-browser wait --load domcontentloaded
z-agent-browser wait --load load
z-agent-browser wait --fn "window.ready === true"  # Wait for JS condition
```

---

## State Checks

```bash
z-agent-browser is visible <ref|selector>  # Check if visible
z-agent-browser is enabled <ref|selector>  # Check if enabled
z-agent-browser is checked <ref|selector>  # Check if checked
```

---

## Semantic Locators

```bash
z-agent-browser find role <role> <action> [value]
z-agent-browser find role button click --name "Submit"
z-agent-browser find role textbox fill "hello" --name "Email"

z-agent-browser find text <text> <action>
z-agent-browser find text "Sign In" click

z-agent-browser find label <label> <action> [value]
z-agent-browser find label "Email" fill "test@test.com"

z-agent-browser find placeholder <text> <action> [value]
z-agent-browser find alt <text> <action>
z-agent-browser find title <text> <action>
z-agent-browser find testid <id> <action> [value]

z-agent-browser find first <selector> <action> [value]
z-agent-browser find last <selector> <action> [value]
z-agent-browser find nth <n> <selector> <action> [value]
```

**Actions:** `click`, `fill`, `check`, `hover`, `text`

---

## Auth State

```bash
z-agent-browser state save <path>          # Save cookies, localStorage, sessionStorage
z-agent-browser state load <path>          # Load saved state (works at runtime!)
```

### Auto-Persistence (Enhanced Fork)

```bash
# Auto-save/load to ~/.z-agent-browser/sessions/default.json
z-agent-browser --persist open "https://example.com"
z-agent-browser close                       # State auto-saved

# Use specific state file
z-agent-browser --state ~/auth.json open "https://example.com"
```

State is automatically loaded on launch and saved on close.

---

## Sessions

```bash
z-agent-browser session                    # Show current session
z-agent-browser session list               # List all sessions
z-agent-browser --session <name> <cmd>     # Run in isolated session
```

---

## Tabs

```bash
z-agent-browser tab                        # List open tabs
z-agent-browser tab new [url]              # Open new tab
z-agent-browser tab <n>                    # Switch to tab n
z-agent-browser tab close [n]              # Close tab (current if no n)
```

---

## Scroll

```bash
z-agent-browser scroll up [pixels]         # Scroll up
z-agent-browser scroll down [pixels]       # Scroll down
z-agent-browser scroll left [pixels]       # Scroll left
z-agent-browser scroll right [pixels]      # Scroll right
z-agent-browser scrollintoview <ref>       # Scroll element into view
```

---

## Cookies & Storage

```bash
z-agent-browser cookies                    # Get all cookies
z-agent-browser cookies set <name> <value> # Set cookie
z-agent-browser cookies clear              # Clear all cookies

z-agent-browser storage local              # Get all localStorage
z-agent-browser storage local <key>        # Get specific key
z-agent-browser storage local set <k> <v>  # Set value
z-agent-browser storage local clear        # Clear localStorage

z-agent-browser storage session            # sessionStorage (same API)
```

---

## Mouse Control

```bash
z-agent-browser mouse move <x> <y>         # Move mouse
z-agent-browser mouse down [button]        # Press button (left/right/middle)
z-agent-browser mouse up [button]          # Release button
z-agent-browser mouse wheel <dy> [dx]      # Scroll wheel
```

---

## Browser Settings

```bash
z-agent-browser set viewport <w> <h>       # Set viewport size
z-agent-browser set device "iPhone 14"     # Emulate device
z-agent-browser set geo <lat> <lng>        # Set geolocation
z-agent-browser set offline on             # Enable offline mode
z-agent-browser set offline off            # Disable offline mode
z-agent-browser set headers '{"X-Custom": "value"}'
z-agent-browser set credentials <user> <pass>  # HTTP basic auth
z-agent-browser set media dark             # Emulate dark mode
z-agent-browser set media light            # Emulate light mode
```

---

## Network

```bash
z-agent-browser network requests           # View tracked requests
z-agent-browser network requests --filter api
z-agent-browser network route <url>        # Intercept requests
z-agent-browser network route <url> --abort      # Block requests
z-agent-browser network route <url> --body '{}'  # Mock response
z-agent-browser network unroute [url]      # Remove routes
```

---

## Dialogs

```bash
z-agent-browser dialog accept [text]       # Accept alert/confirm/prompt
z-agent-browser dialog dismiss             # Dismiss dialog
```

---

## Frames

```bash
z-agent-browser frame <selector>           # Switch to iframe
z-agent-browser frame main                 # Back to main frame
```

---

## Debug

```bash
z-agent-browser console                    # View console messages
z-agent-browser console --clear            # Clear console
z-agent-browser errors                     # View page errors
z-agent-browser errors --clear             # Clear errors
z-agent-browser highlight <ref|selector>   # Highlight element
z-agent-browser trace start [path]         # Start recording trace
z-agent-browser trace stop [path]          # Stop and save trace
z-agent-browser eval <js>                  # Run JavaScript
```

---

## Stealth Mode (Enhanced Fork)

Bypass bot detection using playwright-extra with stealth plugin:

```bash
z-agent-browser --stealth open "https://bot.sannysoft.com"
z-agent-browser snapshot -i

# Via environment variable
AGENT_BROWSER_STEALTH=1 z-agent-browser open "https://example.com"
```

Stealth mode applies evasions for:
- WebDriver detection
- Chrome automation flags
- Permissions and plugins
- Languages and WebGL
- Other fingerprinting vectors

## Environment Variables

| Variable | Description |
|----------|-------------|
| `AGENT_BROWSER_SESSION` | Default session name |
| `AGENT_BROWSER_HEADED` | Set to "1" for visible browser |
| `AGENT_BROWSER_STEALTH` | Set to "1" for stealth mode |
| `AGENT_BROWSER_STREAM_PORT` | WebSocket port for streaming |
| `AGENT_BROWSER_EXECUTABLE_PATH` | Custom browser executable |
| `AGENT_BROWSER_PROFILE` | Default profile directory path |
| `AGENT_BROWSER_STATE` | Default state file path |
| `AGENT_BROWSER_PERSIST` | Set to "1" to enable cookie/localStorage persistence |
| `AGENT_BROWSER_CDP_PORT` | CDP port to auto-detect (default: 9222) |
| `AGENT_BROWSER_ARGS` | Comma-separated browser launch args |
| `AGENT_BROWSER_USER_AGENT` | Custom User-Agent string |
| `AGENT_BROWSER_IGNORE_HTTPS_ERRORS` | Set to "1" to skip SSL validation |
| `NO_COLOR` | Disable colored output (any value) |
| `AGENT_BROWSER_BACKEND` | Backend: `native` (default) or `playwright-mcp` |
| `PLAYWRIGHT_MCP_EXTENSION_TOKEN` | Token from Chrome extension (required for MCP mode) |
| `PLAYWRIGHT_MCP_COMMAND` | Command to spawn MCP server (default: `npx`) |
| `PLAYWRIGHT_MCP_ARGS` | Space-separated args (default: `@playwright/mcp@latest --extension`) |

---

## Playwright MCP Mode

Control your existing Chrome browser via the Playwright MCP extension instead of launching a dedicated Chromium.

### Setup

1. Install "Playwright MCP Bridge" extension from Chrome Web Store
2. Click extension icon to get your token
3. Set environment variables:

```bash
export PLAYWRIGHT_MCP_EXTENSION_TOKEN=your-token-here
export AGENT_BROWSER_BACKEND=playwright-mcp
```

### Feature Compatibility

| Feature | Native | MCP |
|---------|--------|-----|
| open, back, close | Yes | Yes |
| forward, reload | Yes | No |
| snapshot | Yes | Yes |
| click, fill, type, press | Yes | Yes |
| hover, check, uncheck, select | Yes | Yes |
| drag, upload | Yes | Yes |
| scroll, scrollintoview | Yes | No |
| get text/html/value/attr | Yes | No |
| get title/url | Yes | Yes (via snapshot) |
| is visible/enabled/checked | Yes | No |
| screenshot | Yes | Yes |
| pdf | Yes | No |
| video recording | Yes | No |
| state save/load | Yes | No |
| cookies, storage | Yes | No |
| stealth mode | Yes | No |
| profile mode | Yes | No |
| CDP connect | Yes | No |
| network routes | Yes | No |
| tabs | Yes | Yes |
| console, eval | Yes | Yes |
| dialog | Yes | Yes |

---

## Selectors

### Refs (Recommended)
Use refs from `snapshot` output for deterministic selection:
```bash
z-agent-browser snapshot -i
# Output: - button "Submit" [ref=e2]
z-agent-browser click @e2
```

### CSS Selectors
```bash
z-agent-browser click "#submit"
z-agent-browser click ".btn-primary"
z-agent-browser click "form > button"
```

### Text & XPath
```bash
z-agent-browser click "text=Submit"
z-agent-browser click "xpath=//button[@type='submit']"
```

---

## JSON Output

Add `--json` for machine-readable output:
```bash
z-agent-browser snapshot -i --json
z-agent-browser get text @e1 --json
z-agent-browser is visible @e2 --json
```

---

## Browser Launch Arguments (Enhanced Fork)

Pass custom Chromium command-line arguments:

```bash
# Disable GPU (useful in CI)
z-agent-browser --args "--disable-gpu,--no-sandbox" open "https://example.com"

# Custom user agent
z-agent-browser --user-agent "MyBot/1.0" open "https://example.com"

# Combine multiple options
z-agent-browser --args "--disable-gpu" --user-agent "MyBot/1.0" --ignore-https-errors open "https://localhost"
```

Common args:
- `--disable-gpu` - Disable GPU hardware acceleration
- `--no-sandbox` - Disable sandbox (required in some Docker containers)
- `--disable-dev-shm-usage` - Overcome limited /dev/shm in Docker
- `--window-size=1920,1080` - Set initial window size

---

## Profile Mode (Enhanced Fork)

Use a persistent Chrome profile directory:

```bash
# Use specific profile
z-agent-browser --profile ~/.z-agent-browser/my-profile open "https://example.com"

# Or via environment variable
AGENT_BROWSER_PROFILE=~/.z-agent-browser/my-profile z-agent-browser open "https://example.com"
```

Profile mode:
- Keeps extensions, bookmarks, passwords
- Maintains consistent browser fingerprint
- Stores history and settings
- Cannot be combined with CDP mode

---

## HTTPS Certificate Errors (Enhanced Fork)

For self-signed certificates on local dev servers:

```bash
z-agent-browser --ignore-https-errors open "https://localhost:8443"
```

Only use for trusted local servers.

---

## CDP Mode

z-agent-browser **auto-detects** Chrome on port 9222. If Chrome is running with debugging enabled, it connects automatically.

To set up Chrome with your logins:

```bash
# 1. Quit existing Chrome
pkill -9 "Google Chrome"

# 2. Copy profile to persistent location
cp -R "$HOME/Library/Application Support/Google/Chrome" ~/.z-agent-browser/chrome-profile

# 3. Launch Chrome with debugging
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --remote-debugging-port=9222 \
  --user-data-dir="$HOME/.z-agent-browser/chrome-profile" &

# 4. z-agent-browser auto-connects!
z-agent-browser open "https://example.com"
z-agent-browser snapshot -i
```

### Connect Command (Enhanced Fork)

If using the enhanced fork (zm2231/agent-browser), use `connect` once to establish persistent CDP:

```bash
z-agent-browser connect 9222
z-agent-browser open "https://example.com"   # no --cdp flag needed
z-agent-browser snapshot -i
z-agent-browser click @e1
z-agent-browser close
```

This saves tokens by not requiring `--cdp 9222` on every command.

---

## Streaming

Stream browser viewport via WebSocket for live preview:

```bash
AGENT_BROWSER_STREAM_PORT=9223 z-agent-browser open example.com --headed
```

Connect to `ws://localhost:9223` to receive frames:
```json
{
  "type": "frame",
  "data": "<base64-jpeg>",
  "metadata": { "deviceWidth": 1280, "deviceHeight": 720 }
}
```

Send input events:
```json
{ "type": "input_mouse", "eventType": "mousePressed", "x": 100, "y": 200, "button": "left" }
{ "type": "input_keyboard", "eventType": "keyDown", "key": "Enter" }
```
