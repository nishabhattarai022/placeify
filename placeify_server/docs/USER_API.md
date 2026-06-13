# Placeify User Backend API

Consumer-facing Serverpod endpoints used by the user dashboard and profile flows.

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
| `user.listMyArSessions` | Yes | AR try-on history | `List<UserArSessionSummary>` |
| `user.becomeVendor` | Yes | Switch role to vendor (requires shop) | `User` |
| `user.becomeConsumer` | Yes | Switch role back to consumer | `User` |

### `UserDashboard`

| Field | Source |
|-------|--------|
| `profile` | `user` row |
| `orderCount` | Count of `order` for user |
| `wishlistCount` | Count of `wishlist_item` for user |
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
| `cart` | `getCartItems`, `addToCart`, `updateCartItemQuantity`, `removeFromCart` |
| `checkout` | `checkout` — creates `order` + `order_item` rows |
| `product` | `searchProducts`, `getProduct` |
| `notification` | `getPreferences`, `updatePreferences` |

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
