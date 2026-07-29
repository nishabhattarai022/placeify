import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../marketplace/marketplace_events.dart';
import '../../shared/placeify_exception.dart';
import '../../shared/session_service.dart';
import '../checkout/checkout_order_setup.dart';
import '../order/order_lifecycle_store.dart';
import '../payment/esewa_gateway.dart';
import '../payment/payment_repository.dart';
import '../product/product_pricing.dart';

class CheckoutStore {
  CheckoutStore({PaymentStore? paymentStore})
      : _paymentStore = paymentStore ?? PaymentStore();

  final PaymentStore _paymentStore;

  // #region agent log
  void _dbg(String message, Map<String, Object?> data, {String hypothesisId = 'H4'}) {
    try {
      File(
        '/Users/rosikagajurel/Documents/College/placeify/.cursor/debug-643556.log',
      ).writeAsStringSync(
        '${jsonEncode({
          'sessionId': '643556',
          'runId': 'post-fix',
          'hypothesisId': hypothesisId,
          'location': 'checkout_repository.dart:checkout',
          'message': message,
          'data': data,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        })}\n',
        mode: FileMode.append,
        flush: true,
      );
    } catch (_) {}
  }
  // #endregion

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

    if (paymentMethod == PaymentMethod.esewa) {
      // Fail before creating an unpaid order if eSewa cannot be started.
      try {
        EsewaGateway.requireCredentials(session);
      } on StateError {
        throw PlaceifyException(
          message: 'eSewa is not configured on the server yet.',
          code: 'ESEWA_NOT_CONFIGURED',
        );
      }
    }

    final user = await SessionService.requireUser(session);
    final cart = await SessionService.requireCart(session);

    final cartItems = await CartItem.db.find(
      session,
      where: (row) => row.cartId.equals(cart.id!),
      include: CartItem.include(product: Product.include()),
    );

    // #region agent log
    _dbg('Checkout endpoint entered', {
      'userId': user.id?.uuid,
      'cartId': cart.id?.toString(),
      'cartItemCount': cartItems.length,
      'paymentMethod': paymentMethod.name,
    }, hypothesisId: 'H3');
    // #endregion

    if (cartItems.isEmpty) {
      // #region agent log
      _dbg('CART_EMPTY at checkout', {
        'cartId': cart.id?.toString(),
        'paymentMethod': paymentMethod.name,
      }, hypothesisId: 'H3');
      // #endregion
      throw PlaceifyException(message: 'Your cart is empty.', code: 'CART_EMPTY');
    }

    final totalAmount = cartItems.fold<double>(
      0,
      (sum, item) {
        final product = item.product;
        if (product == null) {
          return sum + (item.unitPrice * item.quantity);
        }
        final chargedUnitPrice = ProductPricing.effectiveUnitPrice(product);
        return sum + (chargedUnitPrice * item.quantity);
      },
    );

    final itemCount = cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
    final vendorIds = <UuidValue>{};

    final placedAt = DateTime.now();
    final autoExpiresAt = placedAt.add(const Duration(days: 30));

    final order = await session.db.transaction((transaction) async {
      final created = await Order.db.insertRow(
        session,
        Order(
          userId: user.id!,
          status: OrderStatus.pending,
          paymentStatus: OrderPaymentStatus.unpaid,
          totalAmount: totalAmount,
          shippingAddress: address,
          autoExpiresAt: autoExpiresAt,
          placedAt: placedAt,
        ),
        transaction: transaction,
      );

      await OrderLifecycleStore.appendHistory(
        session,
        created.id!,
        statusType: OrderStatusHistoryType.order,
        newStatus: OrderStatus.pending.name,
        changedByUserId: user.id,
        note: 'Order placed',
        transaction: transaction,
      );

      for (final item in cartItems) {
        final product = item.product;
        if (product == null || product.id == null) {
          throw PlaceifyException(message: 'A cart item references a missing product.',
            code: 'PRODUCT_NOT_FOUND',
          );
        }

        final chargedUnitPrice = ProductPricing.effectiveUnitPrice(product);

        await OrderItem.db.insertRow(
          session,
          OrderItem(
            orderId: created.id!,
            productId: product.id!,
            vendorId: product.vendorId,
            quantity: item.quantity,
            unitPrice: chargedUnitPrice,
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

    try {
      await CheckoutOrderSetup.notifyVendorsOfNewOrder(
        session,
        order.id!,
        vendorIds,
      );
    } catch (error, stackTrace) {
      session.log(
        'notifyVendorsOfNewOrder failed orderId=${order.id} error=$error',
        level: LogLevel.warning,
        exception: error,
        stackTrace: stackTrace,
      );
    }

    final customerName = user.name?.trim().isNotEmpty == true
        ? user.name!.trim()
        : 'Customer';

    for (final vendorId in vendorIds) {
      try {
        await marketplaceEventDispatcher.dispatch(
          session,
          OrderPlacedEvent(
            order: order,
            vendorId: vendorId,
            customerName: customerName,
            itemCount: itemCount,
          ),
        );
      } catch (error, stackTrace) {
        session.log(
          'OrderPlacedEvent dispatch failed orderId=${order.id} '
          'vendorId=$vendorId error=$error',
          level: LogLevel.warning,
          exception: error,
          stackTrace: stackTrace,
        );
      }
    }

    try {
      await marketplaceEventDispatcher.dispatch(
        session,
        CustomerOrderPlacedEvent(order: order),
      );
    } catch (error, stackTrace) {
      session.log(
        'CustomerOrderPlacedEvent dispatch failed orderId=${order.id} '
        'error=$error',
        level: LogLevel.warning,
        exception: error,
        stackTrace: stackTrace,
      );
    }

    // #region agent log
    _dbg('Order created and vendors notified', {
      'orderId': order.id,
      'itemCount': itemCount,
      'paymentMethod': paymentMethod.name,
      'vendorIds': vendorIds.map((id) => id.uuid).toList(),
      'vendorCount': vendorIds.length,
    }, hypothesisId: 'H4');
    // #endregion

    return CheckoutResult(order: order, itemCount: itemCount);
  }
}
