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
import 'delivery_stage.dart' as _i2;

/// Delivery milestone shown in the customer order timeline.
abstract class UserOrderDeliveryEvent implements _i1.SerializableModel {
  UserOrderDeliveryEvent._({
    required this.stage,
    this.note,
    required this.createdAt,
  });

  factory UserOrderDeliveryEvent({
    required _i2.DeliveryStage stage,
    String? note,
    required DateTime createdAt,
  }) = _UserOrderDeliveryEventImpl;

  factory UserOrderDeliveryEvent.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return UserOrderDeliveryEvent(
      stage: _i2.DeliveryStage.fromJson((jsonSerialization['stage'] as String)),
      note: jsonSerialization['note'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  _i2.DeliveryStage stage;

  String? note;

  DateTime createdAt;

  /// Returns a shallow copy of this [UserOrderDeliveryEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserOrderDeliveryEvent copyWith({
    _i2.DeliveryStage? stage,
    String? note,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserOrderDeliveryEvent',
      'stage': stage.toJson(),
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

class _UserOrderDeliveryEventImpl extends UserOrderDeliveryEvent {
  _UserOrderDeliveryEventImpl({
    required _i2.DeliveryStage stage,
    String? note,
    required DateTime createdAt,
  }) : super._(
         stage: stage,
         note: note,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [UserOrderDeliveryEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserOrderDeliveryEvent copyWith({
    _i2.DeliveryStage? stage,
    Object? note = _Undefined,
    DateTime? createdAt,
  }) {
    return UserOrderDeliveryEvent(
      stage: stage ?? this.stage,
      note: note is String? ? note : this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
