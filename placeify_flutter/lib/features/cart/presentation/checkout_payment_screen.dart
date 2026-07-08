import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/placeify_server_client.dart';
import '../../../core/services/haptic_service.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../data/cart_api_errors.dart';
import '../domain/checkout_flow_result.dart';
import '../domain/checkout_payment_option.dart';
import '../domain/cart_totals.dart';
import '../../home/presentation/providers/category_provider.dart';
import 'cart_actions.dart';
import 'cart_tokens.dart';
import 'providers/cart_totals_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/checkout_payment_provider.dart';
import 'widgets/checkout_order_item_tile.dart';
import 'widgets/checkout_payment_method_tile.dart';

class CheckoutPaymentScreen extends ConsumerStatefulWidget {
  const CheckoutPaymentScreen({super.key});

  @override
  ConsumerState<CheckoutPaymentScreen> createState() =>
      _CheckoutPaymentScreenState();
}

class _CheckoutPaymentScreenState extends ConsumerState<CheckoutPaymentScreen> {
  String? _validationError;
  bool _isConfirming = false;
  bool _confirmPressed = false;

  static const _paymentOptions = CheckoutPaymentOption.values;

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

  Future<void> _onConfirm(CartTotals totals) async {
    HapticService.medium();

    final selectedMethod = ref.read(selectedPaymentMethodProvider);
    if (selectedMethod == null) {
      setState(() {
        _validationError = 'Please select a payment method to continue.';
      });
      return;
    }

    setState(() {
      _validationError = null;
      _isConfirming = true;
    });

    try {
      debugPrint('[checkout] UI confirm serverUrl=$serverUrl totals=${totals.total}');
      final result = await confirmCheckoutOrder(ref, totals: totals).timeout(
        const Duration(seconds: 30),
        onTimeout: () => const CheckoutFlowFailure(
          'Checkout timed out. Please try again.',
        ),
      );

      if (!mounted) return;

      switch (result) {
        case CheckoutFlowSuccess(:final orderId, :final message):
          ref.read(selectedPaymentMethodProvider.notifier).clear();
          PlaceifyToast.show(context, message);
          context.go('/profile/orders/$orderId');
        case CheckoutFlowFailure(:final message):
          PlaceifyToast.show(context, message);
      }
    } catch (error, stackTrace) {
      debugPrint('Checkout confirm failed: $error');
      debugPrint('Checkout confirm serverUrl=$serverUrl');
      debugPrint('$stackTrace');
      if (!mounted) return;
      PlaceifyToast.show(
        context,
        CartApiErrors.message(
          error,
          fallback:
              'Checkout failed. Please check your connection and try again.',
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isConfirming = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(cartProvider);
    final totals = ref.watch(cartTotalsProvider);
    final selectedMethod = ref.watch(selectedPaymentMethodProvider);

    if (items.isEmpty) {
      return Scaffold(
        backgroundColor: CartTokens.background,
        body: SafeArea(
          child: Column(
            children: [
              _CheckoutHeader(onBack: () => context.pop()),
              const Expanded(
                child: Center(
                  child: Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 16,
                      color: CartTokens.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: CartTokens.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CheckoutHeader(onBack: () => context.pop()),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  CartTokens.screenPadding,
                  8,
                  CartTokens.screenPadding,
                  24,
                ),
                physics: const BouncingScrollPhysics(),
                children: [
                  const Text('Order Summary', style: CartTokens.sectionTitle),
                  const SizedBox(height: 14),
                  ...items.map((item) {
                    final product = ref.watch(productByIdProvider(item.productId));
                    if (product == null) {
                      return const SizedBox.shrink();
                    }
                    return CheckoutOrderItemTile(
                      key: ValueKey<String>(item.productId),
                      item: item,
                      product: product,
                    );
                  }),
                  const SizedBox(height: 20),
                  _SummaryCard(totals: totals),
                  const SizedBox(height: 28),
                  const Text('Payment Method', style: CartTokens.sectionTitle),
                  const SizedBox(height: 6),
                  const Text(
                    'Choose how you would like to pay',
                    style: TextStyle(
                      fontSize: 14,
                      color: CartTokens.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ..._paymentOptions.map(
                    (option) => CheckoutPaymentMethodTile(
                      option: option,
                      selected: selectedMethod == option,
                      onTap: () {
                        HapticService.light();
                        ref
                            .read(selectedPaymentMethodProvider.notifier)
                            .select(option);
                        setState(() => _validationError = null);
                      },
                    ),
                  ),
                  if (_validationError != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _validationError!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFB5564E),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTapDown: (_) => setState(() => _confirmPressed = true),
                    onTapUp: (_) => setState(() => _confirmPressed = false),
                    onTapCancel: () => setState(() => _confirmPressed = false),
                    onTap: _isConfirming ? null : () => _onConfirm(totals),
                    child: AnimatedScale(
                      scale: _confirmPressed ? 0.98 : 1,
                      duration: const Duration(milliseconds: 120),
                      child: AnimatedOpacity(
                        opacity: _isConfirming ? 0.7 : 1,
                        duration: const Duration(milliseconds: 150),
                        child: Container(
                          height: CartTokens.checkoutHeight,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: CartTokens.black,
                            borderRadius: BorderRadius.circular(
                              CartTokens.checkoutRadius,
                            ),
                            boxShadow: CartTokens.checkoutShadow,
                          ),
                          alignment: Alignment.center,
                          child: _isConfirming
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Confirm Order',
                                  style: CartTokens.checkoutText,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutHeader extends StatelessWidget {
  const _CheckoutHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, CartTokens.screenPadding, 4),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticService.light();
              onBack();
            },
            child: Container(
              width: CartTokens.headerIconSize,
              height: CartTokens.headerIconSize,
              decoration: BoxDecoration(
                color: CartTokens.iconBackground,
                shape: BoxShape.circle,
                boxShadow: CartTokens.headerIconShadow,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: CartTokens.textPrimary,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Checkout',
              textAlign: TextAlign.center,
              style: CartTokens.headerTitle,
            ),
          ),
          const SizedBox(width: CartTokens.headerIconSize),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.totals});

  final CartTotals totals;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CartTokens.cardBackground,
        borderRadius: BorderRadius.circular(CartTokens.cardRadius),
        boxShadow: CartTokens.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal', style: CartTokens.rowLabel),
              Text(
                Formatters.currencyDecimal(totals.subtotal),
                style: CartTokens.rowValue,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: CartTokens.divider),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: CartTokens.totalLabel),
              Text(
                Formatters.currencyDecimal(totals.total),
                style: CartTokens.totalValue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
