# Browser Skill for AI Agents

Web browser automation for Claude Code, OpenCode, and AI agents. Built on [agent-browser](https://github.com/zm2231/agent-browser) (our enhanced fork) with stealth mode, persistent auth, video recording, and human-in-the-loop support.

## Features

- Headless or headed mode: run invisibly or watch the browser
- Token efficient: `snapshot -i` returns only interactive elements
- Persistent auth: save and load login sessions between runs
- Video recording: create demos and bug reproductions
- Multi-worker safe: session isolation prevents conflicts
- Human-in-the-loop: visible Chrome for manual login and captcha assistance

## Quick Start

```bash
# Install (enhanced fork - recommended)
git clone https://github.com/zm2231/agent-browser.git
cd agent-browser
pnpm install && pnpm build && pnpm build:native
npm link
z-agent-browser install
mkdir -p ~/.browser

# Basic usage (headless)
z-agent-browser open "https://example.com"
z-agent-browser snapshot -i
z-agent-browser click @e1
z-agent-browser close

# Visible browser (for login assistance)
z-agent-browser open "https://example.com" --headed
```

## Installation

### Option 1: Enhanced Fork (Recommended)
Install from our fork with stealth mode, auto-persistence, and more:
```bash
git clone https://github.com/zm2231/agent-browser.git
cd agent-browser
pnpm install
pnpm build
pnpm build:native   # requires Rust: https://rustup.rs
npm link
z-agent-browser install
mkdir -p ~/.browser
```

The enhanced fork includes:
- `--stealth`: bypass bot detection using playwright-extra stealth plugin
- `connect <port>` command: persistent CDP without `--cdp` on every command
- `--profile <path>`: use persistent Chrome profile (keeps extensions, bookmarks, etc.)
- `--ignore-https-errors`: skip certificate validation for self-signed certs
- `--persist`: auto-save/load auth state between sessions
- `--state <path>`: explicit state file path
- `--args <csv>`: pass custom browser launch arguments
- `--user-agent <string>`: set custom User-Agent
- Runtime `state load`: load auth into running browser (not just at launch)
- `tab new <url>`: open new tab at specific URL
- `record start/stop`: video recording to WebM
- URL schemes: `about:`, `data:`, `file:` URLs now work
- NO_COLOR support: respects NO_COLOR env var for CI/logs

### Option 2: Interactive Installer
```bash
git clone https://github.com/zm2231/browser-skill.git
cd browser-skill
./install.sh   # Offers enhanced fork as first option
```

### Option 3: Claude Marketplace
```bash
/plugin marketplace add zm2231/browser-skill
/plugin install browser-skill@browser-skill-marketplace
```

### Option 4: npm (Enhanced Fork)
```bash
npm install -g z-agent-browser
z-agent-browser install
mkdir -p ~/.browser ~/.z-agent-browser
```

### Option 5: Upstream npm (Basic Features Only)
For the original vercel-labs version without enhanced features:
```bash
npm install -g agent-browser
agent-browser install
mkdir -p ~/.browser
```
Note: Upstream lacks stealth mode, auto-persistence, profile mode, and other enhanced features.

### Option 6: Claude Skill Only
Copy the skill files to your Claude skills directory:
```bash
mkdir -p ~/.claude/skills/browser-automation
curl -o ~/.claude/skills/browser-automation/skill.md \
  https://raw.githubusercontent.com/zm2231/browser-skill/main/skills/browser-automation/skill.md
```

## Core Workflow

```bash
# 1. Open page
z-agent-browser open "https://example.com" --headed

# 2. Get interactive elements
z-agent-browser snapshot -i
# Output: - button "Submit" [ref=e2]
#         - textbox "Email" [ref=e3]

# 3. Interact using refs
z-agent-browser fill @e3 "user@example.com"
z-agent-browser click @e2

# 4. Re-snapshot after page changes
z-agent-browser snapshot -i
```

## Examples

| Example | Description |
|---------|-------------|
| [01-quickstart.sh](examples/01-quickstart.sh) | Basic headed and headless usage |
| [02-form-filling.sh](examples/02-form-filling.sh) | Fill and submit forms |
| [03-auth-persistence.sh](examples/03-auth-persistence.sh) | Save and load login sessions |
| [04-scraping.sh](examples/04-scraping.sh) | Extract data from pages |
| [05-testing.sh](examples/05-testing.sh) | E2E testing example |
| [06-multi-session.sh](examples/06-multi-session.sh) | Parallel isolated sessions |
| [07-cdp-mode.sh](examples/07-cdp-mode.sh) | Persistent Chrome via CDP |
| [08-streaming.sh](examples/08-streaming.sh) | WebSocket live preview |
| [09-video-recording.sh](examples/09-video-recording.sh) | Record demos and reproductions |
| [10-import-chrome-profile.sh](examples/10-import-chrome-profile.sh) | Import existing Chrome logins |
| [11-enhanced-features.sh](examples/11-enhanced-features.sh) | Enhanced fork: --persist, --profile, --ignore-https-errors |

## Key Commands

| Command | Description |
|---------|-------------|
| `z-agent-browser open <url> [--headed]` | Navigate to URL |
| `z-agent-browser snapshot -i` | Get interactive elements with refs |
| `z-agent-browser click @e1` | Click element by ref |
| `z-agent-browser fill @e2 "text"` | Fill input field |
| `z-agent-browser state save <path>` | Save cookies and storage |
| `z-agent-browser state load <path>` | Load saved auth (works at runtime!) |
| `z-agent-browser record start <path>` | Start video recording |
| `z-agent-browser record stop` | Stop video recording |
| `z-agent-browser close` | Close browser |

### Enhanced Fork Options

| Option | Description |
|--------|-------------|
| `--stealth` | Bypass bot detection (playwright-extra) |
| `--profile <path>` | Use persistent Chrome profile directory |
| `--ignore-https-errors` | Skip SSL certificate validation |
| `--persist` | Auto-save/load state to `~/.z-agent-browser/sessions/` |
| `--state <path>` | Use specific state file path |
| `--args <csv>` | Comma-separated browser launch args |
| `--user-agent <string>` | Custom User-Agent string |
| `connect <port>` | Establish persistent CDP connection |

See [reference.md](skills/browser-automation/reference.md) for all commands.

## Authentication

### Auto-Persistence (Enhanced Fork)

The easiest way to maintain login sessions:

```bash
# First session: log in with --persist flag
z-agent-browser --persist open "https://github.com/login" --headed
# User logs in manually
z-agent-browser close   # State auto-saved to ~/.z-agent-browser/sessions/default.json

# Later sessions: auth auto-restored
z-agent-browser --persist open "https://github.com"   # Already logged in!
```

Or use explicit state file:
```bash
z-agent-browser --state ~/.browser/github-auth.json open "https://github.com"
```

### Manual Save/Load

```bash
# First time: log in with headed mode so you can see the browser
z-agent-browser open "https://github.com/login" --headed
# User logs in manually in the visible window
z-agent-browser state save ~/.browser/auth-github.json

# Later sessions: restore auth (works at runtime now!)
z-agent-browser open "https://github.com"
z-agent-browser state load ~/.browser/auth-github.json   # Loads into running browser
```

### Human-in-the-loop login flow

When Claude needs to access a site requiring login:

1. Claude opens the site with `--headed` flag
2. Claude tells user: "Please sign in to [site] in the Chrome window. Let me know when done."
3. User logs in manually
4. Claude saves the auth state for future use

## Modes

### Headless (Default)
Fast, no window. Good for scraping and automation.
```bash
z-agent-browser open "https://example.com"
```

### Headed
Visible window. Good for debugging and manual login.
```bash
z-agent-browser open "https://example.com" --headed
```

### Stealth Mode (Enhanced Fork)
Bypass bot detection using playwright-extra stealth plugin:
```bash
z-agent-browser --stealth open "https://bot.sannysoft.com"
```

Evades WebDriver detection, Chrome automation flags, and other fingerprinting. Combine with other options:
```bash
z-agent-browser --stealth --headed open "https://example.com"
```

### Profile Mode (Enhanced Fork)
Use a persistent Chrome profile directory. Keeps extensions, bookmarks, passwords, and settings:
```bash
z-agent-browser --profile ~/.browser/my-profile open "https://example.com"
```

Great for:
- Using Chrome extensions (password managers, ad blockers)
- Maintaining consistent browser fingerprint
- Keeping bookmarks and history

### CDP (Persistent Chrome)
Chrome survives between Claude sessions. Requires tmux.
```bash
./scripts/start-chrome.sh
z-agent-browser --cdp 9222 open "https://example.com"
```

### Streaming
WebSocket live preview for pair browsing.
```bash
AGENT_BROWSER_STREAM_PORT=9223 z-agent-browser open "https://example.com" --headed
# Connect to ws://localhost:9223 for live frames
```

### Playwright MCP Mode (Experimental)
Control your existing Chrome browser via the Playwright MCP bridge extension. Uses your logged-in sessions and extensions.

```bash
# 1. Install "Playwright MCP Bridge" Chrome extension
# 2. Click extension icon to get token
# 3. Set environment variables:
export PLAYWRIGHT_MCP_EXTENSION_TOKEN=your-token
export AGENT_BROWSER_BACKEND=playwright-mcp

# Commands work the same
z-agent-browser open "https://example.com"
z-agent-browser snapshot -i
z-agent-browser click @e1
```

Note: Some features unavailable in MCP mode (scroll, get text/html, video recording, state save/load). Use native mode for full feature support.

## Multiple Sessions

Run parallel isolated browser instances for multi-worker scenarios:

```bash
z-agent-browser --session worker1 open "https://site-a.com"
z-agent-browser --session worker2 open "https://site-b.com"
z-agent-browser session list
```

Each session has its own browser instance, cookies, storage, and history. Use environment variable for convenience:

```bash
AGENT_BROWSER_SESSION=worker1 z-agent-browser snapshot -i
```

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
```

The copy includes all your cookies, saved passwords, localStorage, and extensions. Changes in the copied profile do not sync back to your real Chrome.

### Use Chrome Canary Instead

Run Chrome Canary for automation while keeping your main Chrome open:

```bash
"/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary" \
  --remote-debugging-port=9222 \
  --user-data-dir="/tmp/chrome-canary-automation" &

z-agent-browser --cdp 9222 open "https://example.com"
```

## Video Recording

Record demos and bug reproductions:

```bash
z-agent-browser open "https://example.com" --headed
# Explore the site first
z-agent-browser record start ./demo.webm
z-agent-browser fill @e1 "demo input"
z-agent-browser click @e2
z-agent-browser record stop
# Video saved to ./demo.webm
```

Recording preserves cookies and storage from your current session.

## Data Locations

| Path | Purpose |
|------|---------|
| `~/.z-agent-browser/run/` | Daemon socket and PID files |
| `~/.z-agent-browser/run/default.sock` | Default session Unix socket |
| `~/.z-agent-browser/run/default.pid` | Default session daemon PID |
| `~/.z-agent-browser/sessions/` | Auto-persist state files (--persist flag) |
| `~/.z-agent-browser/sessions/default.json` | Default session auto-persist |
| `~/.browser/auth.json` | Manually saved auth state |
| `~/.browser/auth-{site}.json` | Per-site auth (optional) |
| `~/.browser/chrome-profile/` | CDP mode Chrome data |

## Self-Signed Certificates (Enhanced Fork)

For local development servers with self-signed certs:

```bash
z-agent-browser --ignore-https-errors open "https://localhost:8443"
```

This skips SSL certificate validation. Only use for trusted local servers.

## Requirements

- macOS
- Node.js 18+
- Chrome browser (bundled Chromium installed by `z-agent-browser install`)
- tmux (optional, for CDP persistent Chrome mode only)

## How It Works

The z-agent-browser daemon starts automatically on first command and persists between commands. The browser stays alive until you run `z-agent-browser close` or the daemon times out.

For Chrome that persists between Claude sessions, use CDP mode with the provided scripts:

```bash
./scripts/start-chrome.sh   # Launch Chrome in tmux
./scripts/stop-chrome.sh    # Stop Chrome
```

## Troubleshooting

### z-agent-browser not found
```bash
npm install -g z-agent-browser
z-agent-browser install
```

### State load fails
No saved auth exists. Log in first with headed mode, then save:
```bash
z-agent-browser open "https://site.com/login" --headed
# Log in manually
z-agent-browser state save ~/.browser/auth.json
```

### Port 9222 in use (CDP mode)
```bash
lsof -i :9222
kill -9 <PID>
```

### Browser closes unexpectedly
The daemon may have timed out. Run another command to restart it, or use CDP mode for persistent Chrome.

## Project Structure

```
browser-skill/
├── .claude-plugin/          # Marketplace manifests
├── agents/                  # Subagent definition
├── commands/                # /browser slash command
├── examples/                # Usage examples (runnable scripts)
├── scripts/                 # Chrome daemon scripts
├── skills/browser-automation/
│   ├── skill.md             # Main skill file (install this for Claude)
│   └── reference.md         # Full command reference
├── install.sh               # Interactive installer
└── README.md
```

## For Claude: Setup Instructions

If you are an AI agent reading this repo, here is how to set up browser automation:

1. Check if z-agent-browser is installed: `which z-agent-browser`
2. If not installed, install from enhanced fork:
   ```bash
   git clone https://github.com/zm2231/agent-browser.git /tmp/agent-browser-install
   cd /tmp/agent-browser-install
   pnpm install && pnpm build && pnpm build:native && npm link
   z-agent-browser install
   mkdir -p ~/.browser
   ```
3. Test with: `z-agent-browser open "https://example.com" && z-agent-browser snapshot -i && z-agent-browser close`

For persistent auth:
- Auto-persistence (recommended): `z-agent-browser --persist open "https://example.com"`
- Manual save after login: `z-agent-browser state save ~/.browser/auth.json`
- Manual load before browsing: `z-agent-browser state load ~/.browser/auth.json`

For user login assistance, use `--headed` flag and ask the user to log in manually.

## License

MIT
