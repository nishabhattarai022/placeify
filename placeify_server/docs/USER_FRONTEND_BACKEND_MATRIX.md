# User Frontend ↔ Backend Alignment Matrix

**Purpose:** Single source of truth for consumer/user features. Backend owner uses this to know what the UI needs; frontend owner uses it to know which endpoints exist. Prevents repeated field/payload/naming mismatches.

**Related docs:**
- **Canonical contract:** [CONSUMER_API_CONTRACT.md](./CONSUMER_API_CONTRACT.md)
- API reference: [USER_API.md](./USER_API.md)
- Protocol types (generated): `placeify_client/lib/src/protocol/`
- Model definitions (source of truth): `placeify_server/lib/src/models/*.spy.yaml`

**Last audited:** 2026-06-24 against `anubudhathoki` branch + local `Nishabhattarai` UI.

---

## 1. Root cause of repeated mismatches

**Permanent fix (backend):** [CONSUMER_API_CONTRACT.md](./CONSUMER_API_CONTRACT.md) + `test/integration/consumer_journey_contract_test.dart`. Run `./scripts/verify-consumer-contract.sh` after every backend change.

| Problem | Why it happens | Permanent fix |
|---------|----------------|---------------|
| Field mismatches | UI uses local Freezed models (`Order`, `ProfileRefund`) separate from protocol DTOs | **Mapper layer** in `placeify_flutter/lib/features/*/data/*_mapper.dart` — never map in widgets |
| Payload mismatches | Checkout/cart wired in provider but UI still shows mock | **One repository per feature**; screens only call providers |
| API response mismatches | Two order APIs (`user.*` vs `order.*`) | **Standardize on `user.*`** for consumer flows (see §3) |
| Missing endpoints | UI built before API (addresses, profile photo) | Track in §5 backlog; add spy.yaml + endpoint before UI ships |
| Typing drift | `PaymentStatus` exists in UI and API with different values | Document enum mapping in matrix (§4); never reuse names for different enums |
| Naming inconsistency | `consumer` vs `customer`, `p1` vs `1` product ids | **ProductIdCodec** for ids; backend uses `UserRole.consumer` |

### Integration architecture (target state)

```
UI Screen (Nisha — do not change layout)
    ↓
Riverpod Provider (feature/presentation/providers)
    ↓
Repository interface (feature/domain/repositories)
    ↓
Serverpod repository + Mapper (feature/data)
    ↓
placeify_client protocol DTO
    ↓
Serverpod endpoint → service → store → PostgreSQL
```

**Rule for backend owner:** When UI adds a field, add it to `.spy.yaml` first → `serverpod generate` → update mapper → update USER_API.md + this matrix.

**Rule for frontend owner:** Routed consumer screens must not read `ProfileMockData` or `MockOrderRepository` when a Serverpod provider exists.

---

## 2. Consumer UI inventory (two tracks)

### Track A — Primary mobile app (routed in `app_router.dart`)

| Route | Screen | Current data source | Target backend provider |
|-------|--------|---------------------|-------------------------|
| `/profile` | `ProfileHomeScreen` | Auth API + **mock stats** | `profileDashboardProvider` |
| `/profile/orders` | `MyOrdersScreen` | **MockOrderRepository** | `ordersProvider` → `ServerpodOrderRepository` |
| `/profile/orders/:id` | `OrderDetailScreen` | Mock | `user.getMyOrder` via `ServerpodOrderRepository` |
| `/profile/orders/:id/tracking` | `OrderTrackingScreen` | Mock | Same |
| `/profile/wishlist` | `WishlistScreen` | **wishlistProvider** (in-memory) | `userWishlistProvider` |
| `/bookmarks` | `BookmarksScreen` | Same mock wishlist | `userWishlistProvider` |
| `/profile/notifications` | `ProfileNotificationsScreen` | **ProfileMockData** | `profileNotificationsProvider` |
| `/profile/refund` | `ProfileRefundScreen` | **ProfileMockData** | `profileRefundsProvider` |
| `/profile/ar-history` | `ProfileArHistoryScreen` | **ProfileMockData** | `profileArSessionsProvider` |
| `/profile/password` | `ProfilePasswordScreen` | **No API** (toast only) | `emailIdp` password reset or new endpoint |
| `/profile/settings` | `ProfileSettingsScreen` | Local dev toggle | N/A (dev only) |
| `/cart` | `CartScreen` | **Serverpod cart + checkout** | `cartProvider` + `checkoutCart()` in `cart_actions.dart` ✅ |
| `/home`, `/browse`, `/product/:id` | Catalog | **Mock browse** + live catalog index | `product.searchProducts` / `catalogIndexProvider` |

