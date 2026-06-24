#!/usr/bin/env bash
# Re-wire Nisha cart UI to backend checkout after any frontend port.
# Safe to run multiple times. Does not replace cart_screen.dart — only patches checkout line.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CART_SCREEN="$ROOT/placeify_flutter/lib/features/cart/presentation/cart_screen.dart"

if [[ ! -f "$CART_SCREEN" ]]; then
  echo "wire-cart-checkout: cart_screen.dart not found, skip"
  exit 0
fi

if grep -q "checkoutCart(ref, context)" "$CART_SCREEN"; then
  echo "✓ Cart checkout already wired"
  exit 0
fi

python3 - <<'PY'
from pathlib import Path

path = Path("placeify_flutter/lib/features/cart/presentation/cart_screen.dart")
text = path.read_text()

if "import 'cart_actions.dart';" not in text:
    text = text.replace(
        "import 'cart_tokens.dart';",
        "import 'cart_actions.dart';\nimport 'cart_tokens.dart';",
    )

old = """onCheckout: () {
                  PlaceifyToast.show(context, 'Checkout coming soon');
                },"""
new = "onCheckout: () => checkoutCart(ref, context),"

if old not in text:
    raise SystemExit("wire-cart-checkout: expected Nisha checkout stub not found")

text = text.replace(old, new)
text = text.replace(
    "import '../../../core/widgets/toast_overlay.dart';\n", ""
)
path.write_text(text)
print("✓ Patched cart_screen.dart → checkoutCart")
PY

cd "$ROOT"
