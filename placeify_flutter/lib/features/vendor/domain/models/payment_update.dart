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
    String? paymentMethodLabel,
    String? customerName,
  }) = _PaymentUpdate;

  factory PaymentUpdate.fromJson(Map<String, dynamic> json) =>
      _$PaymentUpdateFromJson(json);
}
