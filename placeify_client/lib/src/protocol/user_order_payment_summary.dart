/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'payment_transaction_status.dart' as _i2;
import 'payment_method.dart' as _i3;

/// Payment snapshot for a customer order.
abstract class UserOrderPaymentSummary implements _i1.SerializableModel {
  UserOrderPaymentSummary._({
    required this.orderId,
    required this.status,
    required this.paymentMethod,
    required this.amount,
    required this.provider,
    this.providerTransactionId,
  });

  factory UserOrderPaymentSummary({
    required int orderId,
    required _i2.PaymentTransactionStatus status,
    required _i3.PaymentMethod paymentMethod,
    required double amount,
    required String provider,
    String? providerTransactionId,
  }) = _UserOrderPaymentSummaryImpl;

  factory UserOrderPaymentSummary.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return UserOrderPaymentSummary(
      orderId: jsonSerialization['orderId'] as int,
      status: _i2.PaymentTransactionStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      paymentMethod: _i3.PaymentMethod.fromJson(
        (jsonSerialization['paymentMethod'] as String),
      ),
      amount: (jsonSerialization['amount'] as num).toDouble(),
      provider: jsonSerialization['provider'] as String,
      providerTransactionId:
          jsonSerialization['providerTransactionId'] as String?,
    );
  }

  int orderId;

  _i2.PaymentTransactionStatus status;

  _i3.PaymentMethod paymentMethod;

  double amount;

  String provider;

  String? providerTransactionId;

  /// Returns a shallow copy of this [UserOrderPaymentSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserOrderPaymentSummary copyWith({
    int? orderId,
    _i2.PaymentTransactionStatus? status,
    _i3.PaymentMethod? paymentMethod,
    double? amount,
    String? provider,
    String? providerTransactionId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserOrderPaymentSummary',
      'orderId': orderId,
      'status': status.toJson(),
      'paymentMethod': paymentMethod.toJson(),
      'amount': amount,
      'provider': provider,
      if (providerTransactionId != null)
        'providerTransactionId': providerTransactionId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserOrderPaymentSummaryImpl extends UserOrderPaymentSummary {
  _UserOrderPaymentSummaryImpl({
    required int orderId,
    required _i2.PaymentTransactionStatus status,
    required _i3.PaymentMethod paymentMethod,
    required double amount,
    required String provider,
    String? providerTransactionId,
  }) : super._(
         orderId: orderId,
         status: status,
         paymentMethod: paymentMethod,
         amount: amount,
         provider: provider,
         providerTransactionId: providerTransactionId,
       );

  /// Returns a shallow copy of this [UserOrderPaymentSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserOrderPaymentSummary copyWith({
    int? orderId,
    _i2.PaymentTransactionStatus? status,
    _i3.PaymentMethod? paymentMethod,
    double? amount,
    String? provider,
    Object? providerTransactionId = _Undefined,
  }) {
    return UserOrderPaymentSummary(
      orderId: orderId ?? this.orderId,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amount: amount ?? this.amount,
      provider: provider ?? this.provider,
      providerTransactionId: providerTransactionId is String?
          ? providerTransactionId
          : this.providerTransactionId,
    );
  }
}
