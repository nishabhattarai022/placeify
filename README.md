# placeify

Placing things into your space — AR-powered furniture marketplace.

Monorepo layout (from the [`rosikagajurel`](https://github.com/nishabhattarai022/placeify/tree/rosikagajurel) branch):

```
placeify/
├── placeify_client/    # Generated Serverpod API client (shared)
├── placeify_server/    # Serverpod backend (Postgres, auth, APIs)
├── placeify_flutter/   # Flutter mobile/desktop app
├── pubspec.yaml        # Dart workspace root
└── .github/workflows/  # CI (analyze, format, tests)
```

## Prerequisites

- Dart SDK `^3.8.0` and Flutter `^3.32.0`
- Docker (for Postgres + Redis)
- Serverpod CLI `3.4.8` (only when changing server models)

## Quick start

### 1. Install dependencies

```bash
dart pub get
```

### 2. Start the database

```bash
cd placeify_server
docker compose up -d
```

### 3. Run the server

```bash
cd placeify_server
dart bin/main.dart --apply-migrations
```

Keep this terminal open.

Registration uses dev verification code **`123456`**.

Optional demo login (tap **Try demo account** on the login screen): `demo@placeify.app` / `demo1234`

### 4. Run the Flutter app

```bash
cd placeify_flutter
flutter run -d macos
```

Other devices: `flutter run -d chrome`, `flutter run -d android`, etc.

## Physical device / emulator networking

The app probes `http://localhost:8080` (macOS/iOS simulator) and caches a working URL.

For a **physical phone** on the same Wi‑Fi, set your machine's LAN IP in:

`placeify_flutter/assets/config.json`

```json
{
  "apiUrl": "http://localhost:8080",
  "physicalApiUrl": "http://192.168.1.10:8080"
}
```

Or override at build time:

```bash
flutter run --dart-define=SERVER_URL=http://192.168.1.10:8080/
```

## Common issues

| Problem | Fix |
|---------|-----|
| `Cannot reach server` | Start the server (step 3 above). The app retries and re-detects the URL automatically. |
| Wrong migration flag | Use `--apply-migrations` (plural, with hyphen) |
| Port 8080 in use | Stop the other server process or use the one already running |
| Android emulator install fails (`INSUFFICIENT_STORAGE`) | Use `flutter run -d macos` or wipe emulator data in AVD Manager |
| Login on physical Android phone | Set `physicalApiUrl` in `assets/config.json` to your Mac's LAN IP |
| Demo account | `demo@placeify.app` / `demo1234` (tap "Try demo account" on login — registers on first use) |

## Regenerate client after server model changes

```bash
cd placeify_server
dart pub global activate serverpod_cli 3.4.8
serverpod generate
```