### Track B — Desktop user dashboard (`features/user/*`, **not in router**)

| Nav path | Screen | Data source | Status |
|----------|--------|-------------|--------|
| `/user/dashboard` | `UserDashboardScreen` | `profileDashboardProvider` | API-ready, unrouted |
| `/user/orders` | `UserOrdersPage` | `profileOrdersProvider` | API-ready, unrouted |
| `/user/wishlist` | `UserWishlistPage` | `userWishlistProvider` | API-ready, unrouted |
| `/user/cart` | — | Would use `cartProvider` | No page file |
| `/user/refund` | `UserRefundPage` | Placeholder | Needs wiring |
| `/user/notifications` | `UserNotificationsPage` | Placeholder | Needs wiring + in-app API |
| `/user/account` | Placeholder | — | Needs profile edit UI |
| `/user/settings` | Placeholder | — | — |

**Decision needed (team):** Either register `/user/*` routes OR wire Track A profile screens to the same providers Track B already uses. Backend supports both; duplication is a frontend routing issue.

---

## 3. Feature-by-feature mapping

### 3.1 Dashboard overview

| Item | Detail |
|------|--------|
| **UI screens** | `ProfileHomeScreen` (stats strip), `UserDashboardScreen`, `ProfileStatsStrip`, `ProfileOrdersTile` |
| **UI expects** | `UserDashboard`: `profile`, `orderCount`, `wishlistCount`, `cartItemCount`, `arSessionCount`, `refundCount` |
| **Endpoints** | `GET user.getDashboard` |
| **Request** | None (auth JWT) |
| **Response** | `UserDashboard` → see `user_dashboard.spy.yaml` |
| **Validation** | Auth required; auto-creates `user` row if missing |
| **DB entities** | `user`, `order`, `wishlist_item`, `cart`/`cart_item`, `ar_session`, `refund_request` |
| **Flutter wiring** | `profileDashboardProvider` → `ServerpodProfileRepository` ✅ |
| **Gap** | `ProfileStatsStrip` still uses `ProfileMockData.stats` ❌ |

---

### 3.2 User profile (view)

| Item | Detail |
|------|--------|
| **UI screens** | `ProfileHero`, `UserDashboardScreen` header |
| **UI expects** | `User.name`, `email`, `phone?`, `address?`, `profileImageUrl?`, `role` |
| **Endpoints** | `user.getCurrentUser`, `user.getDashboard` (includes profile) |
| **Request** | None |
| **Response** | `User` protocol type |
| **Validation** | Auth required |
| **DB** | `user` table |
| **Flutter wiring** | `currentUserProvider` (auth) ✅ |
| **Gap** | `profileImageUrl` column exists; **no upload endpoint** ❌ |

---

### 3.3 Edit profile

| Item | Detail |
|------|--------|
| **UI screens** | **No dedicated consumer screen**; `UserAccountPage` is placeholder |
| **UI expects** | Form: name, phone, address (single text field) |
| **Endpoints** | `user.updateProfile(name, phone?, address?)` |
| **Request** | `name` required non-empty; `phone`/`address` optional strings |
| **Response** | Updated `User` |
| **Validation** | `INVALID_NAME` if name empty |
| **DB** | `user.name`, `user.phone`, `user.address` |
| **Backend status** | ✅ Implemented |
| **Gap** | **No UI screen wired** ❌ |

