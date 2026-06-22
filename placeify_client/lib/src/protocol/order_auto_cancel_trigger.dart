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

/// Payload for the daily order auto-cancel future call.
abstract class OrderAutoCancelTrigger implements _i1.SerializableModel {
  OrderAutoCancelTrigger._({this.scheduledAt});

  factory OrderAutoCancelTrigger({DateTime? scheduledAt}) =
      _OrderAutoCancelTriggerImpl;

  factory OrderAutoCancelTrigger.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return OrderAutoCancelTrigger(
      scheduledAt: jsonSerialization['scheduledAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['scheduledAt'],
            ),
    );
  }

  DateTime? scheduledAt;

  /// Returns a shallow copy of this [OrderAutoCancelTrigger]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OrderAutoCancelTrigger copyWith({DateTime? scheduledAt});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrderAutoCancelTrigger',
      if (scheduledAt != null) 'scheduledAt': scheduledAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrderAutoCancelTriggerImpl extends OrderAutoCancelTrigger {
  _OrderAutoCancelTriggerImpl({DateTime? scheduledAt})
    : super._(scheduledAt: scheduledAt);

  /// Returns a shallow copy of this [OrderAutoCancelTrigger]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OrderAutoCancelTrigger copyWith({Object? scheduledAt = _Undefined}) {
    return OrderAutoCancelTrigger(
      scheduledAt: scheduledAt is DateTime? ? scheduledAt : this.scheduledAt,
    );
  }
}
