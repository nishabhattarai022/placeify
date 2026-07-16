import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../../home/domain/models/product.dart';
import '../../data/cart_display_config.dart';
import '../../domain/cart_line_item.dart';
import '../cart_tokens.dart';

/// Read-only cart line for the checkout order summary.
class CheckoutOrderItemTile extends StatelessWidget {
  const CheckoutOrderItemTile({
    required this.item,
    required this.product,
    super.key,
  });

  final CartLineItem item;
  final Product product;

  @override
  Widget build(BuildContext context) {
    final name = CartDisplayConfig.nameFor(product.id, product.name);
    final unitPrice = CartDisplayConfig.priceFor(product.id, product.price);
    final lineTotal = unitPrice * item.quantity;

    return Container(
      margin: const EdgeInsets.only(bottom: CartTokens.cardSpacing),
      padding: const EdgeInsets.symmetric(
        horizontal: CartTokens.cardHorizontalPadding + 8,
        vertical: CartTokens.cardVerticalPadding + 4,
      ),
      decoration: BoxDecoration(
        color: CartTokens.cardBackground,
        borderRadius: BorderRadius.circular(CartTokens.cardRadius),
        boxShadow: CartTokens.cardShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: CartTokens.productName,
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty ${item.quantity}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: CartTokens.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            Formatters.currencyDecimal(lineTotal),
            style: CartTokens.productPrice,
          ),
        ],
      ),
    );
  }
}
