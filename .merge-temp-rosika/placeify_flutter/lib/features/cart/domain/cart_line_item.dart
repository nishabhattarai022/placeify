/// A single row in the shopping cart.
class CartLineItem {
  const CartLineItem({
    required this.productId,
    required this.quantity,
  });

  final String productId;
  final int quantity;

  CartLineItem copyWith({int? quantity}) {
    return CartLineItem(
      productId: productId,
      quantity: quantity ?? this.quantity,
    );
  }
}
