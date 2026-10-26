#!/bin/zsh
# Builds APOD.app into build/ and installs it to ~/Applications.
set -e

HERE="${0:A:h}"
BUILD="$HERE/build"
APP="$BUILD/APOD.app"

rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources" "$BUILD/AppIcon.iconset"

swiftc -O -o "$APP/Contents/MacOS/APOD" "$HERE/app/main.swift"
cp "$HERE/index.html" "$APP/Contents/Resources/"

# Icon: draw once at 1024, then scale into every size macOS asks for.
swift "$HERE/app/icon.swift" "$BUILD/icon-1024.png"
for s in 16 32 128 256 512; do
  sips -z $s $s "$BUILD/icon-1024.png" --out "$BUILD/AppIcon.iconset/icon_${s}x${s}.png" >/dev/null
  sips -z $((s*2)) $((s*2)) "$BUILD/icon-1024.png" --out "$BUILD/AppIcon.iconset/icon_${s}x${s}@2x.png" >/dev/null
done
iconutil -c icns "$BUILD/AppIcon.iconset" -o "$APP/Contents/Resources/AppIcon.icns"

cat > "$APP/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleIdentifier</key><string>com.mrphil.apod</string>
  <key>CFBundleName</key><string>APOD</string>
  <key>CFBundleDisplayName</key><string>APOD</string>
  <key>CFBundleExecutable</key><string>APOD</string>
  <key>CFBundleIconFile</key><string>AppIcon</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>1.0</string>
  <key>CFBundleVersion</key><string>1</string>
  <key>LSMinimumSystemVersion</key><string>13.0</string>
  <key>NSHighResolutionCapable</key><true/>
</dict>
</plist>
EOF

codesign --force --sign - "$APP"

mkdir -p "$HOME/Applications"
rm -rf "$HOME/Applications/APOD.app"
cp -R "$APP" "$HOME/Applications/"
echo "Built and installed ~/Applications/APOD.app"
