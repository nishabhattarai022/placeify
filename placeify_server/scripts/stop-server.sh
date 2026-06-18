#!/usr/bin/env bash
# Stops Placeify Serverpod processes bound to local dev ports.
set -euo pipefail

PORTS=(8080 8081 8082)
KILLED=0

for port in "${PORTS[@]}"; do
  pids=$(lsof -ti ":$port" 2>/dev/null || true)
  if [[ -n "$pids" ]]; then
    echo "==> Stopping process(es) on port $port: $pids"
    kill $pids 2>/dev/null || true
    KILLED=1
  fi
done

if [[ "$KILLED" -eq 1 ]]; then
  sleep 1
  for port in "${PORTS[@]}"; do
    pids=$(lsof -ti ":$port" 2>/dev/null || true)
    if [[ -n "$pids" ]]; then
      echo "==> Force-stopping port $port"
      kill -9 $pids 2>/dev/null || true
    fi
  done
  echo "✓ Server ports freed (8080, 8081, 8082)"
else
  echo "✓ No server running on ports 8080–8082"
fi
