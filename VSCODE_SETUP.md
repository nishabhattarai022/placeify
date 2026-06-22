# VS Code setup

## Open the correct project (required)

Your **only** up-to-date repo:

```
/Users/anubudhathoki/Downloads/Placeify-main
```

In VS Code:

1. **File → Open Workspace from File…**
2. Choose: `~/Downloads/Placeify-main/Placeify.code-workspace`

Or: **File → Open Folder…** → select `Placeify-main` (not `placeify` alone).

## Shortcut paths (symlinks)

These folders point to the same project so old VS Code recents still work:

| Path | Points to |
|------|-----------|
| `~/Downloads/placeify` | `Placeify-main` |
| `~/Downloads/placeify-anubudhathoki-2` | `Placeify-main` |

After opening, run **Developer: Reload Window** from the Command Palette once.

## Verify you have the new User UI

In the explorer you should see:

```
placeify_flutter/lib/features/orders/     ← Nisha orders UI (new)
placeify_flutter/lib/features/profile/
placeify_server/
placeify_client/
```

If `features/orders/` is missing, you opened a stale copy.

## Run from VS Code terminal

```bash
cd placeify_server
./scripts/start-server.sh
```

New terminal:

```bash
cd placeify_server
./scripts/run-flutter.sh -d chrome
```

Or use the **Run and Debug** panel → **placeify (full stack)**.

## Do not use

- `Placeify-main-OLD-DO-NOT-USE-860e598`
- `placeify-anubudhathoki-2-OLD-DO-NOT-USE`
- `placeify-frontend-nisha` (Nisha’s flat layout, not the monorepo)
