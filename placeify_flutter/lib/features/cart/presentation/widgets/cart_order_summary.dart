import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/services/haptic_service.dart';
import '../../../../core/utils/formatters.dart';
import '../cart_tokens.dart';
import '../providers/cart_provider.dart';

class CartOrderSummary extends StatefulWidget {
  const CartOrderSummary({
    required this.totals,
    required this.onCheckout,
    super.key,
  });

  final CartTotals totals;
  final VoidCallback onCheckout;

  @override
  State<CartOrderSummary> createState() => _CartOrderSummaryState();
}

class _CartOrderSummaryState extends State<CartOrderSummary> {
  bool _checkoutPressed = false;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final showDiscount = widget.totals.discount > 0;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(CartTokens.summaryTopRadius),
          topRight: Radius.circular(CartTokens.summaryTopRadius),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: CartTokens.summaryBlurSigma,
                  sigmaY: CartTokens.summaryBlurSigma,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        CartTokens.summaryGlassTop,
                        CartTokens.summaryGlassBottom,
                      ],
                    ),
                    border: const Border(
                      top: BorderSide(
                        color: CartTokens.summaryHighlight,
                        width: 1.2,
                      ),
                    ),
                    boxShadow: CartTokens.summaryShadow,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                CartTokens.screenPadding + 8,
                CartTokens.summaryInnerPadding,
                CartTokens.screenPadding + 8,
                CartTokens.summaryOuterBottomPadding,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Order Info', style: CartTokens.sectionTitle),
                  const SizedBox(height: 14),
                  _SummaryRow(
                    label: 'Subtotal',
                    value: Formatters.currencyDecimal(widget.totals.subtotal),
                  ),
                  if (showDiscount) ...[
                    const SizedBox(height: 10),
                    _SummaryRow(
                      label: 'Discount',
                      value: Formatters.currencyDecimalDiscount(
                        widget.totals.discount,
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  Container(height: 1, color: CartTokens.divider),
                  const SizedBox(height: 14),
                  _TotalRow(
                    value: Formatters.currencyDecimal(widget.totals.total),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTapDown: (_) => setState(() => _checkoutPressed = true),
                    onTapUp: (_) => setState(() => _checkoutPressed = false),
                    onTapCancel: () =>
                        setState(() => _checkoutPressed = false),
                    onTap: () {
                      HapticService.medium();
                      widget.onCheckout();
                    },
                    child: AnimatedScale(
                      scale: _checkoutPressed ? 0.98 : 1,
                      duration: const Duration(milliseconds: 120),
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
                        child: const Text(
                          'Checkout',
                          style: CartTokens.checkoutText,
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: CartTokens.rowLabel),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: Text(
            value,
            key: ValueKey<String>(value),
            style: CartTokens.rowValue,
          ),
        ),
      ],
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Total', style: CartTokens.totalLabel),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 240),
          child: Text(
            value,
            key: ValueKey<String>(value),
            style: CartTokens.totalValue,
          ),
        ),
      ],
    );
  }
}