---

### 3.4 Address management

| Item | Detail |
|------|--------|
| **UI screens** | **None** (no address book UI) |
| **UI expects (checkout)** | Single `shippingAddress` string on checkout |
| **Endpoints** | `user.updateProfile(address)` for default; `checkout.checkout(CheckoutRequest.shippingAddress)` per order |
| **Request** | `CheckoutRequest { shippingAddress: String, paymentMethod: PaymentMethod }` |
| **Response** | `CheckoutResult { order, itemCount }` |
| **Validation** | `INVALID_ADDRESS` if shipping empty |
| **DB** | `user.address` (optional default); `order.shippingAddress` (required per order) |
| **Backend status** | ✅ Partial — single address string only |
| **Gap** | **No saved-address book** (multiple addresses, labels, default flag) — needs new table `user_address` + CRUD if UI adds it |

---

### 3.5 Orders (list)

| Item | Detail |
|------|--------|
| **UI screens** | `MyOrdersScreen`, `UserOrdersPage`, `ProfileOrdersScreen` |
| **UI model (routed)** | Local `Order` — see `orders/domain/models/order.dart` |
| **API model** | `UserOrderSummary` |
| **Endpoints** | `user.listMyOrders(limit, offset, status?)` |
| **Request** | `limit` default 50; `status` optional `OrderStatus` filter |
| **Response** | `List<UserOrderSummary>` |
| **Mapper** | `OrderApiMapper.fromSummary` → local `Order` |
| **Enum mapping** | `OrderStatus` (API) → `ConsumerOrderStatus` (UI) — see §4 |
| **DB** | `order`, `order_item` |
| **Flutter wiring** | `profileOrdersProvider` ✅ API; `ordersProvider` ❌ still `MockOrderRepository` |
| **Gap** | Switch `orderRepositoryProvider` to `ServerpodOrderRepository` |

#### `UserOrderSummary` fields

| API field | UI `Order` field | Notes |
|-----------|------------------|-------|
| `id` (int) | `id` (String) | `id.toString()` |
| `orderNumber` | `orderNumber` | Prefix `#` in mapper |
| `status` | `status` | Via `OrderApiMapper.mapStatus` |
| `totalAmount` | `total`, `subtotal` | Placeholder when no line items |
| `placedAt` | `placedAt` | |
| `itemCount` | `items[].quantity` sum | Placeholder item when list empty |
| `primaryProductName` | `items[0].productName` | |
| `latestDeliveryStage` | `status` / timeline | |
| `orderPaymentStatus` | `paymentStatus` | `unpaid→pending`, `paymentReceived/Confirmed→paid` |

---

### 3.6 Order details & tracking

| Item | Detail |
|------|--------|
| **UI screens** | `OrderDetailScreen`, `OrderTrackingScreen` |
| **UI expects** | `Order` with `items[]`, `statusHistory[]`, `paymentStatus`, `paymentMethod`, `deliveryAddress`, `trackingNumber?`, `returnReason?` |
| **Endpoints** | `user.getMyOrder(orderId)`, `user.cancelMyOrder(orderId, reason)` |
| **Response** | `UserOrderDetail` with `items`, `deliveryUpdates`, `payment`, `paymentUpdates` |
| **Mapper** | `OrderApiMapper.fromDetail` |
| **DB** | `order`, `order_item`, `order_delivery_update`, `payment_transaction` |
| **Gap** | Routed screens use mock `orderByIdProvider` ❌ |

#### `UserOrderLineItem` → UI `OrderItem`

| API | UI |
|-----|-----|
| `productId` (int) | `productId` (`p{id}` via ProductIdCodec) |
| `productName` | `productName` |
| `thumbnailUrl?` | `productImageUrl` |
| `unitPrice` | `unitPrice` |
| `quantity` | `quantity` |

---

### 3.7 Cart

