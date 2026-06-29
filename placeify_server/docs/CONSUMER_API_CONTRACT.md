# Consumer API Contract

**Status:** Canonical — do not add alternate consumer endpoints without updating this file and `test/integration/consumer_journey_contract_test.dart`.

**Audience:** Backend owner (you), frontend teammate, and integration tests.

**Related:**
- [USER_API.md](./USER_API.md) — endpoint reference
- [USER_FRONTEND_BACKEND_MATRIX.md](./USER_FRONTEND_BACKEND_MATRIX.md) — screen ↔ API mapping
- `test/integration/consumer_journey_contract_test.dart` — automated contract enforcement

---

## Rules

1. **Protocol first** — edit `lib/src/models/*.spy.yaml`, run `serverpod generate`, then endpoints/services.
2. **One consumer surface** — use only the modules listed in §2. Do not call `order.*` for customer apps.
3. **Contract tests must pass** — any breaking change requires updating tests in the same commit.
4. **UI mappers live in Flutter** — backend returns protocol DTOs; Flutter maps to Nisha UI models.

---

## Canonical consumer modules

| Module | Purpose | Auth |
|--------|---------|------|
| `emailIdp` / `jwtRefresh` | Register, login, password reset | Public |
| `user` | Profile, dashboard, orders (summary + detail), cancel, payment read, AR history | Yes |
| `product` | Categories, search, product detail, shops | Public |
| `cart` | Server cart CRUD | Yes |
| `checkout` | Place order, clear cart | Yes |
| `wishlist` | Save/remove products | Yes |
| `refund` | Return/refund requests | Yes |
| `notification` | Preference toggles + in-app feed | Yes |
| `review` | Submit/list product reviews | Yes |
| `ar` | Record/list AR sessions | Yes |

### Deprecated (do not use in consumer app)

| Module | Replacement |
|--------|-------------|
| `order.listMyOrders` | `user.listMyOrders` → `List<UserOrderSummary>` |
| `order.getOrder` | `user.getMyOrder` → `UserOrderDetail` |
| `order.listDeliveryUpdates` | `user.getMyOrder` → `deliveryUpdates` on detail |
| `user.completePayment` | Vendor updates via `payment.updateOrderPaymentStatus` (consumer read-only) |

Calling deprecated endpoints returns `PlaceifyException` with code `DEPRECATED_ENDPOINT` or `FORBIDDEN`.

---

## Contract: full consumer journey

This is what `consumer_journey_contract_test.dart` enforces end-to-end.

### 1. Authentication & profile

```
emailIdp.login → JWT
user.updateProfile(name, phone?, address?)
user.getCurrentUser → User
user.getDashboard → UserDashboard
```

**UserDashboard fields (stable):**
`profile`, `orderCount` (excludes cancelled/autoCancelled/rejected orders), `wishlistCount`, `cartItemCount`, `arSessionCount`, `refundCount`

### 2. Catalog

```
product.searchProducts(ProductSearchInput) → ProductPage
product.getProduct(productId) → Product?
product.listCategories() → List<Category>
```

**Seed catalog (Phase 4 — Nisha browse alignment):**
- **8 categories:** `chairs`, `sofas`, `desks`, `beds`, `tables`, `storage`, `lighting`, `outdoor`
- **18 products:** UI ids `p1`…`p18` (insert order in `catalog_seed.dart`; client maps DB id ↔ `pn` via `ProductIdCodec`)
- **Legacy rows:** older DBs may use `lights`, `decor`, or `tables` for some categories; Flutter `CatalogCategoryUtils.matchesUiCategory` maps these when browsing

**Consumer browse behavior:**
- `browseCategoryProductsProvider` — live catalog first, `MockProductRepository` fallback when API index is empty
- `homeRecommendedProductsProvider` — room-based picks from live catalog, mock home cards when empty
- `productByIdProvider` — catalog index, then mock, then shop sync lookup (unchanged hybrid)

### 3. Cart & checkout

```
cart.addToCart(productId, quantity) → CartItem
cart.getCartItems() → List<CartItem>
cart.updateCartItemQuantity(productId, quantity) → CartItem
cart.removeFromCart(productId) → void

checkout.checkout(CheckoutRequest) → CheckoutResult
```

