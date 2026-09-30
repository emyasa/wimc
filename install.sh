#!/bin/bash

# Download the binary and place it in ~/.local/bin/
curl -fL https://github.com/emyasa/wimc/releases/latest/download/wimc \
  -o ~/.local/bin/wimc

chmod +x ~/.local/bin/wimc

# Download the source and copy the config directory's contents into ~/.config/wimc/
mkdir -p ~/.config/wimc
curl -fsL https://github.com/emyasa/wimc/archive/refs/heads/main.tar.gz |
  tar -xz -C ~/.config/wimc -s '|wimc-main/config/||' wimc-main/config/*

# Construct and Load the plist to run it as a daemon
PROGRAM="$HOME/.local/bin/wimc"
PLIST="$HOME/Library/LaunchAgents/com.yasaworks.wimc.plist"

cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.yasaworks.wimc</string>

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
