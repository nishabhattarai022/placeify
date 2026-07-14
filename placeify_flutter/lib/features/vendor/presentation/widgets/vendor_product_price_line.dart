import 'package:flutter/material.dart';

import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/models/vendor_product.dart';

/// Price row for vendor product list tiles (matches catalog card pricing).
class VendorProductPriceLine extends StatelessWidget {
  const VendorProductPriceLine({
    required this.product,
    this.saleFontSize = 13,
    this.listFontSize = 11,
    super.key,
  });

  final VendorProduct product;
  final double saleFontSize;
  final double listFontSize;

  @override
  Widget build(BuildContext context) {
    if (product.isOnSale) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Flexible(
            child: Text(
              Formatters.currencyFull(product.originalPrice!),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.priceStrikethrough.copyWith(
                fontSize: listFontSize,
              ),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            Formatters.currencyFull(product.price),
            style: AppTypography.priceSale.copyWith(fontSize: saleFontSize),
          ),
        ],
      );
    }

    return Text(
      Formatters.currencyFull(product.price),
      style: AppTypography.priceSale.copyWith(fontSize: saleFontSize),
    );
  }
}
