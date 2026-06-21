#!/usr/bin/env python3
"""Pull Nishabhattarai frontend files into placeify_flutter without overwriting Serverpod wiring."""

from __future__ import annotations

import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FLUTTER_LIB = ROOT / "placeify_flutter" / "lib"
BRANCH = "origin/Nishabhattarai"

PROTECT_SUBSTRINGS = [
    "serverpod",
    "mock_",
    "app_router.dart",
    "main.dart",
    "app_user.dart",
    "consumer_shop_provider",
    "placeify_server",
    "resolve_server",
    "resolve_media",
    "local_image_path",
    "persist_picked",
    "admin_platform_mapper",
    "admin_finance",
    "vendor_mock_config",
    "payment_update.freezed",
    "vendor_payments_provider",
    "auth_provider.dart",
    "auth_provider.g.dart",
    "admin_repository_provider",
    "vendor_registration_repository_provider",
    "vendor_repository_provider",
    "vendor_product_repository_provider",
    "cart_provider.dart",
    "cart_provider.g.dart",
    "checkout",
    "serverpod_admin",
    "hybrid_",
    "vendor_application_repository_provider",
    "vendor_document_repository_provider",
    "catalog_provider",
    "profile_dashboard_provider",
    "profile_refunds_provider",
    "user_wishlist_provider",
    "vendor_orders_provider",
    "vendor_products_provider",
    "delivery_update_screen",
    "document_upload_step.dart",
    "vendor_product_repository.dart",
]


def nishabh_dart_files() -> set[str]:
    out = subprocess.check_output(
        ["git", "ls-tree", "-r", "--name-only", BRANCH, "--", "lib/"],
        cwd=ROOT,
        text=True,
    )
    return {
        line.replace("lib/", "placeify_flutter/lib/")
        for line in out.splitlines()
        if line.endswith(".dart")
    }


def read_local(rel: str) -> str | None:
    path = ROOT / rel
    if not path.exists():
        return None
    return path.read_text()


def read_nishabh(rel: str) -> str | None:
    git_path = rel.replace("placeify_flutter/lib/", "lib/")
    try:
        return subprocess.check_output(
            ["git", "show", f"{BRANCH}:{git_path}"],
            cwd=ROOT,
            text=True,
        )
    except subprocess.CalledProcessError:
        return None


def normalize(content: str) -> str:
    return content.replace("package:placeify/", "package:placeify_flutter/")


def is_protected(rel: str, local: str | None, remote: str | None) -> bool:
    lower = rel.lower()
    if any(token in lower for token in PROTECT_SUBSTRINGS):
        return True
    if "/providers/" in lower and local and remote:
        local_l = local.lower()
        remote_l = remote.lower()
        if any(token in local_l for token in ("serverpod", "hybrid", "placeify_client")):
            if "serverpod" not in remote_l and "hybrid" not in remote_l:
                return True
    return False


def main() -> None:
    pulled: list[str] = []
    skipped: list[str] = []
    missing: list[str] = []

    for rel in sorted(nishabh_dart_files()):
        remote_raw = read_nishabh(rel)
        if remote_raw is None:
            continue
        remote = normalize(remote_raw)
        local = read_local(rel)

        if local is None:
            if is_protected(rel, local, remote):
                skipped.append(rel)
                continue
            (ROOT / rel).parent.mkdir(parents=True, exist_ok=True)
            (ROOT / rel).write_text(remote)
            missing.append(rel)
            continue

        if normalize(local) == remote:
            continue

        if is_protected(rel, local, remote):
            skipped.append(rel)
            continue

        (ROOT / rel).write_text(remote)
        pulled.append(rel)

    print(f"Pulled updated: {len(pulled)}")
    print(f"Added new: {len(missing)}")
    print(f"Skipped protected: {len(skipped)}")
    for path in pulled[:20]:
        print(f"  updated {path}")
    if len(pulled) > 20:
        print(f"  ... +{len(pulled) - 20} more")
    for path in missing:
        print(f"  added {path}")


if __name__ == "__main__":
    main()
