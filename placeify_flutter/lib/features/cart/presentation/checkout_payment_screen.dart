import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/placeify_server_client.dart';
import '../../../core/debug/agent_debug_log.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/haptic_service.dart';
import '../../../core/utils/formatters.dart';
import '../data/cart_api_errors.dart';
import '../domain/checkout_flow_result.dart';
import '../domain/checkout_payment_option.dart';
import '../domain/cart_totals.dart';
import '../domain/constants/cart_strings.dart';
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
  late final TextEditingController _addressController;
  bool _addressPrefillDone = false;

  static const _paymentOptions = CheckoutPaymentOption.values;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    unawaited(_prefillAddress());
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _prefillAddress() async {
    try {
      final profile = await client.user.getCurrentUser();
      final saved = profile?.address?.trim();
      if (!mounted || saved == null || saved.isEmpty) {
        _addressPrefillDone = true;
        return;
      }
      // Prefer saved profile address, but keep any typed text if user already edited.
      if (_addressController.text.trim().isEmpty) {
        _addressController.text = saved;
      }
    } catch (error) {
      debugPrint('[checkout] address prefill failed: $error');
    } finally {
      if (mounted) {
        setState(() => _addressPrefillDone = true);
      } else {
        _addressPrefillDone = true;
      }
    }
  }

  void _showCheckoutFeedback(String message) {
    // SnackBar only — PlaceifyToast via rootNavigatorKey throws
    // "No Overlay widget found" and was aborting the success path.
    // #region agent log
    final messenger = rootScaffoldMessengerKey.currentState;
    agentDebugLog(
      location: 'checkout_payment_screen.dart:_showCheckoutFeedback',
      message: 'Emitting checkout feedback',
      hypothesisId: 'H7',
      data: {
        'message': message,
        'hasMessenger': messenger != null,
        'toastSkipped': true,
        'mounted': mounted,
      },
      runId: 'post-fix',
    );
    // #endregion
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
  }

  Future<void> _onConfirm(CartTotals totals) async {
    HapticService.medium();

    final selectedMethod = ref.read(selectedPaymentMethodProvider);
    // #region agent log
    agentDebugLog(
      location: 'checkout_payment_screen.dart:_onConfirm:entry',
      message: 'Confirm tapped',
      hypothesisId: 'H1',
      data: {
        'selectedMethod': selectedMethod?.name,
        'itemCount': ref.read(cartProvider).length,
        'totals': totals.total,
        'rootCtxNull': rootNavigatorKey.currentContext == null,
        'mounted': mounted,
      },
      runId: 'post-fix',
    );
    // #endregion
    if (selectedMethod == null) {
      setState(() {
        _validationError = CartStrings.selectPaymentMethod;
      });
      _showCheckoutFeedback(CartStrings.selectPaymentMethod);
      return;
    }

    if (selectedMethod == CheckoutPaymentOption.khalti) {
      setState(() {
        _validationError = CartStrings.khaltiUnavailable;
      });
      _showCheckoutFeedback(CartStrings.khaltiUnavailable);
      return;
    }

    final shippingAddress = _addressController.text.trim();
    if (shippingAddress.isEmpty) {
      setState(() {
        _validationError = CartStrings.deliveryAddressRequired;
      });
      _showCheckoutFeedback(CartStrings.deliveryAddressRequired);
      return;
    }

    setState(() {
      _validationError = null;
      _isConfirming = true;
    });

    try {
      debugPrint(
        '[checkout] UI confirm serverUrl=$serverUrl totals=${totals.total}',
      );
      final result = await confirmCheckoutOrder(
        ref,
        totals: totals,
        shippingAddress: shippingAddress,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => const CheckoutFlowFailure(
          'Checkout timed out. Please try again.',
        ),
      );

      // #region agent log
      agentDebugLog(
        location: 'checkout_payment_screen.dart:_onConfirm:result',
        message: 'Checkout result received',
        hypothesisId: 'H1',
        data: {
          'resultType': result.runtimeType.toString(),
          'mounted': mounted,
          'rootCtxNull': rootNavigatorKey.currentContext == null,
          'cartLenAfter': ref.read(cartProvider).length,
          'message': switch (result) {
            CheckoutFlowSuccess(:final message) => message,
            CheckoutFlowFailure(:final message) => message,
          },
          'orderId': switch (result) {
            CheckoutFlowSuccess(:final orderId) => orderId,
            CheckoutFlowFailure() => null,
          },
        },
        runId: 'post-fix',
      );
      // #endregion

      if (!mounted) return;

      switch (result) {
        case CheckoutFlowSuccess(:final orderId, :final message):
          ref.read(selectedPaymentMethodProvider.notifier).clear();
          final feedback = selectedMethod == CheckoutPaymentOption.esewa
              ? CartStrings.esewaOpening
              : message;
          _showCheckoutFeedback(feedback);
          await Future<void>.delayed(const Duration(milliseconds: 400));
          if (!mounted) return;

          if (selectedMethod == CheckoutPaymentOption.esewa) {
            // Server already consumed the cart into an unpaid order.
            // Clear local cart now so retrying checkout cannot duplicate it.
            ref.read(cartProvider.notifier).replaceItems(const []);
            context.push('/cart/checkout/esewa/$orderId');
          } else {
            ref.read(cartProvider.notifier).replaceItems(const []);
            context.go('/profile/orders/$orderId');
          }
        case CheckoutFlowFailure(:final message):
          _showCheckoutFeedback(
            message.trim().isEmpty ? CartStrings.unableToPlaceOrder : message,
          );
      }
    } catch (error, stackTrace) {
      debugPrint('Checkout confirm failed: $error');
      debugPrint('Checkout confirm serverUrl=$serverUrl');
      debugPrint('$stackTrace');
      // #region agent log
      agentDebugLog(
        location: 'checkout_payment_screen.dart:_onConfirm:catch',
        message: 'Checkout threw',
        hypothesisId: 'H3',
        data: {
          'error': error.toString(),
          'mounted': mounted,
          'rootCtxNull': rootNavigatorKey.currentContext == null,
        },
        runId: 'post-fix',
      );
      // #endregion
      if (!mounted) return;
      _showCheckoutFeedback(
        CartApiErrors.message(
          error,
          fallback: CartStrings.unableToPlaceOrder,
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

    // Keep checkout UI visible while confirming — server clears cart on success
    // and a mid-flight refresh must not wipe feedback / loading state.
    if (items.isEmpty && !_isConfirming) {
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
                    final product = ref.watch(
                      productByIdProvider(item.productId),
                    );
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
                  const Text(
                    CartStrings.deliveryAddressLabel,
                    style: CartTokens.sectionTitle,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Used for this order only. Edit if needed before placing.',
                    style: TextStyle(
                      fontSize: 14,
                      color: CartTokens.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _addressController,
                    enabled: !_isConfirming,
                    minLines: 2,
                    maxLines: 4,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: CartStrings.deliveryAddressHint,
                      filled: true,
                      fillColor: CartTokens.cardBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: CartTokens.divider),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: CartTokens.divider),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: CartTokens.black,
                          width: 1.5,
                        ),
                      ),
                    ),
                    onChanged: (_) {
                      if (_validationError ==
                          CartStrings.deliveryAddressRequired) {
                        setState(() => _validationError = null);
                      }
                    },
                  ),
                  if (!_addressPrefillDone) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Loading saved address…',
                      style: TextStyle(
                        fontSize: 12,
                        color: CartTokens.textSecondary,
                      ),
                    ),
                  ],
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
                    onTapDown: selectedMethod == null || _isConfirming
                        ? null
                        : (_) => setState(() => _confirmPressed = true),
                    onTapUp: selectedMethod == null || _isConfirming
                        ? null
                        : (_) => setState(() => _confirmPressed = false),
                    onTapCancel: selectedMethod == null || _isConfirming
                        ? null
                        : () => setState(() => _confirmPressed = false),
                    onTap: _isConfirming
                        ? null
                        : () async {
                            setState(() {
                              _confirmPressed = false;
                            });

                            await _onConfirm(totals);
                          },
                    child: AnimatedScale(
                      scale: _confirmPressed ? 0.98 : 1,
                      duration: const Duration(milliseconds: 120),
                      child: AnimatedOpacity(
                        opacity: _isConfirming ? 0.55 : 1,
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
                              : Text(
                                  selectedMethod == null
                                      ? CartStrings.selectPaymentMethod
                                      : selectedMethod ==
                                            CheckoutPaymentOption.esewa
                                      ? 'Pay with eSewa'
                                      : 'Confirm Order',
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
