import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/haptic_service.dart';
import '../../home/presentation/providers/category_provider.dart';
import 'cart_actions.dart';
import 'cart_tokens.dart';
import 'providers/cart_provider.dart';
import 'widgets/cart_header.dart';
import 'widgets/cart_line_card.dart';
import 'widgets/cart_order_summary.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(cartProvider);
    final editMode = ref.watch(cartEditModeProvider);
    final totals = ref.watch(cartTotalsProvider);

    final listBottomInset =
        CartTokens.summaryOverlayHeight + CartTokens.summaryScrollUnderlap;

    return Scaffold(
      backgroundColor: CartTokens.background,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CartHeader(
                  editMode: editMode,
                  onEdit: () =>
                      ref.read(cartEditModeProvider.notifier).toggle(),
                  onClose: () => context.go('/home'),
                ),
                Expanded(
                  child: items.isEmpty
                      ? _CartEmptyState(
                          onBrowse: () {
                            HapticService.light();
                            context.go('/browse');
                          },
                        )
                      : ListView.builder(
                          padding: EdgeInsets.fromLTRB(
                            CartTokens.screenPadding,
                            12,
                            CartTokens.screenPadding,
                            listBottomInset,
                          ),
                          physics: const BouncingScrollPhysics(),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final product = ref.watch(
                              productByIdProvider(item.productId),
                            );
                            if (product == null) {
                              return const SizedBox.shrink();
                            }
                            final cart = ref.read(cartProvider.notifier);
                            return CartLineCard(
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
                            );
                          },
                        ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CartOrderSummary(
                totals: totals,
                onCheckout: () => checkoutCart(ref, context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartEmptyState extends StatelessWidget {
  const _CartEmptyState({required this.onBrowse});

  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: CartTokens.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Explore our chairs and add pieces you love.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: CartTokens.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: onBrowse,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: CartTokens.black,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Browse chairs',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
