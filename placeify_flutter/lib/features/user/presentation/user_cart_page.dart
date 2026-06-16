import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/services/haptic_service.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../../../main.dart' show client;
import '../../cart/presentation/providers/cart_provider.dart';
import '../../cart/presentation/widgets/cart_line_card.dart';
import '../../cart/presentation/widgets/cart_order_summary.dart';
import '../../home/presentation/providers/category_provider.dart';
import '../../profile/presentation/providers/profile_dashboard_provider.dart';

/// Shopping cart backed by [client.cart] and [client.checkout].
class UserCartPage extends ConsumerStatefulWidget {
  const UserCartPage({super.key});

  @override
  ConsumerState<UserCartPage> createState() => _UserCartPageState();
}

class _UserCartPageState extends ConsumerState<UserCartPage> {
  Future<void> _refresh() async {
    await ref.read(cartProvider.notifier).refresh();
  }

  Future<void> _checkout() async {
    final message = await ref.read(cartProvider.notifier).checkout();
    if (!mounted) return;

    PlaceifyToast.show(context, message);

    if (message.contains('placed successfully')) {
      ref.invalidate(profileOrdersProvider);
      await ref.read(profileDashboardProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!client.auth.isAuthenticated) {
      return _AuthRequired(onLogin: () => context.push('/login'));
    }

    final items = ref.watch(cartProvider);
    final editMode = ref.watch(cartEditModeProvider);
    final totals = ref.watch(cartTotalsProvider);
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;
    final horizontalPadding = isDesktop ? AppSpacing.xxl : AppSpacing.lg;
    final itemCount = ref.watch(cartItemCountProvider);

    return RefreshIndicator(
      onRefresh: _refresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                isDesktop ? AppSpacing.xxl : AppSpacing.lg,
                horizontalPadding,
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cart', style: AppTypography.sectionTitle),
                            const SizedBox(height: 6),
                            Text(
                              items.isEmpty
                                  ? 'Items you add from the catalog appear here.'
                                  : '$itemCount item${itemCount == 1 ? '' : 's'} ready for checkout.',
                              style: AppTypography.metricLabel.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (items.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            HapticService.light();
                            ref.read(cartEditModeProvider.notifier).toggle();
                          },
                          child: Text(editMode ? 'Done' : 'Edit'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (items.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyCartState(onBrowse: () => context.go('/browse')),
            )
          else ...[
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                AppSpacing.md,
                horizontalPadding,
                AppSpacing.lg,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = items[index];
                    final product = ref.watch(productByIdProvider(item.productId));
                    if (product == null) {
                      return const SizedBox.shrink();
                    }
                    final cart = ref.read(cartProvider.notifier);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CartLineCard(
                        key: ValueKey<String>(item.productId),
                        item: item,
                        product: product,
                        editMode: editMode,
                        onIncrement: () => cart.increment(item.productId),
                        onDecrement: () => cart.decrement(item.productId),
                        onRemove: () {
                          HapticService.light();
                          cart.remove(item.productId);
                        },
                      ),
                    );
                  },
                  childCount: items.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  0,
                  horizontalPadding,
                  AppSpacing.xxxl,
                ),
                child: CartOrderSummary(
                  totals: totals,
                  onCheckout: _checkout,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyCartState extends StatelessWidget {
  const _EmptyCartState({required this.onBrowse});

  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              size: 48,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              'Your cart is empty',
              style: AppTypography.sectionTitle.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Browse the catalog and add furniture to checkout from here.',
              textAlign: TextAlign.center,
              style: AppTypography.metricLabel.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onBrowse,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.forest,
                foregroundColor: Colors.white,
              ),
              child: const Text('Browse furniture'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthRequired extends StatelessWidget {
  const _AuthRequired({required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 48, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(
              'Sign in to view your cart',
              style: AppTypography.sectionTitle.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onLogin,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.forest,
                foregroundColor: Colors.white,
              ),
              child: const Text('Go to login'),
            ),
          ],
        ),
      ),
    );
  }
}
