#!/bin/zsh
# Opens the APOD viewer in a new Safari window that fills the main screen
# (the one with the menu bar). Run at login by the LaunchAgent in install.sh.

PAGE="file://${0:A:h}/index.html"

# Give the login session a moment so Safari's own restored windows land first.
[[ "$1" == "--at-login" ]] && sleep 8

osascript -l JavaScript - "$PAGE" <<'EOF'
ObjC.import("AppKit");
function run(argv) {
  const page = argv[0];
  // Screen 0 is the menu-bar screen. Cocoa measures from the bottom-left,
  // Safari window bounds from the top-left, so flip the vertical axis.
  const screen = $.NSScreen.screens.objectAtIndex(0);
  const full = screen.frame, vis = screen.visibleFrame;
  const left = vis.origin.x;
  const top = full.size.height - (vis.origin.y + vis.size.height);
  const right = left + vis.size.width;
  const bottom = top + vis.size.height;

  const safari = Application("Safari");
  safari.activate();
  safari.Document().make();
  delay(0.5);
  safari.windows[0].currentTab.url = page;
  safari.windows[0].bounds = { x: left, y: top, width: right - left, height: bottom - top };
}
EOF
