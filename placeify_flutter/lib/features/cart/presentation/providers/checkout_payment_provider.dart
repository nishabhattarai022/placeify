import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/checkout_payment_option.dart';

part 'checkout_payment_provider.g.dart';

/// Selected payment method on the checkout screen (independent of cart totals).
@riverpod
class SelectedPaymentMethod extends _$SelectedPaymentMethod {
  @override
  CheckoutPaymentOption? build() => null;

  void select(CheckoutPaymentOption option) => state = option;

  void clear() => state = null;
}
