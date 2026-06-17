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

/// Checkout payload from the cart screen.
abstract class CheckoutRequest
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  CheckoutRequest._({required this.shippingAddress});

  factory CheckoutRequest({required String shippingAddress}) =
      _CheckoutRequestImpl;

  factory CheckoutRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return CheckoutRequest(
      shippingAddress: jsonSerialization['shippingAddress'] as String,
    );
  }

  String shippingAddress;

  /// Returns a shallow copy of this [CheckoutRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CheckoutRequest copyWith({String? shippingAddress});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CheckoutRequest',
      'shippingAddress': shippingAddress,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CheckoutRequest',
      'shippingAddress': shippingAddress,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _CheckoutRequestImpl extends CheckoutRequest {
  _CheckoutRequestImpl({required String shippingAddress})
    : super._(shippingAddress: shippingAddress);

  /// Returns a shallow copy of this [CheckoutRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CheckoutRequest copyWith({String? shippingAddress}) {
    return CheckoutRequest(
      shippingAddress: shippingAddress ?? this.shippingAddress,
    );
  }
}
