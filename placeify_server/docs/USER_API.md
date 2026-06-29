# Placeify User Backend API

Consumer-facing Serverpod endpoints used by the user dashboard and profile flows.

**Canonical contract (source of truth):** [CONSUMER_API_CONTRACT.md](./CONSUMER_API_CONTRACT.md)  
**Screen mapping:** [USER_FRONTEND_BACKEND_MATRIX.md](./USER_FRONTEND_BACKEND_MATRIX.md)

**Base URL (local):** `http://localhost:8080`  
**Auth:** All endpoints below require a valid JWT unless marked public. Send the access token via Serverpod client auth (`client.auth`).

---

## Authentication (public)

| Endpoint | Description |
|----------|-------------|
| `emailIdp.startRegistration` | Start email signup; sends verification code |
| `emailIdp.verifyRegistrationCode` | Verify email with code |
| `emailIdp.finishRegistration` | Set password and create auth account |
| `emailIdp.login` | Sign in with email + password |
| `emailIdp.startPasswordReset` | Start password reset flow |
| `emailIdp.verifyPasswordResetCode` | Verify reset code |
| `emailIdp.finishPasswordReset` | Set new password |
| `jwtRefresh.refreshAccessToken` | Issue new access token from refresh token |

See [PRODUCTION_AUTH.md](../PRODUCTION_AUTH.md) for deployment and secrets.

---

## User profile & dashboard

Module: `user` endpoint · Tables: `user`, `order`, `wishlist_item`, `ar_session`, `refund_request`

| Endpoint | Auth | Description | Response |
|----------|------|-------------|----------|
| `user.getCurrentUser` | Yes | Load Placeify profile for signed-in auth user | `User?` |
| `user.updateProfile` | Yes | Update name, phone, address | `User` |
| `user.getDashboard` | Yes | Aggregated dashboard metrics | `UserDashboard` |
| `user.listMyOrders` | Yes | Paginated order history | `List<UserOrderSummary>` |
| `user.getMyOrder` | Yes | Order detail with items and delivery timeline | `UserOrderDetail` |
| `user.cancelMyOrder` | Yes | Cancel a pending/confirmed order (`orderId`, `reason`) | `UserOrderDetail` |
| `user.getMyOrderPayment` | Yes | Payment status for an order | `UserOrderPaymentSummary` |
| `user.completePayment` | Yes | **Disabled in production flow** — throws `FORBIDDEN`; vendor updates payment after checkout. See [USER_FRONTEND_BACKEND_MATRIX.md](./USER_FRONTEND_BACKEND_MATRIX.md). | — |
| `user.listMyArSessions` | Yes | AR try-on history | `List<UserArSessionSummary>` |
| `user.becomeVendor` | Yes | Switch role to vendor (requires shop) | `User` |
| `user.becomeConsumer` | Yes | Switch role back to consumer | `User` |

### `UserDashboard`

| Field | Source |
|-------|--------|
| `profile` | `user` row |
| `orderCount` | Count of non-cancelled `order` rows for user (excludes `cancelled`, `autoCancelled`, `rejected`) |
| `wishlistCount` | Count of `wishlist_item` for user |
| `cartItemCount` | Total quantity of items in the user's cart |
| `arSessionCount` | Count of `ar_session` for user |
| `refundCount` | Count of `refund_request` for user |

### `UserOrderSummary`

| Field | Description |
|-------|-------------|
| `id` | Order id |
| `orderNumber` | Zero-padded order id string |
| `status` | `pending`, `confirmed`, `shipped`, `delivered`, `cancelled` |
| `totalAmount` | Order total (NPR) |
| `placedAt` | Order timestamp |
| `itemCount` | Total quantity across line items |
| `primaryProductName` | First product name (with quantity suffix) |

**Optional params for `listMyOrders`:** `limit`, `offset`, `status`

---

## Wishlist

Module: `wishlist` endpoint · Table: `wishlist_item`

| Endpoint | Auth | Description |
|----------|------|-------------|
| `wishlist.listMyWishlist` | Yes | Saved products with `Product` + `Vendor` included |
| `wishlist.addToWishlist` | Yes | Save product by id |
| `wishlist.removeFromWishlist` | Yes | Remove saved product |
| `wishlist.toggleWishlist` | Yes | Add if missing, remove if present |
| `wishlist.isWishlisted` | Yes | Check if product is saved |

