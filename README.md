# Browser Skill for AI Agents

Web browser automation for Claude Code, OpenCode, and AI agents. Headless or headed mode, persistent auth, stealth mode, video recording.

## Installation

### For Humans

```bash
npm install -g z-agent-browser
z-agent-browser install
mkdir -p ~/.browser
```

Then install the skill:
```bash
mkdir -p ~/.claude/skills/browser-automation
curl -o ~/.claude/skills/browser-automation/skill.md \
  https://raw.githubusercontent.com/zm2231/browser-skill/main/skills/browser-automation/skill.md
```

### For LLM Agents

Paste this into a fresh Claude Code / OpenCode session:
```
Install and configure browser automation by following the instructions at https://raw.githubusercontent.com/zm2231/browser-skill/main/README.md
```

<details>
<summary>Instructions for LLM Agents (click to expand)</summary>

If you're an LLM Agent helping set up browser-skill, follow these steps:

#### Step 1: Install z-agent-browser

```bash
npm install -g z-agent-browser
z-agent-browser install
mkdir -p ~/.browser ~/.z-agent-browser
```

#### Step 2: Install the skill

```bash
mkdir -p ~/.claude/skills/browser-automation
curl -o ~/.claude/skills/browser-automation/skill.md \
  https://raw.githubusercontent.com/zm2231/browser-skill/main/skills/browser-automation/skill.md
curl -o ~/.claude/skills/browser-automation/reference.md \
  https://raw.githubusercontent.com/zm2231/browser-skill/main/skills/browser-automation/reference.md
```

#### Step 3: Verify installation

```bash
z-agent-browser open "https://example.com"
z-agent-browser snapshot -i
z-agent-browser close
```

#### Step 4: Tell the user

Say: "Browser automation is installed! Use `z-agent-browser` for web automation. Key commands: `open`, `snapshot -i`, `click @ref`, `fill @ref "text"`, `close`."

</details>

## Quick Start

```bash
z-agent-browser open "https://example.com"
z-agent-browser snapshot -i                    # Get interactive elements with refs
z-agent-browser click @e1                      # Click by ref
z-agent-browser fill @e2 "text"                # Fill input
z-agent-browser close
```

## Core Workflow

1. `z-agent-browser open <url>` - Navigate to page
2. `z-agent-browser snapshot -i` - Get interactive elements with refs (@e1, @e2)
3. Interact using refs from snapshot
4. Re-snapshot after navigation or DOM changes

## Key Features

| Feature | Command |
|---------|---------|
| Navigate | `open <url>` |
| Get elements | `snapshot -i` |
| Click | `click @e1` |
| Fill input | `fill @e2 "text"` |
| Screenshot | `screenshot [path]` |
| Save auth | `state save ~/.browser/auth.json` |
| Load auth | `state load ~/.browser/auth.json` |
| Headed mode | `open <url> --headed` |
| Close | `close` |

## Authentication Workflow

```bash
# Login once (headed so user can log in manually)
z-agent-browser open "https://site.com/login" --headed
# User logs in...
z-agent-browser state save ~/.browser/auth.json
z-agent-browser close

# Later sessions (headless, cookies preserved)
z-agent-browser state load ~/.browser/auth.json
z-agent-browser open "https://site.com"
```

## Important Notes

**Daemon behavior**: Environment variables (headed, stealth) are set at daemon startup. To switch modes, close the browser first with `z-agent-browser close`.

**When to use headed mode**: Use `--headed` when you need the user to log in manually, solve CAPTCHAs, or verify visual state.

## Enhanced Features

| Feature | Usage |
|---------|-------|
| Stealth mode | `--stealth` or `AGENT_BROWSER_STEALTH=1` |
| Auto-persistence | `--persist` |
| Chrome profile | `--profile ~/.browser/my-profile` |
| CDP mode | `connect 9222` |
| Video recording | `record start ./demo.webm` / `record stop` |

## Full Documentation

- [skill.md](skills/browser-automation/skill.md) - AI agent instructions
- [reference.md](skills/browser-automation/reference.md) - Complete command reference

## License

MIT
