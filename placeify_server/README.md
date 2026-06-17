# placeify_server

Serverpod backend for Placeify.

## Quick start (local development)

**Terminal 1 — database**

```powershell
cd placeify_server
docker compose up -d
```

**Terminal 2 — API server** (keep this running)

```powershell
cd placeify_server
dart bin/main.dart --apply-migrations
```

First run applies migrations. Later runs:

```powershell
dart bin/main.dart
```

API: `http://localhost:8080`

**Terminal 3 — Flutter app**

```powershell
cd placeify_flutter
flutter run -d chrome
```

Or on a phone/emulator:

```powershell
flutter run
```

Update `placeify_flutter/assets/config.json` → `physicalApiUrl` with your PC's LAN IP when testing on a physical device.

## Demo login

In the app: **Log In** → **Use demo account**

- Email: `demo@placeify.app`
- Password: `demo1234`

Registration verification code in development: `123456`

## Tripo 3D (optional)

```powershell
copy config\tripo_api_key.example.yaml config\tripo_api_key.yaml
```

Add your key from https://platform.tripo3d.ai/api-keys

## Database reset (deletes all data)

```powershell
docker compose down -v
docker compose up -d
dart bin/main.dart --apply-migrations
```

## App database tables

| Table | Purpose |
|-------|---------|
| `user` | Placeify profile linked to auth |
| `vendor` | Vendor shops |
| `product` | Marketplace catalog (vendor uploads) |
| `category` | Product categories |
| `cart` / `cart_item` | Shopping cart |
| `order` / `order_item` | Checkout orders |
| `wishlist_item` | Saved products |
| `review` | Product reviews |
| `ar_session` | AR preview sessions |
| `notification_preference` | User notification settings |
| `customization_request` | Custom furniture requests |

Auth and Serverpod internal tables are created automatically with migrations.

When finished, stop the server with `Ctrl+C`, then:

```powershell
docker compose stop
```
