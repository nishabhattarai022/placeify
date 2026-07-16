import 'package:flutter/material.dart';

import '../../domain/checkout_payment_option.dart';
import '../cart_tokens.dart';

class CheckoutPaymentMethodTile extends StatelessWidget {
  const CheckoutPaymentMethodTile({
    required this.option,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final CheckoutPaymentOption option;
  final bool selected;
  final VoidCallback onTap;

  IconData get _icon => switch (option) {
        CheckoutPaymentOption.khalti => Icons.account_balance_wallet_outlined,
        CheckoutPaymentOption.esewa => Icons.phone_android_outlined,
        CheckoutPaymentOption.cashOnDelivery => Icons.payments_outlined,
        CheckoutPaymentOption.bankTransfer => Icons.qr_code_2_outlined,
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(CartTokens.cardRadius),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: CartTokens.cardBackground,
              borderRadius: BorderRadius.circular(CartTokens.cardRadius),
              border: Border.all(
                color: selected ? CartTokens.black : CartTokens.divider,
                width: selected ? 1.8 : 1,
              ),
              boxShadow: selected ? CartTokens.cardShadow : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: CartTokens.imageWell,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Icon(_icon, size: 22, color: CartTokens.textPrimary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.label,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: CartTokens.textPrimary,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        option.subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: CartTokens.textSecondary,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? CartTokens.black : CartTokens.textMuted,
                      width: selected ? 6 : 1.5,
                    ),
                    color: selected ? Colors.white : Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
