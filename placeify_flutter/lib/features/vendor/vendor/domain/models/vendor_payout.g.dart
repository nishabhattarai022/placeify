// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_payout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VendorPayout _$VendorPayoutFromJson(Map<String, dynamic> json) =>
    _VendorPayout(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
      reference: json['reference'] as String,
    );

Map<String, dynamic> _$VendorPayoutToJson(_VendorPayout instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'status': _$PaymentStatusEnumMap[instance.status]!,
      'paidAt': instance.paidAt?.toIso8601String(),
      'reference': instance.reference,
    };

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.paid: 'paid',
  PaymentStatus.partial: 'partial',
  PaymentStatus.refunded: 'refunded',
  PaymentStatus.failed: 'failed',
};
