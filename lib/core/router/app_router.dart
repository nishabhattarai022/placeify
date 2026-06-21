import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify/features/admin/domain/constants/admin_routes.dart';
import 'package:placeify/features/admin/presentation/dashboard/admin_dashboard_screen.dart';
import 'package:placeify/features/admin/presentation/guards/admin_auth_guard.dart';
import 'package:placeify/features/admin/presentation/notifications/admin_notifications_screen.dart';
import 'package:placeify/features/admin/presentation/settings/admin_audit_log_screen.dart';
import 'package:placeify/features/admin/presentation/settings/admin_settings_screen.dart';
import 'package:placeify/features/admin/presentation/shell/admin_shell.dart';
import 'package:placeify/features/admin/presentation/users/admin_user_detail_screen.dart';
import 'package:placeify/features/admin/presentation/users/admin_users_screen.dart';
import 'package:placeify/features/admin/presentation/vendor_approvals/vendor_application_detail_screen.dart';
import 'package:placeify/features/admin/presentation/vendor_approvals/vendor_applications_screen.dart';
import 'package:placeify/features/admin/presentation/vendors/admin_vendor_detail_screen.dart';
import 'package:placeify/features/admin/presentation/vendors/admin_vendors_screen.dart';
import 'package:placeify/features/admin/presentation/widgets/admin_tab_scaffold.dart';
import 'package:placeify/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify/core/widgets/toast_overlay.dart';
import 'package:placeify/features/vendor/presentation/guards/vendor_auth_guard.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../constants/app_durations.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/vendor/presentation/registration/vendor_registration_screen.dart';
import '../../features/vendor/presentation/registration/vendor_registration_success_screen.dart';
import '../../features/vendor/presentation/delivery_update_screen.dart';
import '../../features/vendor/presentation/vendor_analytics_screen.dart';
import '../../features/vendor/presentation/vendor_dashboard_screen.dart';
import '../../features/vendor/presentation/vendor_notifications_screen.dart';
import '../../features/vendor/presentation/vendor_order_detail_screen.dart';
import '../../features/vendor/presentation/vendor_reviews_screen.dart';
import '../../features/vendor/presentation/vendor_orders_screen.dart';
import '../../features/vendor/presentation/vendor_product_form_screen.dart';
import '../../features/vendor/presentation/vendor_products_screen.dart';
import '../../features/vendor/presentation/vendor_payments_screen.dart';
import '../../features/vendor/presentation/profile/vendor_profile_screen.dart';
import '../../features/vendor/presentation/vendor_settings_screen.dart';
import '../../features/vendor/presentation/vendor_shell.dart';
import '../../features/vendor/presentation/widgets/vendor_tab_scaffold.dart';
import '../../features/vendor/domain/constants/vendor_routes.dart';
import 'package:placeify/features/shops/domain/constants/shop_routes.dart';
import 'package:placeify/features/shops/presentation/shops_screen.dart';
import 'package:placeify/features/shops/presentation/vendor_shop_screen.dart';
import '../../features/home/presentation/bookmarks_screen.dart';
import '../../data/furniture_categories.dart';
import '../../screens/browse_screen.dart';
import '../../screens/category_screen.dart';
import '../../features/ar_hub/presentation/ar_powered_screen.dart';
import '../../features/profile/presentation/profile_ar_history_screen.dart';
import '../../features/profile/presentation/profile_home_screen.dart';
import '../../features/profile/presentation/profile_notifications_screen.dart';
import '../../features/orders/presentation/my_orders_screen.dart';
import '../../features/orders/presentation/order_detail_screen.dart';
import '../../features/orders/presentation/order_tracking_screen.dart';
import '../../features/profile/presentation/profile_password_screen.dart';
import '../../features/profile/presentation/profile_refund_screen.dart';
import '../../features/profile/presentation/profile_settings_screen.dart';
import '../../features/profile/presentation/profile_wishlist_screen.dart';
import '../../features/product_detail/presentation/product_detail_screen.dart';
import '../../features/cart/presentation/cart_screen.dart';
import 'main_shell.dart';

