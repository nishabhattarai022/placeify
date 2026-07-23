import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/payment_status.dart';

part 'vendor_payout.freezed.dart';
part 'vendor_payout.g.dart';

@freezed
abstract class VendorPayout with _$VendorPayout {
  const factory VendorPayout({
    required String id,
    required double amount,
    required PaymentStatus status,
    DateTime? paidAt,
    required String reference,
  }) = _VendorPayout;

  const VendorPayout._();

  factory VendorPayout.fromJson(Map<String, dynamic> json) =>
      _$VendorPayoutFromJson(json);

  String get statusLabel => switch (status) {
        PaymentStatus.pending => 'Pending',
        PaymentStatus.paid => 'Paid',
        PaymentStatus.partial => 'Partial',
        PaymentStatus.refundPending => 'Refund Pending',
        PaymentStatus.refunded => 'Refunded',
        PaymentStatus.failed => 'Failed',
      };
}
