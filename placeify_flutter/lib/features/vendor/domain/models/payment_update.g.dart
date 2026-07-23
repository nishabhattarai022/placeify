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
      customerEmail: json['customerEmail'] as String?,
      orderNumber: json['orderNumber'] as String?,
      orderStatus: json['orderStatus'] as String?,
      transactionId: json['transactionId'] as String?,
      providerTransactionId: json['providerTransactionId'] as String?,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      vendorEarnings: (json['vendorEarnings'] as num?)?.toDouble(),
      refundStatus: json['refundStatus'] as String?,
      refundDate: json['refundDate'] == null
          ? null
          : DateTime.parse(json['refundDate'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
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
      'customerEmail': instance.customerEmail,
      'orderNumber': instance.orderNumber,
      'orderStatus': instance.orderStatus,
      'transactionId': instance.transactionId,
      'providerTransactionId': instance.providerTransactionId,
      'deliveryFee': instance.deliveryFee,
      'discount': instance.discount,
      'vendorEarnings': instance.vendorEarnings,
      'refundStatus': instance.refundStatus,
      'refundDate': instance.refundDate?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.paid: 'paid',
  PaymentStatus.partial: 'partial',
  PaymentStatus.refundPending: 'refundPending',
  PaymentStatus.refunded: 'refunded',
  PaymentStatus.failed: 'failed',
};