---

## Refunds & returns

Module: `refund` endpoint · Table: `refund_request`

| Endpoint | Auth | Description |
|----------|------|-------------|
| `refund.listMyRefundRequests` | Yes | List refund requests for signed-in user |
| `refund.getRefundRequest` | Yes | Get one refund by id (must belong to user) |
| `refund.createRefundRequest` | Yes | Open refund for an order (`orderId`, `reason`) |

### Business rules

- Order must belong to the authenticated user
- Cancelled orders cannot be refunded
- Only one **pending** refund per order
- `refundAmount` defaults to the order `totalAmount`
- Status uses `RequestStatus`: `pending`, `inProgress`, `completed`, `rejected`

---

## Related commerce APIs (used by user flows)

| Module | Key endpoints |
|--------|----------------|
| `cart` | `getCartItems`, `addToCart`, `updateCartItemQuantity`, `removeFromCart`, `clearCart` |
| `checkout` | `checkout` — creates `order` + `order_item` rows, clears cart, records `paymentMethod`, notifies vendors |
| `product` | `searchProducts`, `getProduct` |
| `notification` | `getPreferences`, `updatePreferences`, `listInAppNotifications`, `unreadInAppNotificationCount`, `markInAppNotificationRead`, `markAllInAppNotificationsRead` |

> **Frontend ↔ backend mapping:** See [USER_FRONTEND_BACKEND_MATRIX.md](./USER_FRONTEND_BACKEND_MATRIX.md) for per-screen endpoints, payload shapes, enum mappings, and wiring status.

### Cart & checkout rules

- User must be **signed in** (`requireLogin` on `cart` and `checkout`).
- A Placeify `user` profile is **auto-created** on first cart/checkout call if missing.
- `checkout` reads the **server cart** only — items added only in the UI without `cart.addToCart` will not checkout.
- Demo catalog products are seeded on first `product.searchProducts` when the database is empty.

### Checkout troubleshooting

| Error code | Meaning | Fix |
|------------|---------|-----|
| `AUTH_REQUIRED` | No valid JWT | Sign in first |
| `CART_EMPTY` | Server cart has no rows | Sign in, call `cart.addToCart`, then `checkout` |
| `PRODUCT_NOT_FOUND` | Invalid or inactive product id | Use ids from `product.searchProducts` |
| `INVALID_ADDRESS` | Empty shipping address | Pass non-empty `CheckoutRequest.shippingAddress` |

### Start the backend (local)

```bash
cd placeify_server
./scripts/start-server.sh
```

Or manually:

```bash
docker compose up -d
dart bin/main.dart --apply-migrations
```

Server API: `http://localhost:8080` · Web: `http://localhost:8082`

---

## Integration tests

Run from `placeify_server` with Docker Postgres up:

```bash
docker compose up -d
dart test
```

| Test file | Coverage |
|-----------|----------|
| `test/integration/email_auth_endpoint_test.dart` | Register, login, JWT refresh |
| `test/integration/user_endpoint_test.dart` | Profile + auth guard |
| `test/integration/user_dashboard_endpoint_test.dart` | `getDashboard`, `listMyOrders` |
| `test/integration/wishlist_endpoint_test.dart` | Wishlist list + toggle |
| `test/integration/refund_endpoint_test.dart` | Refund create + list + dashboard count |
| `test/integration/checkout_flow_endpoint_test.dart` | Cart add → checkout → order list + dashboard |
| `test/integration/user_payment_flow_test.dart` | Checkout payment pending → vendor payment update (consumer `completePayment` is disabled) |
| `test/integration/vendor_starter_catalog_test.dart` | Approved vendor gets starter catalog → checkout visible on dashboard |

---

## Architecture

```
Client (placeify_client)
    → Endpoint (user / wishlist / refund)
    → Service
    → Repository / Store
    → PostgreSQL
```

Protected endpoints extend `PlaceifyAuthenticatedEndpoint` or set `requireLogin => true`.
