# Consumer UI audit — Live / Mock / Hybrid

**Date:** 2026-06-23  
**Scope:** Mobile bottom-nav consumer flows + `/user/*` desktop dashboard  
**Legend:** **Live** = Serverpod API · **Mock** = local/demo data only · **Hybrid** = mix of both

---

## Critical finding: duplicate orders flows

| Screen | Route | Data source | Tag |
|--------|-------|-------------|-----|
| `MyOrdersScreen` | `/profile/orders` (**routed**) | `ordersProvider` → `MockOrderRepository` (12 demo orders) | **Mock** |
| `ProfileOrdersScreen` | *(not routed — dead code)* | `profileOrdersProvider` → `user.listMyOrders` | Live |
| `UserOrdersPage` | `/user/orders` | `profileOrdersProvider` | **Live** |

**Checkout regression:** `CartScreen` and `UserCartPage` invalidate `profileOrdersProvider` on success, but mobile navigates to `/profile/orders` → **mock list**. Real orders never appear after checkout on mobile.

**Order detail / tracking** (`OrderDetailScreen`, `OrderTrackingScreen`) use `orderByIdProvider` → **mock only**. No link from `UserOrderCard` to detail yet.

---

## Cart → checkout → view order (priority path)

| Step | Screen / action | Tag | Notes |
|------|-----------------|-----|-------|
| 1 | `CartScreen` (`/cart`) | **Live** | `ServerpodCartRepository`, `catalogIndexProvider` for line images |
| 2 | Payment picker (`CartOrderSummary`) | **Hybrid** | UI: COD + mock card only; backend enum also has eSewa/Khalti |
| 3 | `cartProvider.checkout()` | **Live** | `client.checkout`, passes `paymentMethod` |
| 4 | Post-checkout nav | **Broken** | Mobile → `/profile/orders` (mock); desktop stays on cart tab |
| 5 | Order list | **Mock** (mobile) / **Live** (desktop `/user/orders`) | Split brain |
| 6 | Order detail | **Mock** | Rich UI (timeline, payment chip) but seeded data |
| 7 | Order tracking | **Mock** | `statusHistory`, tracking number from mock seeds |

---

## Profile home tiles & counts

| UI element | File | Tag | Backend available |
|------------|------|-----|-------------------|
| Avatar / name / email | `ProfileHero` → `currentUserProvider` | **Live** | `user.getCurrentUser` |
| Stats strip (orders, wishlist, AR, refunds) | `ProfileStatsStrip` | **Mock** | `user.getDashboard` has real counts |
| Orders menu tile + badge | `ProfileOrdersTile` | **Mock** | Uses `ordersCountProvider` / `inTransitOrderCountProvider` (mock) |
| Wishlist menu → `/bookmarks` | `ProfileHomeScreen` | **Mock** | `wishlist.listMyWishlist` exists |
| Refunds menu | routes to `ProfileRefundScreen` | **Mock** | `profileRefundsProvider` + `refund.*` exist, unused by screen |
| Notifications menu | `ProfileNotificationsScreen` | **Mock** | `profileNotificationsProvider` (prefs) exists; in-app list API exists (`notification.listInAppNotifications`) but no Flutter repo |

---

## Orders (post-checkout detail)

| Screen | Route | Tag | Notes |
|--------|-------|-----|-------|
| `MyOrdersScreen` | `/profile/orders` | **Mock** | Filters, search, quick actions — best mobile UX |
| `OrderDetailScreen` | `/profile/orders/:orderId` | **Mock** | Payment status chip, timeline, cancel/return → mock repo |
| `OrderTrackingScreen` | `.../tracking` | **Mock** | Timeline from `order.statusHistory` (mock) |
| `UserOrdersPage` | `/user/orders` | **Live** | Simpler cards, delivery progress from API fields |
| Cancel / return sheets | `order_reason_sheets.dart` | **Mock** | Calls `ordersProvider` mock methods |
| Quick actions (reorder, review) | `order_quick_actions_sheet.dart` | **Hybrid** | Reorder → live cart; review/support = "coming soon" |

**Backend (Rosika):** `deliveryStatus`, `paymentStatus`, `order_status_history` — not mapped into mobile `Order` model yet.

