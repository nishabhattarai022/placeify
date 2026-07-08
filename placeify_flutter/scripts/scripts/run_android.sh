#!/usr/bin/env bash
# Run Placeify on Android emulator with stable debug connection.
# Fixes: "Error waiting for a debug connection: The log reader stopped unexpectedly"
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLUTTER_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$FLUTTER_DIR"

adb kill-server >/dev/null 2>&1 || true
adb start-server

exec flutter run --no-dds "$@"
