# Placeify Production Authentication Guide

## Overview

Placeify uses **Serverpod 3.4.8** email/password auth with **JWT access tokens** and **refresh tokens**. Verification and password-reset codes are sent via **Resend** (or console logging in development).

---

## Required environment variables

### Database (managed PostgreSQL)

| Variable | Maps to | Example |
|----------|---------|---------|
| `SERVERPOD_DATABASE_HOST` | `database.host` | `ep-xxx.neon.tech` |
| `SERVERPOD_DATABASE_PORT` | `database.port` | `5432` |
| `SERVERPOD_DATABASE_NAME` | `database.name` | `placeify` |
| `SERVERPOD_DATABASE_USER` | `database.user` | `postgres` |
| `SERVERPOD_PASSWORD_database` | passwords `database` | *(secret)* |

### API public URL

| Variable | Maps to |
|----------|---------|
| `SERVERPOD_API_SERVER_PUBLIC_HOST` | `apiServer.publicHost` |
| `SERVERPOD_API_SERVER_PUBLIC_SCHEME` | `apiServer.publicScheme` (`https`) |
| `SERVERPOD_API_SERVER_PUBLIC_PORT` | `apiServer.publicPort` (`443`) |

### Auth secrets (required)

| Variable | Purpose |
|----------|---------|
| `SERVERPOD_PASSWORD_serviceSecret` | Insights / internal (min 20 chars) |
| `SERVERPOD_PASSWORD_emailSecretHashPepper` | Password hashing pepper |
| `SERVERPOD_PASSWORD_jwtRefreshTokenHashPepper` | Refresh token hashing |
| `SERVERPOD_PASSWORD_jwtHmacSha512PrivateKey` | JWT signing key |

### Email (staging/production)

| Variable | Purpose |
|----------|---------|
| `SERVERPOD_PASSWORD_emailProvider` | `resend` or `console` |
| `SERVERPOD_PASSWORD_emailFrom` | `Placeify <noreply@yourdomain.com>` |
| `SERVERPOD_PASSWORD_resendApiKey` | [Resend](https://resend.com) API key |

---

## Run locally (development)

```bash
cd placeify_server
docker compose up -d
./scripts/start-server.sh
```

Emails log to the server terminal (`emailProvider: console`).

---

## Run staging

```bash
export SERVERPOD_DATABASE_HOST=your-staging-db-host
export SERVERPOD_DATABASE_NAME=placeify_staging
export SERVERPOD_PASSWORD_database=...
# ... all auth + email vars above
export SERVERPOD_PASSWORD_emailProvider=resend
export SERVERPOD_PASSWORD_resendApiKey=re_...

cd placeify_server
dart bin/main.dart --mode staging --apply-migrations
```

Or use `./scripts/start-production.sh` with `--mode staging` (edit script if needed).

---

## Run production

1. Provision **managed PostgreSQL** (Neon, Supabase, RDS, etc.).
2. Set all environment variables on your host (Railway, Fly.io, GCP, etc.).
3. Deploy Docker image or run `dart bin/main.dart --mode production --apply-migrations`.
4. Verify: `curl https://api.placeify.app/` → `OK`.

**Migrations:** `--apply-migrations` applies pending SQL migrations safely on startup. Run once per deploy or keep enabled for zero-downtime schema updates.

---

## Frontend API URL

Build with environment defines:

```bash
# Staging
flutter build apk --dart-define=APP_ENV=staging

# Production
flutter build apk --dart-define=APP_ENV=production

# Override URL directly
flutter run --dart-define=SERVER_URL=https://api-staging.placeify.app/
```

Update `stagingApiUrl` / `productionApiUrl` in `lib/core/config/server_config.dart` to match your domains.

---

## placeify_client dependency

Frontend `pubspec.yaml`:

```yaml
placeify_client:
  git:
    url: https://github.com/rosikagajurel/Placeify.git
    ref: anubudhathoki
    path: placeify_client
```

Push backend changes before teammates run `flutter pub get`.

---

## Auth endpoints (Serverpod RPC)

| Endpoint | Auth required | Description |
|----------|---------------|-------------|
| `emailIdp.startRegistration` | No | `{ email }` → `accountRequestId` |
| `emailIdp.verifyRegistrationCode` | No | `{ accountRequestId, verificationCode }` → token |
| `emailIdp.finishRegistration` | No | `{ registrationToken, password }` → `AuthSuccess` |
| `emailIdp.login` | No | `{ email, password }` → `AuthSuccess` |
| `emailIdp.startPasswordReset` | No | `{ email }` → `passwordResetRequestId` |
| `emailIdp.verifyPasswordResetCode` | No | → reset token |
| `emailIdp.finishPasswordReset` | No | `{ finishPasswordResetToken, newPassword }` |
| `jwtRefresh.refreshAccessToken` | No | `{ refreshToken }` → `AuthSuccess` |
| `user.getCurrentUser` | **Yes** | → `User?` |
| `user.updateProfile` | **Yes** | `{ name, phone?, address? }` → `User` |
| `user.becomeVendor` | **Yes** | → `User` (role = vendor) |
| `greeting.hello` | No | Public demo |

---

## Manual setup checklist

- [ ] PostgreSQL database created
- [ ] DNS + HTTPS for API host
- [ ] Resend domain verified + API key
- [ ] All `SERVERPOD_PASSWORD_*` secrets set (use strong random values)
- [ ] `placeify_client` branch pushed to GitHub
- [ ] Frontend `server_config.dart` URLs updated
- [ ] Run `AUTH_QA_CHECKLIST.md` on staging

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Emails not received | Check `emailProvider=resend`, Resend dashboard, spam folder |
| `AuthServices is not set` in tests | Run `dart test` from `placeify_server` with Docker up |
| 401 on `user.*` | Ensure `FlutterAuthSessionManager` + `auth.initialize()` on client |
| Port in use | Only one server instance; `lsof -ti :8080 \| xargs kill` |
