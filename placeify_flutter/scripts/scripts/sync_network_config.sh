#!/usr/bin/env bash
# Writes the Mac's current Wi-Fi/Ethernet LAN IP into assets/config.json so
# physical phones can reach the local Serverpod instance.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLUTTER_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG_FILE="$FLUTTER_DIR/assets/config.json"

detect_lan_ip() {
  local ip=""
  for iface in en0 en1 en2 bridge0; do
    ip="$(ipconfig getifaddr "$iface" 2>/dev/null || true)"
    if [[ -n "$ip" ]]; then
      echo "$ip"
      return 0
    fi
  done

  ip="$(route -n get default 2>/dev/null | awk '/interface:/{print $2}' | head -1)"
  if [[ -n "$ip" ]]; then
    ipconfig getifaddr "$ip" 2>/dev/null || true
  fi
}

LAN_IP="$(detect_lan_ip)"
if [[ -z "$LAN_IP" ]]; then
  echo "Could not detect LAN IP. Connect to Wi-Fi and retry."
  exit 1
fi

PHYSICAL_URL="http://${LAN_IP}:8080"

python3 - "$CONFIG_FILE" "$PHYSICAL_URL" <<'PY'
import json
import sys
from pathlib import Path

config_path = Path(sys.argv[1])
physical_url = sys.argv[2]

config = {}
if config_path.exists():
    config = json.loads(config_path.read_text())

config.setdefault("apiUrl", "http://localhost:8080")
config["physicalApiUrl"] = physical_url

config_path.write_text(json.dumps(config, indent=2) + "\n")
print(f"Updated physicalApiUrl → {physical_url}")
PY