part 'app_router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();
final vendorDashboardNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'vendorDashboard');
final vendorOrdersNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'vendorOrders');
final vendorProductsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'vendorProducts');
final vendorPaymentsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'vendorPayments');
final vendorProfileNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'vendorProfile');
final adminDashboardNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'adminDashboard');
final adminApplicationsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'adminApplications');
final adminVendorsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'adminVendors');
final adminSettingsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'adminSettings');

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // Re-evaluate redirects on auth changes without recreating GoRouter — recreating
  // the router resets navigation to initialLocation and breaks login.
  final refreshListenable = ValueNotifier<int>(0);
  ref.onDispose(refreshListenable.dispose);
  ref.listen(currentUserProvider, (_, __) {
    refreshListenable.value++;
  });

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final userAsync = ref.read(currentUserProvider);
      if (userAsync.isLoading) return null;

      final adminRedirect = AdminAuthGuard.evaluate(
        location: state.matchedLocation,
        user: userAsync.value,
      );
      if (adminRedirect != null) return adminRedirect;

      final redirect = VendorAuthGuard.evaluate(
        location: state.matchedLocation,
        user: userAsync.value,
      );
      if (redirect?.toastMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final ctx = rootNavigatorKey.currentContext;
          if (ctx != null) {
            PlaceifyToast.show(ctx, redirect!.toastMessage!);
          }
        });
      }
      return redirect?.location;
    },
    routes: _appRoutes,
  );
}

