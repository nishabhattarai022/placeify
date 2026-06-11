# Placeify

AR-powered furniture visualizer and marketplace.

## Project structure

```
placeify/
├── placeify_server/   # Serverpod backend (API, auth, commerce)
├── placeify_client/   # Generated Dart client
└── placeify_flutter/  # Flutter app (consumer + vendor UI)
```

## Quick start

### Prerequisites

- Dart SDK 3.8+
- Flutter 3.32+
- Docker Desktop (running)
- Serverpod CLI 3.4.8: `dart pub global activate serverpod_cli 3.4.8`

### Setup

```bash
# From repo root
dart pub get

# One-time: copy server passwords
cp placeify_server/config/passwords.yaml.example placeify_server/config/passwords.yaml
```

### Run backend

```bash
cd placeify_server
docker compose up -d
dart bin/main.dart --apply-migrations
```

API: http://localhost:8080

### Run Flutter app

**Chrome (recommended if Xcode is not installed):**

```bash
cd placeify_flutter
flutter run -d chrome
```

**Android emulator:**

```bash
flutter run -d android
```

**macOS desktop** requires the full **Xcode** app (not just Command Line Tools):

```bash
# After installing Xcode from the App Store:
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
flutter run -d macos
```

Or use the **placeify (full stack)** launch configuration in VS Code/Cursor (defaults to Chrome).

### Run tests

```bash
cd placeify_server
docker compose up -d
dart test
```

See [placeify_server/BACKEND_SETUP.md](placeify_server/BACKEND_SETUP.md) for more details.
