# Backend → Frontend Wiring Guide

**Audience:** Frontend developer wiring Nisha consumer UI to Serverpod.  
**Canonical contract:** [CONSUMER_API_CONTRACT.md](./CONSUMER_API_CONTRACT.md)  
**Verification:** `./scripts/verify-backend-readiness.sh`

---

## Quick start (local)

```bash
cd placeify_server
./scripts/ensure-docker.sh
./scripts/start-server.sh          # applies migrations + starts API
# or fresh DB:
./scripts/reset-dev-database.sh
```

Server: `http://localhost:8080` (API) · static uploads: `http://localhost:8082/uploads/...`

Demo login: `demo@placeify.app` / `demo1234` (register if missing).  
After catalog seed fix, **sign out and back in** if cart showed own-shop errors.

---

## Priority APIs (ready)

### 1. Catalog

| Call | Auth | Returns |
|------|------|---------|
| `product.listCategories()` | Public | 8 categories: `chairs`, `sofas`, `desks`, `beds`, `tables`, `storage`, `lighting`, `outdoor` |
| `product.searchProducts(ProductSearchInput)` | Public | `ProductPage` with `items[]`, `total`, `page`, `pageSize` |
| `product.getProduct(productId)` | Public | `Product?` with nested `vendor`, `category` |

**Each `Product` includes:**

| Field | Type | Notes |
|-------|------|-------|
| `id` | `int` | Map to UI `p{id}` via `ProductIdCodec` |
| `name`, `description`, `price` | | |
| `thumbnailUrl` | `String?` | `/uploads/catalog-seed/...` for demo catalog |
| `viewImageUrls` | `List<String>?` | Extra gallery angles |
| `averageRating` | `double` | `0.0` when no reviews |
| `reviewCount` | `int` | `0` when no reviews |
| `vendor` | `Vendor?` | `shopName`, `id` (use for supplier label) |
| `category` | `Category?` | `name` |

**Image URL resolution:** prefix with web server base, e.g. `http://localhost:8082` + `thumbnailUrl`.

**Room labels:** no backend room API — map UI rooms → category names client-side.

---

### 2. Cart

| Call | Auth | Notes |
|------|------|-------|
| `cart.getCartItems()` | Yes | `CartItem` includes nested `product` (+ vendor) |
| `cart.addToCart(productId, quantity)` | Yes | |
| `cart.updateCartItemQuantity(productId, quantity)` | Yes | |
| `cart.removeFromCart(productId)` | Yes | |

**Policy:** consumers can add any catalog product. **Vendor role** users cannot add products from **their own shop** (`OWN_SHOP_PURCHASE_FORBIDDEN`). Demo catalog is owned by `catalog-vendor@placeify.app`, not the consumer account.

---

### 3. Checkout & orders

| Call | Auth | Notes |
|------|------|-------|
| `checkout.checkout(CheckoutRequest)` | Yes | Clears cart, creates order |
| `user.listMyOrders(limit, offset, status?)` | Yes | `UserOrderSummary` + delivery fields |
| `user.getMyOrder(orderId)` | Yes | Line items, payment, `deliveryUpdates` |
| `user.cancelMyOrder(orderId, reason)` | Yes | |
| `user.getMyOrderPayment(orderId)` | Yes | Read-only payment status |

**CheckoutRequest:**

```dart
CheckoutRequest(
  shippingAddress: 'Kathmandu, Nepal',  // required, non-empty
  paymentMethod: PaymentMethod.cod,     // cod | mockOnline | esewa | khalti
)
```

**Disabled by design:** `user.completePayment` → `FORBIDDEN` (vendor updates payment).

---

### 4. Wishlist

| Call | Auth |
|------|------|
| `wishlist.listMyWishlist()` | Yes |
| `wishlist.addToWishlist(productId)` | Yes |
| `wishlist.removeFromWishlist(productId)` | Yes |
| `wishlist.toggleWishlist(productId)` | Yes |
| `wishlist.isWishlisted(productId)` | Yes |

`WishlistPage.items[].product` includes full `Product` (images, ratings, vendor).

---

### 5. Profile & auth

| Call | Auth |
|------|------|
| `emailIdp.login` / `register` / `jwtRefresh` | Public |
| `user.getCurrentUser()` | Yes |
| `user.updateProfile(name, phone?, address?)` | Yes |
| `user.uploadProfileImage(fileData, fileName)` | Yes → `profileImageUrl` |
| `user.getDashboard()` | Yes → order/wishlist/cart/refund/AR counts |

---

### 6. Ratings

- **List/search:** use `product.averageRating` + `product.reviewCount` (no per-card `review.listProductReviews` calls).
- **Detail page:** `review.listProductReviews(productId)` + `review.submitReview(productId, orderId, rating, comment?)`.

---

### 7. Shops / suppliers

| Call | Auth | Use |
|------|------|-----|
| `product.listApprovedShops({query?})` | Public | Home suppliers marquee, shops browse |
| `product.getShopProfile(vendorId)` | Public | Shop detail page |

**`ShopListingSummary`:** `vendorId`, `businessName`, `locality`, `tags`, `logoUrl`, `bannerUrl`, `productCount`, `averageRating`.

**Product detail supplier:** use `product.vendor` from `getProduct` / search (no extra call required).

---

### 8. Optional consumer APIs (backend ready)

| Module | Calls |
|--------|-------|
| `review` | `submitReview`, `listProductReviews` |
| `customization` | `createRequest`, `listMyRequests` |
| `refund` | `createRefundRequest`, `listMyRefundRequests` |
| `notification` | `getPreferences`, `updatePreferences`, `listInAppNotifications` |
| `ar` | `recordSession`, `user.listMyArSessions` |

---

## Error codes (stable)

| Code | When |
|------|------|
| `AUTH_REQUIRED` / unauthenticated | Missing JWT on protected endpoints |
| `CART_EMPTY` | Checkout with empty server cart |
| `OWN_SHOP_PURCHASE_FORBIDDEN` | Vendor adds own product |
| `OWN_SHOP_ORDER_FORBIDDEN` | Vendor checks out own product |
| `PRODUCT_NOT_FOUND` | Invalid/inactive product id |
| `INVALID_ADDRESS` | Empty shipping address |
| `FORBIDDEN` | `user.completePayment` |

---

## Frontend wiring checklist (not backend)

- [ ] Replace `MockProductRepository` / synthetic `ProductReviewsRepository` with live `product.*` + `product.averageRating`
- [ ] Resolve image URLs: `http://localhost:8082` + `thumbnailUrl` (or env-based base)
- [ ] Wire `product.listApprovedShops` for suppliers section
- [ ] Wire `VendorPurchasePolicy` using `user.role == vendor` (already fixed server-side)
- [ ] Room chips → `product.searchProducts(categoryName: 'chairs'|...)` 
- [ ] Profile photo upload UI → `user.uploadProfileImage`
- [ ] Do **not** call `user.completePayment`

---

## Test commands

```bash
cd placeify_server
./scripts/verify-backend-readiness.sh

# Individual suites
dart test test/integration/consumer_backend_readiness_test.dart
dart test test/integration/catalog_seed_contract_test.dart
dart test test/integration/vendor_own_shop_cart_test.dart
```

---

## Production / later (not blocking UI wiring)

- Real eSewa/Khalti payment gateways
- Multiple saved addresses (`user_address` book)
- Price-drop / promo notification background jobs
- Backend room taxonomy API
