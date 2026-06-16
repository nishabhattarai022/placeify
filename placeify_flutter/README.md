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

| Where you run the app | What happens |
|----------------------|--------------|
| **Windows / macOS laptop** | Webcam opens with the 3D model overlaid on the live camera view |
| **Android / iPhone** | AR camera opens; model is placed in the scene automatically (tap floor to reposition) |
| **Android emulator** | Same as phone if the emulator supports ARCore |

### Laptop

```bash
flutter run -d windows
```

Allow camera access when prompted. Tap **Try in my room** on a product with a generated 3D model.

### Physical phone (later)

Set your PC LAN IP in `assets/config.json` (e.g. `"http://192.168.1.42:8080"`) or use USB `adb reverse` — see earlier docs in this file.