| Item | Detail |
|------|--------|
| **UI screens** | `CartScreen`, `CartLineCard`, `CartOrderSummary` |
| **UI model** | `CartLineItem { productId, quantity }` + resolved `Product` for display |
| **Endpoints** | `cart.getCartItems`, `addToCart`, `updateCartItemQuantity`, `removeFromCart`, `clearCart` |
| **Request** | `productId: int`, `quantity: int` |
| **Response** | `CartItem { productId, quantity, unitPrice, product? }` |
| **Validation** | `PRODUCT_NOT_FOUND`, quantity ≥ 1 |
| **DB** | `cart`, `cart_item` |
| **Flutter wiring** | `cartProvider` → `ServerpodCartRepository` ✅; `checkoutCart()` in `cart_actions.dart` ✅ |
| **Gap** | Product resolution → `productById` checks live catalog + mock ✅ |

---

### 3.8 Checkout

| Item | Detail |
|------|--------|
| **UI screens** | `CartScreen` checkout button |
| **UI expects** | Success toast + navigate to orders; payment method selection |
| **Endpoints** | `checkout.checkout(CheckoutRequest)` |
| **Request** | `{ shippingAddress: string, paymentMethod: PaymentMethod }` |
| **Response** | `CheckoutResult { order: Order, itemCount: int }` |
| **PaymentMethod enum** | `cod`, `mockOnline`, `esewa`, `khalti` |
| **DB** | Creates `order`, `order_item`, `payment_transaction`; clears `cart_item` |
| **Flutter wiring** | `cartProvider.checkout()` ✅ via `checkoutCart()` |
| **Gap** | Optional payment method picker UI (defaults to COD) |

---

### 3.9 Payment methods & payment status

| Item | Detail |
|------|--------|
| **UI screens** | Order detail payment chip; no checkout picker |
| **UI enum** | `PaymentStatus`: `pending`, `paid`, `failed`, `refunded` |
| **API enum** | `OrderPaymentStatus`: `unpaid`, `paymentReceived`, `paymentConfirmed` |
| **Endpoints (read)** | `user.getMyOrderPayment(orderId)`; payment embedded in `UserOrderDetail.payment` |
| **Endpoints (write)** | `user.completePayment(orderId)` — **DISABLED** (throws `FORBIDDEN`; vendor updates payment) |
| **DB** | `payment_transaction`, `order_status_history` |
| **Gap** | USER_API.md still documents `completePayment` as active; tests may be stale |
| **Gap** | No real eSewa/Khalti gateway — enum stored only |

---

### 3.10 Wishlist

| Item | Detail |
|------|--------|
| **UI screens** | `WishlistScreen`, `BookmarksScreen`, `WishlistStarButton`, `UserWishlistPage` |
| **UI model** | `Product` list (mock) or `WishlistItem` (API) |
| **Endpoints** | `wishlist.listMyWishlist`, `addToWishlist`, `removeFromWishlist`, `toggleWishlist`, `isWishlisted` |
| **Request** | `productId: int` |
| **Response** | `WishlistPage { items: WishlistItem[], total }`; `WishlistItem { productId, product, createdAt }` |
| **DB** | `wishlist_item` |
| **Flutter wiring** | `userWishlistProvider` ✅; routed `wishlistProvider` ❌ mock |
| **Gap** | Star button + bookmarks tab do not call API |

---

### 3.11 Notifications

| Item | Detail |
|------|--------|
| **UI screens** | `ProfileNotificationsScreen` (preference toggles) |
| **UI model** | Local `NotificationPref { title, subtitle, enabled }` |
| **API model** | `NotificationPreference` |
| **Endpoints (prefs)** | `notification.getPreferences`, `notification.updatePreferences` |
| **Request (update)** | Optional bools: `orderUpdates`, `refundStatus`, `arReminders`, `priceDropAlerts`, `vendorMessages`, `promotions` |
| **Endpoints (in-app feed)** | `notification.listInAppNotifications`, `unreadInAppNotificationCount`, `markInAppNotificationRead`, `markAllInAppNotificationsRead` |
| **DB** | `notification_preference`, `in_app_notification` |
| **Flutter wiring** | `profileNotificationsProvider` ✅ built; screen uses mock ❌ |
| **Gap** | No in-app notification list UI on profile; price-drop/promotion flags have no backend jobs |

