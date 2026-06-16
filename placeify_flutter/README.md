# placeify_flutter

Flutter client for Placeify (furniture marketplace + AR preview).

## Run locally

1. Start the server (Postgres, Redis, then `dart bin/main.dart` in `placeify_server`).
2. From this folder:

```bash
flutter pub get
flutter run
```

Default API URL is in `assets/config.json` (`http://localhost:8080`).

## Testing 3D / “Try in my room”

| Where you run the app | What works | Server URL |
|----------------------|------------|------------|
| **Windows / macOS desktop** (`flutter run -d windows`) | 3D Preview tab + fullscreen model when you tap **Try in my room** (no AR camera) | `localhost` in `config.json` |
| **Android emulator on laptop** | Full AR if the emulator image supports ARCore | `localhost` → auto-mapped to `10.0.2.2` |
| **Physical phone (later)** | Full AR camera + placement | See below |

### Laptop (now)

```bash
# Desktop — quickest way to verify the generated GLB loads
flutter run -d windows

# Or Android emulator — closer to real AR (needs ARCore-capable AVD)
flutter run
```

On desktop, **Try in my room** downloads the model and opens a fullscreen 3D viewer (same GLB as on phone).

### Physical phone (later)

Pick one:

**Option A — same Wi‑Fi, LAN IP (recommended)**

1. Find your PC’s IP (e.g. `192.168.1.42`).
2. Edit `assets/config.json`:

```json
{
  "apiUrl": "http://192.168.1.42:8080"
}
```

3. Rebuild and run on the phone. Phone and PC must be on the same network.

**Option B — USB debugging**

```bash
adb reverse tcp:8080 tcp:8080
adb reverse tcp:8082 tcp:8082
flutter run
```

Keep `localhost` in `config.json`; the phone reaches your PC through USB.

**Option C — one-off override**

```bash
flutter run --dart-define=SERVER_URL=http://192.168.1.42:8080
```

### Checklist

- Server running (API `:8080`, static uploads `:8082`).
- Product has a generated model (`model3dUrl` set after vendor **Build 3D**).
- On product detail: switch to **3D Preview**, then **Try in my room**.
- In AR: point at the floor and **tap** to place the model.
