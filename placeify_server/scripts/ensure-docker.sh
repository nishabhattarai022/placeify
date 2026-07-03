#!/usr/bin/env bash
# Ensures the Docker daemon is running before compose / server scripts.
# On macOS, starts Docker Desktop automatically and waits until ready.
set -euo pipefail

readonly MAX_WAIT_SECONDS="${PLACEIFY_DOCKER_WAIT_SECONDS:-120}"
readonly POLL_SECONDS=2

_is_docker_ready() {
  docker info >/dev/null 2>&1
}

_start_docker_desktop_macos() {
  if [[ ! -d "/Applications/Docker.app" ]]; then
    echo "Docker Desktop is not installed."
    echo "Install it from https://www.docker.com/products/docker-desktop/"
    return 1
  fi

  echo "==> Starting Docker Desktop..."
  open -a Docker
}

_start_docker_linux() {
  if command -v systemctl >/dev/null 2>&1; then
    echo "==> Starting Docker service (systemctl)..."
    sudo systemctl start docker
    return 0
  fi

  echo "Docker daemon is not running. Start Docker manually and retry."
  return 1
}

_wait_for_docker() {
  local elapsed=0
  while (( elapsed < MAX_WAIT_SECONDS )); do
    if _is_docker_ready; then
      return 0
    fi
    sleep "$POLL_SECONDS"
    elapsed=$((elapsed + POLL_SECONDS))
    if (( elapsed % 10 == 0 )); then
      echo "    Waiting for Docker daemon... (${elapsed}s / ${MAX_WAIT_SECONDS}s)"
    fi
  done
  return 1
}

if _is_docker_ready; then
  exit 0
fi

echo "Docker daemon is not running."

case "$(uname -s)" in
  Darwin)
    _start_docker_desktop_macos
    ;;
  Linux)
    _start_docker_linux
    ;;
  *)
    echo "Unsupported OS for auto-start. Start Docker manually and retry."
    exit 1
    ;;
esac

if ! _wait_for_docker; then
  echo ""
  echo "Docker did not become ready within ${MAX_WAIT_SECONDS}s."
  echo ""
  echo "Permanent fix on macOS:"
  echo "  1. Open Docker Desktop → Settings → General"
  echo "  2. Enable \"Start Docker Desktop when you sign in to your computer\""
  echo "  3. Keep Docker Desktop running while developing"
  echo ""
  echo "Then run: ./scripts/start-server.sh"
  exit 1
fi

echo "✓ Docker daemon is ready"
