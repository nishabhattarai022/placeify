import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item.freezed.dart';
part 'order_item.g.dart';

/// Snapshot of a product line at checkout time.
@freezed
abstract class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String productId,
    required String productName,
    required String productImageUrl,
    required String brandName,
    required String sku,
    required double unitPrice,
    double? discountedPrice,
    required int quantity,
    String? selectedColor,
    @Default({}) Map<String, String> dimensions,
  }) = _OrderItem;

  const OrderItem._();

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  double get effectiveUnitPrice => discountedPrice ?? unitPrice;

  double get lineTotal => effectiveUnitPrice * quantity;

  String get dimensionsLabel {
    if (dimensions.isEmpty) return '';
    final parts = <String>[];
    for (final entry in dimensions.entries) {
      parts.add('${entry.key}: ${entry.value}');
    }
    return parts.join(' · ');
  }
}
