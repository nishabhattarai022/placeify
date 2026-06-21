# Placeify workspace guide

## Use THIS folder only

**Canonical repo (latest team + your backend):**

```
/Users/anubudhathoki/Downloads/Placeify-main
```

**Remote:** `backend` → https://github.com/nishabhattarai022/placeify.git  
**Your branch:** `anubudhathoki`

## Do NOT use the old copy

```
~/Downloads/placeify   ← STALE (June 2025, commit 860e598)
```

If you run `flutter run` or `dart bin/main.dart` from `~/Downloads/placeify`, you will see **old UI** no matter how much you update `Placeify-main`.

## Branch roles (no merge)

| Branch | Role |
|--------|------|
| `anubudhathoki` | **Your branch** — integration + your backend (push here) |
| `rosikagajurel` | Integration branch (UI + server wired together) |
| `Nishabhattarai` | Consumer UI (flat `lib/` layout — not directly compatible) |
| `main` | Empty placeholder on GitHub |

Team workflow: pull from `rosikagajurel` via **selective checkout**, not merge.

## Daily start

```bash
cd /Users/anubudhathoki/Downloads/Placeify-main
git checkout anubudhathoki
git pull backend anubudhathoki

cd placeify_server
./scripts/start-server.sh
```

```bash
cd /Users/anubudhathoki/Downloads/Placeify-main/placeify_flutter
flutter clean && flutter pub get && flutter run -d chrome
```

## Re-sync with team integration branch

```bash
cd /Users/anubudhathoki/Downloads/Placeify-main/placeify_server
./scripts/sync-team-work.sh
```

Then commit and `git push backend anubudhathoki`.

## Fix old `~/Downloads/placeify` folder

Option A — delete and re-clone:

```bash
mv ~/Downloads/placeify ~/Downloads/placeify-OLD-BACKUP
git clone -b anubudhathoki https://github.com/nishabhattarai022/placeify.git ~/Downloads/placeify
```

Option B — hard reset existing folder:

```bash
cd ~/Downloads/placeify
git remote add backend https://github.com/nishabhattarai022/placeify.git 2>/dev/null || true
git fetch backend
git checkout -B anubudhathoki backend/anubudhathoki
```

## Demo login

- Consumer: `demo@placeify.app` / `demo1234`
- Dev verification code: `123456`
