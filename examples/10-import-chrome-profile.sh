#!/bin/bash
# Import existing Chrome logins by copying your profile

set -e

PROFILE_COPY="/tmp/chrome-profile-copy"

echo "This script copies your Chrome profile to use existing logins."
echo "Your main Chrome must be closed."
echo ""

if pgrep -x "Google Chrome" > /dev/null; then
    echo "Chrome is running. Close it first:"
    echo "  pkill -9 'Google Chrome'"
    exit 1
fi

echo "Copying Chrome profile (this may take a minute)..."
rm -rf "$PROFILE_COPY"
cp -R "$HOME/Library/Application Support/Google/Chrome" "$PROFILE_COPY"
echo "  [ok] Copied to $PROFILE_COPY"

echo ""
echo "Launching Chrome with remote debugging..."
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --remote-debugging-port=9222 \
  --user-data-dir="$PROFILE_COPY" &

sleep 3

if lsof -i :9222 > /dev/null 2>&1; then
    echo "  [ok] Chrome running on port 9222"
else
    echo "  [error] Chrome failed to start"
    exit 1
fi

echo ""
echo "Testing connection..."
z-agent-browser --cdp 9222 open "https://example.com"
z-agent-browser --cdp 9222 snapshot -i
z-agent-browser --cdp 9222 get title

echo ""
echo "Success! Your existing logins are available."
echo ""
echo "Usage:"
echo "  z-agent-browser --cdp 9222 open 'https://github.com'"
echo "  z-agent-browser --cdp 9222 snapshot -i"
echo ""
echo "To stop:"
echo "  pkill -f 'chrome-profile-copy'"
