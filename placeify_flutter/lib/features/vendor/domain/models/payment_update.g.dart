// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentUpdate _$PaymentUpdateFromJson(Map<String, dynamic> json) =>
    _PaymentUpdate(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
      note: json['note'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      paymentMethodLabel: json['paymentMethodLabel'] as String?,
      customerName: json['customerName'] as String?,
    );

Map<String, dynamic> _$PaymentUpdateToJson(_PaymentUpdate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'amount': instance.amount,
      'status': _$PaymentStatusEnumMap[instance.status]!,
      'note': instance.note,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'paymentMethodLabel': instance.paymentMethodLabel,
      'customerName': instance.customerName,
    };

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.paid: 'paid',
  PaymentStatus.partial: 'partial',
  PaymentStatus.refunded: 'refunded',
  PaymentStatus.failed: 'failed',
};