**CheckoutRequest (stable):**
- `shippingAddress: String` (non-empty)
- `paymentMethod: PaymentMethod` — `cod`, `mockOnline`, `esewa`, `khalti`

**CheckoutResult (stable):**
- `order: Order` (server entity)
- `itemCount: int`

**Error codes (stable):** `AUTH_REQUIRED`, `CART_EMPTY`, `PRODUCT_NOT_FOUND`, `INVALID_ADDRESS`

### 4. Orders

```
user.listMyOrders(limit, offset, status?) → List<UserOrderSummary>
user.getMyOrder(orderId) → UserOrderDetail
user.cancelMyOrder(orderId, reason) → UserOrderDetail
user.getMyOrderPayment(orderId) → UserOrderPaymentSummary
```

**UserOrderSummary (stable):**
`id`, `orderNumber`, `status`, `totalAmount`, `placedAt`, `itemCount`, `primaryProductName?`, `latestDeliveryStage?`, `latestDeliveryNote?`, `orderPaymentStatus`

**UserOrderDetail (stable):**
Above + `shippingAddress`, `items[]`, `deliveryUpdates[]`, `payment`, `paymentUpdates[]`

**UserOrderLineItem (stable):**
`productId`, `productName`, `thumbnailUrl?`, `unitPrice`, `quantity`

### 5. Wishlist

```
wishlist.toggleWishlist(productId) → bool
wishlist.listMyWishlist(pagination?) → WishlistPage
wishlist.addToWishlist(productId) → WishlistItem
wishlist.removeFromWishlist(productId) → void
```

### 6. Refunds

```
refund.createRefundRequest(orderId, reason) → RefundRequestSummary
refund.listMyRefundRequests(pagination?) → List<RefundRequestSummary>
refund.getRefundRequest(refundId) → RefundRequestSummary
```

**RequestStatus (stable):** `pending`, `inProgress`, `completed`, `rejected`

### 7. Notifications

```
notification.getPreferences() → NotificationPreference
notification.updatePreferences(...) → NotificationPreference
notification.listInAppNotifications(limit, offset) → List<InAppNotificationSummary>
notification.unreadInAppNotificationCount() → int
notification.markInAppNotificationRead(notificationId) → void
notification.markAllInAppNotificationsRead() → void
```

**NotificationPreference booleans (stable):**
`orderUpdates`, `refundStatus`, `arReminders`, `priceDropAlerts`, `vendorMessages`, `promotions`

### 8. Reviews & AR

```
review.submitReview(productId, orderId, rating, comment?) → Review
review.listProductReviews(productId, limit, offset) → List<Review>

ar.recordSession(productId, deviceInfo?, snapshotUrl?) → ARSession
user.listMyArSessions(limit, offset) → List<UserArSessionSummary>
```

---

## Product ID convention

| Layer | Format |
|-------|--------|
| API / DB | `int` product id |
| Flutter UI | `p{int}` e.g. `p4` |
| Codec | `placeify_flutter/lib/features/cart/data/product_id_codec.dart` |

---

## Payment policy (contract)

- Checkout creates `payment_transaction` with `status: pending`.
- Consumer **cannot** call `user.completePayment` — returns `FORBIDDEN`.
- Vendor confirms payment via `payment.updateOrderPaymentStatus`.
- Consumer reads status via `user.getMyOrderPayment` / `UserOrderDetail.payment`.

---

## Verify contract locally

```bash
cd placeify_server
docker compose up -d
./scripts/verify-consumer-contract.sh
```

Or manually:

```bash
dart test test/integration/consumer_journey_contract_test.dart
dart test test/integration/canonical_api_surface_test.dart
```

---

## Change process

When adding or changing a consumer field:

1. Update `.spy.yaml`
2. `serverpod generate`
3. Implement endpoint/service/store
4. Update this document (§ contract section)
5. Update `USER_FRONTEND_BACKEND_MATRIX.md` if UI-facing
6. Extend `consumer_journey_contract_test.dart`
7. Run `./scripts/verify-consumer-contract.sh`

---

## Changelog

| Date | Change |
|------|--------|
| 2026-06-24 | Initial canonical contract; deprecated `order.*` module for consumers |
