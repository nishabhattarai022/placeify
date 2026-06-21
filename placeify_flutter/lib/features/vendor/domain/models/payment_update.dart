import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/payment_status.dart';

part 'payment_update.freezed.dart';
part 'payment_update.g.dart';

@freezed
abstract class PaymentUpdate with _$PaymentUpdate {
  const factory PaymentUpdate({
    required String id,
    required String orderId,
    required double amount,
    required PaymentStatus status,
    required String note,
    required DateTime updatedAt,
  }) = _PaymentUpdate;

  factory PaymentUpdate.fromJson(Map<String, dynamic> json) =>
      _$PaymentUpdateFromJson(json);
}

extension PaymentUpdatesX on List<PaymentUpdate> {
  /// Latest vendor payment status for an order (server returns newest first).
  PaymentStatus get vendorPaymentStatus =>
      isEmpty ? PaymentStatus.pending : first.status;

  bool get canVendorEditPayment => !vendorPaymentStatus.isFullyPaid;
}
