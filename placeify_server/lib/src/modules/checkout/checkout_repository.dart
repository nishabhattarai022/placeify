import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';
import '../../shared/session_service.dart';
import '../checkout/checkout_order_setup.dart';
import '../payment/payment_repository.dart';

class CheckoutStore {
  CheckoutStore({PaymentStore? paymentStore})
      : _paymentStore = paymentStore ?? PaymentStore();

  final PaymentStore _paymentStore;
  Future<CheckoutResult> checkout(
    Session session,
    CheckoutRequest request,
  ) async {
    final address = request.shippingAddress.trim();
    if (address.isEmpty) {
      throw PlaceifyException(message: 'Shipping address is required.',
        code: 'INVALID_ADDRESS',
      );
    }

    final paymentMethod = request.paymentMethod;

    final user = await SessionService.requireUser(session);
    final cart = await SessionService.requireCart(session);

    final cartItems = await CartItem.db.find(
      session,
      where: (row) => row.cartId.equals(cart.id!),
      include: CartItem.include(product: Product.include()),
    );

    if (cartItems.isEmpty) {
      throw PlaceifyException(message: 'Your cart is empty.', code: 'CART_EMPTY');
    }

    final totalAmount = cartItems.fold<double>(
      0,
      (sum, item) => sum + (item.unitPrice * item.quantity),
    );

    final itemCount = cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
    final vendorIds = <UuidValue>{};

    final order = await session.db.transaction((transaction) async {
      final created = await Order.db.insertRow(
        session,
        Order(
          userId: user.id!,
          status: OrderStatus.pending,
          totalAmount: totalAmount,
          shippingAddress: address,
        ),
        transaction: transaction,
      );

      for (final item in cartItems) {
        final product = item.product;
        if (product == null || product.id == null) {
          throw PlaceifyException(message: 'A cart item references a missing product.',
            code: 'PRODUCT_NOT_FOUND',
          );
        }

        await OrderItem.db.insertRow(
          session,
          OrderItem(
            orderId: created.id!,
            productId: product.id!,
            vendorId: product.vendorId,
            quantity: item.quantity,
            unitPrice: item.unitPrice,
          ),
          transaction: transaction,
        );
        vendorIds.add(product.vendorId);
      }

      await CartItem.db.deleteWhere(
        session,
        where: (row) => row.cartId.equals(cart.id!),
        transaction: transaction,
      );

      await _paymentStore.createForOrder(
        session,
        orderId: created.id!,
        userId: user.id!,
        amount: totalAmount,
        paymentMethod: paymentMethod,
        transaction: transaction,
      );

      return created;
    });

    await CheckoutOrderSetup.notifyVendorsOfNewOrder(
      session,
      order.id!,
      vendorIds,
    );

    return CheckoutResult(order: order, itemCount: itemCount);
  }
}
