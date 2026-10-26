#!/bin/zsh
# Installs (or with --uninstall removes) the login item that opens the APOD viewer.
set -e

LABEL="com.mrphil.apod"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
HERE="${0:A:h}"

launchctl bootout "gui/$UID/$LABEL" 2>/dev/null || true

if [[ "$1" == "--uninstall" ]]; then
  rm -f "$PLIST"
  echo "Removed the APOD login item."
  exit 0
fi

cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>$LABEL</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/zsh</string>
    <string>$HERE/open-apod.sh</string>
  </array>
  <key>RunAtLoad</key><true/>
  <key>StandardErrorPath</key><string>/tmp/$LABEL.err</string>
</dict>
</plist>
EOF

launchctl bootstrap "gui/$UID" "$PLIST"
echo "Installed: the APOD viewer will open at each login."
