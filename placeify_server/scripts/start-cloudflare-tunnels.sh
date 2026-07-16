#!/usr/bin/env bash
# Start Cloudflare quick tunnels for Placeify Serverpod (API :8080 + web :8082).
# Leave these running while testing remote verification / phone-on-data signup.
set -euo pipefail

API_PORT="${PLACEIFY_API_PORT:-8080}"
WEB_PORT="${PLACEIFY_WEB_PORT:-8082}"

if ! command -v cloudflared >/dev/null 2>&1; then
  echo "cloudflared not found. Install with: brew install cloudflare/cloudflare/cloudflared"
  exit 1
fi

echo "Starting Cloudflare quick tunnels..."
echo "  API  http://127.0.0.1:${API_PORT}  (Flutter / Serverpod RPC)"
echo "  Web  http://127.0.0.1:${WEB_PORT}  (email /verify-email page)"
echo ""
echo "After URLs appear:"
echo "  1) Set passwords.yaml frontendUrl = WEB tunnel URL"
echo "  2) Set assets/config.json physicalApiUrl = API tunnel URL"
echo "  3) Restart Placeify server + hot-restart Flutter"
echo ""

cloudflared tunnel --url "http://127.0.0.1:${API_PORT}" --no-autoupdate &
API_PID=$!
cloudflared tunnel --url "http://127.0.0.1:${WEB_PORT}" --no-autoupdate &
WEB_PID=$!

cleanup() {
  kill "$API_PID" "$WEB_PID" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

wait
