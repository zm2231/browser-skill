# Connecting agent-browser to Chrome with User Profile

## The Problem

Chrome blocks `--remote-debugging-port` on the default profile path for security reasons. You cannot enable remote debugging on your main Chrome profile directly.

## Solution: Copy Profile

```bash
# 1. Quit all Chrome instances
pkill -9 "Google Chrome"

# 2. Copy your Chrome profile to a temporary location
cp -R "$HOME/Library/Application Support/Google/Chrome" /tmp/chrome-profile-copy

# 3. Launch Chrome with debugging enabled using the copy
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --remote-debugging-port=9222 \
  --user-data-dir="/tmp/chrome-profile-copy" &

# 4. Verify it's listening
lsof -i :9222

# 5. Connect agent-browser via CDP
agent-browser --cdp 9222 snapshot
```

## What Gets Copied

| File/Directory | Size | Contains |
|----------------|------|----------|
| `Default/Cookies` | ~450KB | All login sessions |
| `Default/Login Data` | varies | Saved passwords (encrypted) |
| `Default/Local Storage/` | varies | Site preferences, app data |
| `Default/IndexedDB/` | varies | Web app databases |
| `Default/Extensions/` | varies | Installed extensions |
| `Profile 1-N/` | varies | Additional Chrome profiles |

**Total size:** ~1-2GB depending on usage

## Platform-Specific Paths

| Platform | Chrome Profile Path |
|----------|---------------------|
| macOS | `~/Library/Application Support/Google/Chrome` |
| Windows | `%LOCALAPPDATA%\Google\Chrome\User Data` |
| Linux | `~/.config/google-chrome` |

## Limitations

1. **Snapshot only** - The copy is point-in-time. New cookies/logins in your real Chrome won't appear in the copy
2. **No sync back** - Changes made in the debug session don't sync to your real profile
3. **Storage cost** - Each copy is 1-2GB
4. **Exclusive access** - Chrome locks profile directories, so you can't use both simultaneously

## Attempted Workarounds (Failed)

| Approach | Result |
|----------|--------|
| Symlink to real profile | Chrome resolves symlink, still blocks |
| Direct path to real profile | Chrome detects default path, blocks |
| WebSocket connection | Doesn't bypass startup restriction |

## Open Issues

- [#42](https://github.com/vercel-labs/agent-browser/issues/42) - Request for `--user-data-dir` flag
- [#77](https://github.com/vercel-labs/agent-browser/issues/77) - CDP support for user-data-dir
- [#135](https://github.com/vercel-labs/agent-browser/issues/135) - WebSocket connection fix

## Alternative: Use Chrome Canary

Run a separate Chrome installation (Canary/Beta) for automation with its own profile:

```bash
"/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary" \
  --remote-debugging-port=9222 \
  --user-data-dir="/tmp/chrome-canary-automation" &
```

This lets you keep your main Chrome running while automating in Canary.
