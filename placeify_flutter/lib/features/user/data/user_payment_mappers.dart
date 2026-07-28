import 'package:placeify_client/placeify_client.dart' as api;

import '../../vendor/data/vendor_payment_mapper.dart';
import '../domain/models/user_payment_record.dart';

abstract final class UserPaymentMappers {
  static UserPaymentRecord toRecord(api.UserOrderPaymentSummary summary) {
    return UserPaymentRecord(
      orderNumber: summary.orderNumber ?? summary.orderId.toString(),
      amount: summary.amount,
      paymentMethodLabel: _paymentMethodLabel(summary.paymentMethod),
      status: VendorPaymentMapper.fromTransactionStatus(summary.status),
      createdAt: summary.createdAt,
    );
  }

  static String _paymentMethodLabel(api.PaymentMethod method) {
    return switch (method) {
      api.PaymentMethod.cashOnDelivery => 'Cash on Delivery',
      api.PaymentMethod.esewa => 'eSewa',
      api.PaymentMethod.khalti => 'Khalti',
      api.PaymentMethod.mockOnline => 'Online',
    };
  }
}
