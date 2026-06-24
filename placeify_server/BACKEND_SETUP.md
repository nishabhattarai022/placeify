# Placeify Backend Setup

Quick guide to get the Serverpod backend running locally.

## Prerequisites

- Dart SDK 3.8+
- Docker Desktop (running)
- Serverpod CLI 3.4.8

```bash
dart pub global activate serverpod_cli 3.4.8
```

## One-time setup

From the repo root:

```bash
dart pub get
```

Copy passwords (only needed once per machine):

```bash
cp placeify_server/config/passwords.yaml.example placeify_server/config/passwords.yaml
```

## Start the backend

### Option A — VS Code / Cursor

Run the **placeify_server** launch configuration (starts Docker + server with migrations).

### Option B — Terminal

```bash
# 1. Start Postgres + Redis
cd placeify_server
docker compose up -d

# 2. Install deps & generate code
cd ..
dart pub get
cd placeify_server
dart pub global run serverpod_cli generate

# 3. Start server (applies migrations automatically)
dart bin/main.dart --apply-migrations
```

Server URLs:

| Service   | URL                    |
|-----------|------------------------|
| API       | http://localhost:8080  |
| Insights  | http://localhost:8081  |
| Web       | http://localhost:8082  |

## User backend API

Consumer dashboard endpoints (`getDashboard`, `listMyOrders`, wishlist, refunds) are documented in [docs/USER_API.md](docs/USER_API.md).

## Run tests

```bash
cd placeify_server
docker compose up -d
dart test
```

## Stop services

```bash
cd placeify_server
docker compose down
```

## Production / staging

See [PRODUCTION_AUTH.md](PRODUCTION_AUTH.md) for environment variables, email (Resend), and deployment.

## Consumer API & frontend alignment

| Doc | Purpose |
|-----|---------|
| [docs/CONSUMER_API_CONTRACT.md](docs/CONSUMER_API_CONTRACT.md) | **Canonical consumer API** — modules, payloads, deprecated surface |
| [docs/USER_API.md](docs/USER_API.md) | Endpoint reference |
| [docs/USER_FRONTEND_BACKEND_MATRIX.md](docs/USER_FRONTEND_BACKEND_MATRIX.md) | Per-screen UI ↔ API mapping |

Verify contract after backend changes:

```bash
cd placeify_server && ./scripts/verify-consumer-contract.sh
```

When your teammate adds UI, check the matrix first: most consumer features already have endpoints — gaps are usually **frontend wiring**, not missing backend.

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Database connection refused | `docker compose up -d` and wait ~5s |
| Password authentication failed | Ensure `config/passwords.yaml` matches `docker-compose.yaml` |
| Port 8090 in use | `docker compose down` then retry |
| Checkout returns 500 Internal Server Error | Run `./scripts/fix-migrations.sh` then restart the server — adds missing `paymentMethod` column on `payment_transaction` |
| Code out of sync after model changes | `serverpod generate` from `placeify_server/` |
