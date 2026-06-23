#!/usr/bin/env bash
# One-time / occasional dev environment setup for Placeify on macOS.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLUTTER_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$FLUTTER_DIR/.." && pwd)"

echo "==> Placeify dev setup"
echo

echo "==> Sync LAN IP into assets/config.json"
"$SCRIPT_DIR/sync_network_config.sh"
echo

if [[ "$(uname -m)" == "arm64" ]]; then
  echo "==> Patch Flutter iproxy for Apple Silicon (wireless/USB iPhone)"
  "$SCRIPT_DIR/fix_ios_iproxy.sh"
  echo
fi

echo "==> Workspace dependencies"
cd "$REPO_ROOT"
dart pub get
echo

echo "==> Flutter iOS artifacts + CocoaPods"
cd "$FLUTTER_DIR"
flutter precache --ios
flutter pub get
cd ios
pod install
cd "$FLUTTER_DIR"
echo

echo "==> Accept Android licenses (press y for each prompt if asked)"
flutter doctor --android-licenses || true
echo

echo "==> Flutter doctor"
flutter doctor
echo

echo "Connected devices:"
flutter devices
echo
echo "Setup complete."
echo "  Server:  cd placeify_server && dart bin/main.dart --apply-migrations"
echo "  One device: cd placeify_flutter && flutter run -d <device-id>"
echo "  All devices: ./scripts/run_all_devices.sh"