---

## Wishlist

| Screen | Route | Tag | Notes |
|--------|-------|-----|-------|
| `BookmarksScreen` / `WishlistScreen` | `/bookmarks`, `/profile/wishlist` | **Mock** | `wishlistProvider` = hardcoded product ids + `MockProductRepository` lookup |
| `WishlistGridView` | shared widget | **Mock** | Toggle calls local `wishlistProvider`, not API |
| Product detail heart | `product_detail_header.dart` | **Mock** | Same local provider |
| `UserWishlistPage` | `/user/wishlist` | **Live** | `userWishlistProvider` → `wishlist.listMyWishlist` |

---

## Profile & account screens

| Screen | Route | Tag | Notes |
|--------|-------|-----|-------|
| `ProfileHomeScreen` | `/profile` | **Hybrid** | Live auth user; mock stats |
| `ProfileSettingsScreen` | `/profile/settings` | **Hybrid** | Live user; debug vendor toggle only |
| `ProfilePasswordScreen` | `/profile/password` | **Mock** | Local form, no API call |
| `ProfileRefundScreen` | `/profile/refund` | **Mock** | `ProfileMockData`; provider ready |
| `ProfileNotificationsScreen` | `/profile/notifications` | **Mock** | `ProfileMockData` toggles; `profileNotificationsProvider` unused |
| `ProfileArHistoryScreen` | `/profile/ar-history` | **Mock** | `ProfileMockData`; `ProfileArSessions` provider exists (live) |
| `ProfileWishlistScreen` | `/profile/wishlist` | **Mock** | Wraps `WishlistScreen` |

---

## Browse & discovery

| Screen | Route | Tag | Notes |
|--------|-------|-----|-------|
| `HomeScreen` | `/home` | **Hybrid** | Static/marketing sections + room recommendations |
| Home recommendations | `home_recommend_section` | **Mock** | `HomeCategoriesConfig` + `MockProductRepository` |
| Home discounted promo | `discounted_products_section` | **Mock** | Static `discounted_products.dart` |
| Home showcase video | `home_showcase_section` | **Mock** | Local video asset |
| `BrowseScreen` | `/browse` | **Mock** | Static `furniture_categories.dart` layout |
| `CategoryScreen` | `/browse/category/:id` | **Mock** | `MockProductRepository` only |
| `category_provider` + `ProductGrid` | *(not routed)* | **Live** | API catalog — unused in main nav |
| `ProductDetailScreen` | `/product/:id` | **Hybrid** | `resolvedProductProvider` / catalog API; wishlist mock |
| `ShopsScreen` | `/shops` | **Live** | `consumerShopsProvider` |
| `VendorShopScreen` | `/shops/:vendorId` | **Live** | `shopProductsProvider` |

---

## Auth

| Screen | Route | Tag |
|--------|-------|-----|
| `SplashScreen` | `/splash` | **Mock** (routing only) |
| `LoginScreen` | `/login` | **Live** (`ServerpodAuthRepository`) |
| `RegisterScreen` | `/register` | **Live** |

---

## Desktop user dashboard (`/user/*`)

| Screen | Route | Tag | Notes |
|--------|-------|-----|-------|
| `UserDashboardScreen` | `/user/dashboard` | **Live** | `getDashboard` + pending order count |
| `UserOrdersPage` | `/user/orders` | **Live** | |
| `UserCartPage` | `/user/cart` | **Live** | Same `cartProvider` as mobile |
| `UserWishlistPage` | `/user/wishlist` | **Live** | |
| `UserRefundPage` | `/user/refund` | **Mock** | Placeholder |
| `UserNotificationsPage` | `/user/notifications` | **Mock** | Placeholder |
| `UserAccountPage` | `/user/account` | **Mock** | Placeholder |
| `UserSettingsPage` | `/user/settings` | **Mock** | Placeholder |
| `UserTryMePage` | `/user/try-me` | **Mock** | Placeholder |

---

## Wiring checklist (priority order)

### P0 — Broken user journey (do first)