List<RouteBase> get _appRoutes => [
    GoRoute(
      path: '/splash',
      name: 'splash',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SplashScreen(),
        transitionsBuilder: _fadeTransition,
        transitionDuration: AppDurations.slow,
      ),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const RegisterScreen(),
        transitionsBuilder: _fadeTransition,
        transitionDuration: AppDurations.slow,
      ),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LoginScreen(),
        transitionsBuilder: _fadeTransition,
        transitionDuration: AppDurations.slow,
      ),
    ),
    GoRoute(
      path: '/vendor/register',
      name: 'vendorRegister',
      pageBuilder: (context, state) => _slidePage(
        key: ValueKey<String>(state.uri.toString()),
        child: const VendorRegistrationScreen(),
      ),
    ),
    GoRoute(
      path: '/vendor/register/success',
      name: 'vendorRegisterSuccess',
      pageBuilder: (context, state) => _slidePage(
        key: ValueKey<String>(state.uri.toString()),
        child: const VendorRegistrationSuccessScreen(),
      ),
    ),
    GoRoute(
      path: VendorRoutes.notifications,
      name: 'vendorNotifications',
      pageBuilder: (context, state) => _slidePage(
        key: ValueKey<String>(state.uri.toString()),
        child: const VendorNotificationsScreen(),
      ),
    ),
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const HomeScreen(),
            transitionsBuilder: _fadeTransition,
            transitionDuration: AppDurations.slow,
          ),
        ),
        GoRoute(
          path: ShopRoutes.shops,
          name: 'shops',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const ShopsScreen(),
            transitionsBuilder: _fadeTransition,
            transitionDuration: AppDurations.slow,
          ),
          routes: [
            GoRoute(
              path: ':vendorId',
              name: 'shopDetail',
              pageBuilder: (context, state) {
                final vendorId = state.pathParameters['vendorId']!;
                return _slidePage(
                  key: ValueKey<String>('shop-$vendorId'),
                  child: VendorShopScreen(vendorId: vendorId),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/browse',
          name: 'browse',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const BrowseScreen(),
            transitionsBuilder: _fadeTransition,
            transitionDuration: AppDurations.slow,
          ),
          routes: [
            GoRoute(
              path: 'category/:categoryId',
              name: 'browseCategory',
              pageBuilder: (context, state) {
                final categoryId = state.pathParameters['categoryId']!;
                final category = furnitureCategoryById(categoryId);
                if (category == null) {
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: const BrowseScreen(),
                    transitionsBuilder: _fadeTransition,
                    transitionDuration: AppDurations.slow,
                  );
                }
                return _slidePage(
                  key: ValueKey<String>('browse-category-$categoryId'),
                  child: CategoryScreen(category: category),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/browse/chairs',
          redirect: (_, __) => '/browse',
        ),
        GoRoute(
          path: '/bookmarks',
          name: 'bookmarks',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const BookmarksScreen(),
            transitionsBuilder: _fadeTransition,
            transitionDuration: AppDurations.slow,
          ),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const ProfileHomeScreen(),
            transitionsBuilder: _fadeTransition,
            transitionDuration: AppDurations.slow,
          ),
        ),
        GoRoute(
          path: '/profile/orders',
          name: 'profileOrders',
          pageBuilder: (context, state) => _slidePage(
            key: ValueKey<String>(state.uri.toString()),
            child: const MyOrdersScreen(),
          ),
          routes: [
            GoRoute(
              path: ':orderId',
              name: 'profileOrderDetail',
              pageBuilder: (context, state) {
                final orderId = state.pathParameters['orderId']!;
                return _slidePage(
                  key: ValueKey<String>('order-detail-$orderId'),
                  child: OrderDetailScreen(orderId: orderId),
                );
              },
              routes: [
                GoRoute(
                  path: 'tracking',
                  name: 'profileOrderTracking',
                  pageBuilder: (context, state) {
                    final orderId = state.pathParameters['orderId']!;
                    return _slidePage(
                      key: ValueKey<String>('order-tracking-$orderId'),
                      child: OrderTrackingScreen(orderId: orderId),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/profile/wishlist',
          name: 'profileWishlist',
          pageBuilder: (context, state) => _slidePage(
            key: ValueKey<String>(state.uri.toString()),
            child: const ProfileWishlistScreen(),
          ),
        ),
        GoRoute(
          path: '/profile/augmented-reality',
          name: 'profileAugmentedReality',
          pageBuilder: (context, state) => _slidePage(
            key: ValueKey<String>(state.uri.toString()),
            child: const ArPoweredScreen(),
          ),
        ),
        GoRoute(
          path: '/profile/ar-history',
          name: 'profileArHistory',
          pageBuilder: (context, state) => _slidePage(
            key: ValueKey<String>(state.uri.toString()),
            child: const ProfileArHistoryScreen(),
          ),
        ),
        GoRoute(
          path: '/profile/refund',
          name: 'profileRefund',
          pageBuilder: (context, state) => _slidePage(
            key: ValueKey<String>(state.uri.toString()),
            child: const ProfileRefundScreen(),
          ),
        ),
        GoRoute(
          path: '/profile/notifications',
          name: 'profileNotifications',
          pageBuilder: (context, state) => _slidePage(
            key: ValueKey<String>(state.uri.toString()),
            child: const ProfileNotificationsScreen(),
          ),
        ),
        GoRoute(
          path: '/profile/password',
          name: 'profilePassword',
          pageBuilder: (context, state) => _slidePage(
            key: ValueKey<String>(state.uri.toString()),
            child: const ProfilePasswordScreen(),
          ),
        ),
        GoRoute(
          path: '/profile/settings',
          name: 'profileSettings',
          pageBuilder: (context, state) => _slidePage(
            key: ValueKey<String>(state.uri.toString()),
            child: const ProfileSettingsScreen(),
          ),
        ),
        GoRoute(
          path: '/cart',
          name: 'cart',
          pageBuilder: (context, state) => _slideUpPage(
            key: ValueKey<String>(state.uri.toString()),
            child: const CartScreen(),
          ),
        ),
        GoRoute(
          path: '/product/:productId',
          name: 'productDetail',
          pageBuilder: (context, state) {
            final productId = state.pathParameters['productId']!;
            return _slidePage(
              key: ValueKey<String>('product-$productId'),
              child: ProductDetailScreen(productId: productId),
            );
          },
        ),
        GoRoute(
          path: '/category/:categoryId',
          redirect: (context, state) {
            final categoryId = state.pathParameters['categoryId']!;
            return '/browse/category/$categoryId';
          },
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              AdminShell(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              navigatorKey: adminDashboardNavigatorKey,
              routes: [
                GoRoute(
                  path: AdminRoutes.dashboard,
                  name: 'admin',
                  pageBuilder: (context, state) => _adminTabPage(
                    state: state,
                    child: const AdminDashboardScreen(),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: adminApplicationsNavigatorKey,
              routes: [
                GoRoute(
                  path: AdminRoutes.approvals,
                  name: 'adminApprovals',
                  pageBuilder: (context, state) => _adminTabPage(
                    state: state,
                    child: const VendorApplicationsScreen(),
                  ),
                  routes: [
                    GoRoute(
                      path: ':applicationId',
                      name: 'adminApplicationDetail',
                      pageBuilder: (context, state) => _slidePage(
                        key: ValueKey<String>(state.uri.toString()),
                        child: VendorApplicationDetailScreen(
                          applicationId:
                              state.pathParameters['applicationId']!,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: adminVendorsNavigatorKey,
              routes: [
                GoRoute(
                  path: AdminRoutes.vendors,
                  name: 'adminVendors',
                  pageBuilder: (context, state) => _adminTabPage(
                    state: state,
                    child: const AdminVendorsScreen(),
                  ),
                  routes: [
                    GoRoute(
                      path: ':vendorId',
                      name: 'adminVendorDetail',
                      pageBuilder: (context, state) => _slidePage(
                        key: ValueKey<String>(state.uri.toString()),
                        child: AdminVendorDetailScreen(
                          vendorId: state.pathParameters['vendorId']!,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: adminSettingsNavigatorKey,
              routes: [
                GoRoute(
                  path: AdminRoutes.settings,
                  name: 'adminSettings',
                  pageBuilder: (context, state) => _adminTabPage(
                    state: state,
                    child: const AdminSettingsScreen(),
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AdminRoutes.users,
          name: 'adminUsers',
          pageBuilder: (context, state) => _slidePage(
            key: ValueKey<String>(state.uri.toString()),
            child: const AdminUsersScreen(),
          ),
          routes: [
            GoRoute(
              path: ':userId',
              name: 'adminUserDetail',
              pageBuilder: (context, state) => _slidePage(
                key: ValueKey<String>(state.uri.toString()),
                child: AdminUserDetailScreen(
                  userId: state.pathParameters['userId']!,
                ),
              ),
            ),
          ],
        ),
        GoRoute(
          path: AdminRoutes.notifications,
          name: 'adminNotifications',
          pageBuilder: (context, state) => _slidePage(
            key: ValueKey<String>(state.uri.toString()),
            child: const AdminNotificationsScreen(),
          ),
        ),
        GoRoute(
          path: AdminRoutes.auditLog,
          name: 'adminAuditLog',
          pageBuilder: (context, state) => _slidePage(
            key: ValueKey<String>(state.uri.toString()),
            child: const AdminAuditLogScreen(),
          ),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              VendorShell(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              navigatorKey: vendorDashboardNavigatorKey,
              routes: [
                GoRoute(
                  path: VendorRoutes.dashboard,
                  name: 'vendor',
                  pageBuilder: (context, state) => _vendorTabPage(
                    state: state,
                    child: const VendorDashboardScreen(),
                  ),
                  routes: [
                    GoRoute(
                      path: 'analytics',
                      name: 'vendorAnalytics',
                      pageBuilder: (context, state) => _slidePage(
                        key: ValueKey<String>(state.uri.toString()),
                        child: const VendorAnalyticsScreen(),
                      ),
                    ),
                    GoRoute(
                      path: 'reviews',
                      name: 'vendorReviews',
                      pageBuilder: (context, state) => _slidePage(
                        key: ValueKey<String>(state.uri.toString()),
                        child: const VendorReviewsScreen(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: vendorOrdersNavigatorKey,
              routes: [
                GoRoute(
                  path: VendorRoutes.orders,
                  name: 'vendorOrders',
                  pageBuilder: (context, state) => _vendorTabPage(
                    state: state,
                    child: const VendorOrdersScreen(),
                  ),
                  routes: [
                    GoRoute(
                      path: ':orderId',
                      name: 'vendorOrderDetail',
                      pageBuilder: (context, state) => _slidePage(
                        key: ValueKey<String>(state.uri.toString()),
                        child: VendorOrderDetailScreen(
                          orderId: state.pathParameters['orderId']!,
                        ),
                      ),
                      routes: [
                        GoRoute(
                          path: 'delivery-update',
                          name: 'vendorDeliveryUpdate',
                          pageBuilder: (context, state) => _slidePage(
                            key: ValueKey<String>(state.uri.toString()),
                            child: DeliveryUpdateScreen(
                              orderId: state.pathParameters['orderId']!,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: vendorProductsNavigatorKey,
              routes: [
                GoRoute(
                  path: VendorRoutes.products,
                  name: 'vendorProducts',
                  pageBuilder: (context, state) => _vendorTabPage(
                    state: state,
                    child: const VendorProductsScreen(),
                  ),
                  routes: [
                    GoRoute(
                      path: 'upload',
                      name: 'vendorProductUpload',
                      pageBuilder: (context, state) => _slidePage(
                        key: ValueKey<String>(state.uri.toString()),
                        child: const VendorProductFormScreen(),
                      ),
                    ),
                    GoRoute(
                      path: ':productId/edit',
                      name: 'vendorProductEdit',
                      pageBuilder: (context, state) => _slidePage(
                        key: ValueKey<String>(state.uri.toString()),
                        child: VendorProductFormScreen(
                          productId: state.pathParameters['productId'],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: vendorPaymentsNavigatorKey,
              routes: [
                GoRoute(
                  path: VendorRoutes.payments,
                  name: 'vendorPayments',
                  pageBuilder: (context, state) => _vendorTabPage(
                    state: state,
                    child: const VendorPaymentsScreen(),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: vendorProfileNavigatorKey,
              routes: [
                GoRoute(
                  path: VendorRoutes.profile,
                  name: 'vendorProfile',
                  pageBuilder: (context, state) => _vendorTabPage(
                    state: state,
                    child: const VendorProfileScreen(),
                  ),
                  routes: [
                    GoRoute(
                      path: 'settings',
                      name: 'vendorSettings',
                      pageBuilder: (context, state) => _slidePage(
                        key: ValueKey<String>(state.uri.toString()),
                        child: const VendorSettingsScreen(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ];

Widget _fadeTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(opacity: animation, child: child);
}

CustomTransitionPage<void> _vendorTabPage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: VendorTabScaffold(child: child),
    transitionsBuilder: _fadeTransition,
    transitionDuration: AppDurations.slow,
  );
}

CustomTransitionPage<void> _adminTabPage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: AdminTabScaffold(child: child),
    transitionsBuilder: _fadeTransition,
    transitionDuration: AppDurations.slow,
  );
}

CustomTransitionPage<void> _slidePage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 320),
    reverseTransitionDuration: const Duration(milliseconds: 320),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offset = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ));
      return SlideTransition(position: offset, child: child);
    },
  );
}

CustomTransitionPage<void> _slideUpPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 360),
    reverseTransitionDuration: const Duration(milliseconds: 320),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offset = Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      ));
      return SlideTransition(position: offset, child: child);
    },
  );
}