#### Preference field mapping

| API `NotificationPreference` | UI label (target) |
|------------------------------|-------------------|
| `orderUpdates` | Order updates |
| `refundStatus` | Refund status |
| `arReminders` | AR reminders |
| `priceDropAlerts` | Price drop alerts |
| `vendorMessages` | Vendor messages |
| `promotions` | Promotions |

---

### 3.12 Refunds & returns

| Item | Detail |
|------|--------|
| **UI screens** | `ProfileRefundScreen`, order return sheets on `MyOrdersScreen` |
| **UI model** | `ProfileRefund` (mock) / `RefundRequestSummary` (API) |
| **Endpoints** | `refund.listMyRefundRequests`, `getRefundRequest`, `createRefundRequest(orderId, reason)` |
| **Request** | `orderId: int`, `reason: string` (non-empty) |
| **Response** | `RefundRequestSummary { id, orderId, orderNumber, status, refundAmount, reason, createdAt }` |
| **Status enum** | `RequestStatus`: `pending`, `inProgress`, `completed`, `rejected` |
| **DB** | `refund_request` |
| **Flutter wiring** | `profileRefundsProvider` + `ProfileRefundMapper` ✅; screens use mock ❌ |
| **Return flow** | `ordersProvider.requestReturn` → should call `refund.createRefundRequest` via `ServerpodOrderRepository` |

---

### 3.13 AR history

| Item | Detail |
|------|--------|
| **UI screens** | `ProfileArHistoryScreen`, AR hub |
| **UI model** | `ProfileArSession` (mock) vs `UserArSessionSummary` (API) |
| **Endpoints** | `user.listMyArSessions`, `ar.recordSession`, `ar.listMySessions` |
| **Request (record)** | `productId: int`, `deviceInfo?`, `snapshotUrl?` |
| **Response** | `UserArSessionSummary { id, productId, productName, startedAt, deviceInfo?, snapshotUrl? }` |
| **DB** | `ar_session` |
| **Flutter wiring** | `profileArSessionsProvider` ✅; screen uses mock ❌ |

---

### 3.14 Reviews

| Item | Detail |
|------|--------|
| **UI screens** | "Leave review" on `OrderCard` — **toast "coming soon"** |
| **Endpoints** | `review.submitReview(productId, orderId, rating, comment?)`, `review.listProductReviews` |
| **Request** | `rating` 1–5; order must belong to user |
| **Response** | `Review` |
| **DB** | `review` |
| **Backend status** | ✅ API exists |
| **Gap** | **No consumer review UI** — backend ready before frontend |

---

### 3.15 Settings & password

| Item | Detail |
|------|--------|
| **UI screens** | `ProfileSettingsScreen` (dev vendor toggle), `ProfilePasswordScreen` |
| **Endpoints** | Password: `emailIdp.startPasswordReset` → verify → finish (public flow) |
| **Gap** | No `user.changePassword(old, new)` for logged-in users |
| **Gap** | No consumer settings API (theme, locale, etc.) |

---

### 3.16 Catalog & product detail (user shopping)

| Item | Detail |
|------|--------|
| **UI screens** | Home, browse, category, product detail, shops |
| **Endpoints** | `product.listCategories`, `searchProducts`, `getProduct`, `listApprovedShops`, `getShopProfile` |
| **DB** | `product`, `category`, `vendor` |
| **Flutter** | `catalogIndexProvider` (live) + `MockProductRepository` (browse/category UI) |
| **Gap** | Browse/category still mock; product ids `p1` vs DB `1` need `ProductIdCodec` everywhere |

---

## 4. Enum & naming reference (do not drift)

### Product IDs

