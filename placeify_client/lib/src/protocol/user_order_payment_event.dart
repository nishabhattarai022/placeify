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
import 'order_payment_status.dart' as _i2;

/// Vendor-recorded payment status change for a customer order.
abstract class UserOrderPaymentEvent implements _i1.SerializableModel {
  UserOrderPaymentEvent._({
    required this.status,
    this.note,
    required this.createdAt,
  });

  factory UserOrderPaymentEvent({
    required _i2.OrderPaymentStatus status,
    String? note,
    required DateTime createdAt,
  }) = _UserOrderPaymentEventImpl;

  factory UserOrderPaymentEvent.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return UserOrderPaymentEvent(
      status: _i2.OrderPaymentStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      note: jsonSerialization['note'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  _i2.OrderPaymentStatus status;

  String? note;

  DateTime createdAt;

  /// Returns a shallow copy of this [UserOrderPaymentEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserOrderPaymentEvent copyWith({
    _i2.OrderPaymentStatus? status,
    String? note,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserOrderPaymentEvent',
      'status': status.toJson(),
      if (note != null) 'note': note,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserOrderPaymentEventImpl extends UserOrderPaymentEvent {
  _UserOrderPaymentEventImpl({
    required _i2.OrderPaymentStatus status,
    String? note,
    required DateTime createdAt,
  }) : super._(
         status: status,
         note: note,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [UserOrderPaymentEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserOrderPaymentEvent copyWith({
    _i2.OrderPaymentStatus? status,
    Object? note = _Undefined,
    DateTime? createdAt,
  }) {
    return UserOrderPaymentEvent(
      status: status ?? this.status,
      note: note is String? ? note : this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
