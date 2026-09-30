#!/bin/bash

# TODO:
# - Download the wimc binary from the latest release: https://github.com/emyasa/wimc/releases
# - Move the binary into ~/.local/bin/
# - Download the source form the latest release: https://github.com/emyasa/wimc/releases
# - Set up ~/.config/wimc/ directory
# - Move the contents of config/ directory into ~/.config/wimc/

PROGRAM="$HOME/.local/bin/wimc"
PLIST="$HOME/Library/LaunchAgents/com.yasaworks.wimc.plist"

cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>ProgramArguments</key>
    <array>
        <string>$PROGRAM</string>
    </array>

    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

launchctl load ~/Library/LaunchAgents/com.yasaworks.wimc.plist
