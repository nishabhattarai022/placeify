#!/usr/bin/env bash
# Sync Mac LAN IP into config.json and run Flutter on a physical device.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLUTTER_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

"$SCRIPT_DIR/sync_network_config.sh"

LAN_IP="$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || true)"
if [[ -z "$LAN_IP" ]]; then
  echo "Could not detect LAN IP. Connect to Wi-Fi and retry."
  exit 1
fi

SERVER_URL="http://${LAN_IP}:8080/"
DEVICE="${1:-}"

echo "Server URL: $SERVER_URL"

cd "$FLUTTER_DIR"
if [[ -n "$DEVICE" ]]; then
  flutter run -d "$DEVICE" --dart-define="SERVER_URL=$SERVER_URL"
else
  flutter run --dart-define="SERVER_URL=$SERVER_URL"
fi