- [ ] **Unify orders on API** — Replace `MockOrderRepository` in `orders_provider.dart` with Serverpod mapper (`UserOrderSummary` / `UserOrderDetail` → `Order`). Keep `MyOrdersScreen` UI; swap data layer only.
- [ ] **Fix post-checkout navigation** — After checkout, invalidate `ordersProvider` (API) not only `profileOrdersProvider`; ensure new order visible on `/profile/orders`.
- [ ] **Wire order detail + tracking** — `orderByIdProvider` → `user.getMyOrder`; map `order_status_history`, `paymentStatus`, `deliveryStatus`.
- [ ] **Profile orders tile counts** — `ProfileOrdersTile` → `profileDashboardProvider` or live order providers, not `ordersCountProvider` (mock).

### P1 — Profile tiles & duplicates

- [ ] **Profile stats strip** — `ProfileStatsStrip` → `user.getDashboard` counts.
- [ ] **Remove or route `ProfileOrdersScreen`** — Avoid two order list implementations; either delete or redirect router to one screen.
- [ ] **Profile refunds screen** — Wire `ProfileRefundScreen` to `profileRefundsProvider` (API repo already exists).
- [ ] **Profile notifications prefs** — Wire `ProfileNotificationsScreen` to `profileNotificationsProvider`.

### P2 — Wishlist

- [ ] **Mobile wishlist** — Replace `wishlistProvider` with API-backed provider (mirror `user_wishlist_provider.dart`); resolve products via `catalogIndexProvider`.
- [ ] **Product detail heart** — Call `wishlist.toggleWishlist` when signed in; local fallback when guest.

### P3 — Notifications & AR

- [ ] **In-app notification list** — Add Flutter repo for `notification.listInAppNotifications`; new list UI or extend profile notifications screen.
- [ ] **Profile AR history** — Wire `ProfileArHistoryScreen` to `ProfileArSessions` provider.

### P4 — Browse consistency (lower urgency)

- [ ] **`CategoryScreen`** — Switch from `MockProductRepository` to `catalogProductsByCategoryProvider`.
- [ ] **Home recommendations** — Optional: blend API catalog with room filters when enough products exist.

### P5 — Payments & polish

- [ ] **eSewa / Khalti** — Add to `CartOrderSummary` when gateway endpoints exist.
- [ ] **Remove `completePayment` client calls** — Vendor-driven payment model (backend returns `FORBIDDEN`).
- [ ] **Desktop placeholders** — `/user/refund`, `/user/notifications`, `/user/account` → reuse wired mobile screens or shared widgets.

### P6 — Do not touch blindly (preserve Nisha/Rosika UI)

- `MyOrdersScreen`, `OrderDetailScreen`, `OrderTrackingScreen` — **layout/widgets OK**; only change providers/mappers.
- `CartScreen`, `CartOrderSummary` — checkout wiring is live; extend payment options carefully.
- `HomeScreen` marketing sections — mock content is intentional for demo richness.
- `BrowseScreen` bento layout — static categories fine until catalog categories match backend.

---

## Files to preserve during wiring

| Keep UI | Change data layer |
|---------|-------------------|
| `my_orders_screen.dart` | `orders_provider.dart` |
| `order_detail_screen.dart`, `order_tracking_screen.dart` | `orderByIdProvider` + new `serverpod_order_repository.dart` |
| `profile_orders_tile.dart`, `profile_stats_strip.dart` | Point at `profileDashboardProvider` / API orders |
| `wishlist_screen.dart`, `wishlist_grid_view.dart` | `wishlist_provider.dart` or new API provider |
| `profile_refund_screen.dart` | Use `profileRefundsProvider` |
| `profile_notifications_screen.dart` | Use `profileNotificationsProvider` + optional in-app list |

---

## Backend endpoints ready but not fully used in mobile UI

| Endpoint | Mobile consumer usage |
|----------|----------------------|
| `user.listMyOrders` / `getMyOrder` | Desktop only |
| `user.cancelMyOrder` | Mock cancel on mobile |
| `user.getMyOrderPayment` | Not wired |
| `wishlist.*` | Desktop only |
| `refund.*` | Provider only; screen mock |
| `notification.getPreferences` / `updatePreferences` | Provider only; screen mock |
| `notification.listInAppNotifications` | Not wired in Flutter |
| `checkout` | Live |
| `cart.*` | Live |
