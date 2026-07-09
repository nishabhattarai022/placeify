#!/usr/bin/env bash
# Flutter ships an x86_64 iproxy on Apple Silicon Macs without Rosetta.
# This script points Flutter's cached iproxy at Homebrew's native arm64 build.
set -euo pipefail

if [[ "$(uname -m)" != "arm64" ]]; then
  echo "This fix is only needed on Apple Silicon Macs."
  exit 0
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required. Install from https://brew.sh"
  exit 1
fi

if ! command -v iproxy >/dev/null 2>&1; then
  echo "Installing libimobiledevice (includes arm64 iproxy)..."
  brew install libimobiledevice
fi

FLUTTER_ROOT="$(dirname "$(dirname "$(command -v flutter)")")"
FLUTTER_IPROXY="${FLUTTER_ROOT}/bin/cache/artifacts/libusbmuxd/iproxy"

if [[ ! -d "$(dirname "$FLUTTER_IPROXY")" ]]; then
  echo "Flutter iOS USB artifacts not found. Run: flutter precache --ios"
  exit 1
fi

if [[ ! -f "${FLUTTER_IPROXY}.x86_64.bak" ]]; then
  cp "$FLUTTER_IPROXY" "${FLUTTER_IPROXY}.x86_64.bak"
fi

cat > "$FLUTTER_IPROXY" <<'EOF'
#!/bin/bash
exec /opt/homebrew/bin/iproxy "$@"
EOF
chmod +x "$FLUTTER_IPROXY"

echo "Patched Flutter iproxy for Apple Silicon."
echo "Wireless/USB iPhone debugging should work with: flutter run -d ios"