| Layer | Format | Example |
|-------|--------|---------|
| UI / mock | `p{int}` | `p4`, `shop-vendor1-p4` |
| API / DB | `int` | `4` |
| Codec | `ProductIdCodec.toDatabaseId` / `fromDatabaseId` | |

### Order status

| API `OrderStatus` | UI `ConsumerOrderStatus` |
|-------------------|--------------------------|
| `pending`, `confirmed` | `placed`, `confirmed` |
| `accepted`, `processing` | `confirmed`, `packed` |
| `shipped` + `DeliveryStage` | `inTransit`, `outForDelivery`, `dispatched` |
| `delivered` | `delivered` |
| `cancelled`, `rejected`, `autoCancelled` | `cancelled` |
| (via refund) | `returnRequested` |

### Payment status

| API `OrderPaymentStatus` | UI `PaymentStatus` |
|--------------------------|---------------------|
| `unpaid` | `pending` |
| `paymentReceived`, `paymentConfirmed` | `paid` |
| (failed transaction) | `failed` |
| (refund completed) | `refunded` |

### Refund status

| API `RequestStatus` | UI `RefundStatus` (mock) |
|---------------------|----------------------------|
| `pending`, `inProgress` | `underReview` |
| `completed` | `refunded` |
| `rejected` | (add UI state) |

---

## 5. Backend gap backlog (prioritized)

| Priority | Feature | Backend work | Blocks |
|----------|---------|--------------|--------|
| P0 | Align docs | Mark `completePayment` disabled; document in-app notifications in USER_API.md | Confusion |
| P1 | — | **No new endpoints** for current routed UI — wiring gap is frontend | Orders, wishlist, refunds |
| P2 | Edit profile UI (when added) | `updateProfile` already exists | Account page |
| P2 | Checkout UI | `checkout` exists; optional `user.getCurrentUser().address` as default | Cart checkout |
| P3 | Profile photo | Add `user.updateProfileImage` + file upload endpoint | Avatar |
| P3 | Address book | New `user_address` table + `list/create/update/deleteDefault` | Multi-address UI |
| P3 | Change password (logged in) | New endpoint or document emailIdp reset flow | Password screen |
| P4 | Customization requests | `customization_request` table exists; add endpoint | Future UI |
| P4 | Payment gateways | Integrate eSewa/Khalti beyond enum storage | Production payments |
| P4 | Price-drop alerts | Background job reading `notification_preference.priceDropAlerts` | Notification pref |

---

## 6. Frontend wiring checklist (for teammate — not backend owner)

When Nisha ships new UI, backend owner verifies this matrix; frontend owner checks:

- [x] `CartScreen` checkout → `checkoutCart()` in `cart_actions.dart` (auto-patched after Nisha port via `wire-cart-checkout.sh`)
- [ ] `orderRepositoryProvider` → `ServerpodOrderRepository`
- [ ] `ProfileStatsStrip` → `profileDashboardProvider`
- [ ] `wishlistProvider` / star button → `userWishlistProvider` + `wishlist.toggleWishlist`
- [ ] `ProfileNotificationsScreen` → `profileNotificationsProvider`
- [ ] `ProfileRefundScreen` → `profileRefundsProvider`
- [ ] `ProfileArHistoryScreen` → `profileArSessionsProvider`
- [x] Product resolution → `catalogIndexProvider` + `ProductIdCodec` (`productById` provider)
- [ ] Register `/user/*` OR consolidate into `/profile/*`

---

## 7. Verification commands

```bash
# Backend integration tests (consumer flows)
cd placeify_server && docker compose up -d && dart test test/integration/

# Regenerate client after spy.yaml changes
cd placeify_server && serverpod generate

# Flutter analyze integration layer
cd placeify_flutter && flutter analyze lib/features/profile lib/features/orders lib/features/cart lib/features/user
```

---

## 8. Change log

| Date | Change |
|------|--------|
| 2026-06-24 | Initial matrix from full codebase audit |
