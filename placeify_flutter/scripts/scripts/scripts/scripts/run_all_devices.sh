#!/usr/bin/env bash
# Run Placeify on every connected Flutter device (emulator + phones) in parallel.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLUTTER_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

"$SCRIPT_DIR/sync_network_config.sh"

cd "$FLUTTER_DIR"

DEVICE_IDS=()
while IFS= read -r id; do
  [[ -n "$id" ]] && DEVICE_IDS+=("$id")
done < <(flutter devices --machine 2>/dev/null | python3 -c "
import json, sys
for d in json.load(sys.stdin):
    if d.get('emulator') or d.get('platformType') in ('android', 'ios'):
        print(d['id'])
")

if [[ "${#DEVICE_IDS[@]}" -eq 0 ]]; then
  echo "No mobile devices found. Connect a phone or start an Android emulator."
  flutter devices
  exit 1
fi

echo "Launching on ${#DEVICE_IDS[@]} device(s): ${DEVICE_IDS[*]}"
echo "Tip: start placeify_server first if it is not already running."
echo

PIDS=()
for id in "${DEVICE_IDS[@]}"; do
  log="/tmp/placeify_flutter_${id//[^a-zA-Z0-9]/_}.log"
  echo "  → $id  (log: $log)"
  flutter run -d "$id" >"$log" 2>&1 &
  PIDS+=("$!")
done

cleanup() {
  echo
  echo "Stopping Flutter sessions..."
  for pid in "${PIDS[@]}"; do
    kill "$pid" 2>/dev/null || true
  done
}
trap cleanup INT TERM

echo
echo "All sessions started. Press Ctrl+C here to stop them."
echo "Tail a log: tail -f /tmp/placeify_flutter_<device>.log"
wait
