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
import 'package:serverpod/serverpod.dart' as _i1;
import 'payment_method.dart' as _i2;

/// Checkout payload from the cart screen.
abstract class CheckoutRequest
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  CheckoutRequest._({
    required this.shippingAddress,
    _i2.PaymentMethod? paymentMethod,
  }) : paymentMethod = paymentMethod ?? _i2.PaymentMethod.mockOnline;

  factory CheckoutRequest({
    required String shippingAddress,
    _i2.PaymentMethod? paymentMethod,
  }) = _CheckoutRequestImpl;

  factory CheckoutRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return CheckoutRequest(
      shippingAddress: jsonSerialization['shippingAddress'] as String,
      paymentMethod: jsonSerialization['paymentMethod'] == null
          ? null
          : _i2.PaymentMethod.fromJson(
              (jsonSerialization['paymentMethod'] as String),
            ),
    );
  }

  String shippingAddress;

  _i2.PaymentMethod paymentMethod;

  /// Returns a shallow copy of this [CheckoutRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CheckoutRequest copyWith({
    String? shippingAddress,
    _i2.PaymentMethod? paymentMethod,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CheckoutRequest',
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CheckoutRequest',
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _CheckoutRequestImpl extends CheckoutRequest {
  _CheckoutRequestImpl({
    required String shippingAddress,
    _i2.PaymentMethod? paymentMethod,
  }) : super._(
         shippingAddress: shippingAddress,
         paymentMethod: paymentMethod,
       );

  /// Returns a shallow copy of this [CheckoutRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CheckoutRequest copyWith({
    String? shippingAddress,
    _i2.PaymentMethod? paymentMethod,
  }) {
    return CheckoutRequest(
      shippingAddress: shippingAddress ?? this.shippingAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}
