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

/// AR session row for the customer profile AR history list.
abstract class UserArSessionSummary implements _i1.SerializableModel {
  UserArSessionSummary._({
    required this.id,
    required this.productId,
    required this.productName,
    required this.startedAt,
    this.deviceInfo,
    this.snapshotUrl,
  });

  factory UserArSessionSummary({
    required int id,
    required int productId,
    required String productName,
    required DateTime startedAt,
    String? deviceInfo,
    String? snapshotUrl,
  }) = _UserArSessionSummaryImpl;

  factory UserArSessionSummary.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return UserArSessionSummary(
      id: jsonSerialization['id'] as int,
      productId: jsonSerialization['productId'] as int,
      productName: jsonSerialization['productName'] as String,
      startedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startedAt'],
      ),
      deviceInfo: jsonSerialization['deviceInfo'] as String?,
      snapshotUrl: jsonSerialization['snapshotUrl'] as String?,
    );
  }

  int id;

  int productId;

  String productName;

  DateTime startedAt;

  String? deviceInfo;

  String? snapshotUrl;

  /// Returns a shallow copy of this [UserArSessionSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserArSessionSummary copyWith({
    int? id,
    int? productId,
    String? productName,
    DateTime? startedAt,
    String? deviceInfo,
    String? snapshotUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserArSessionSummary',
      'id': id,
      'productId': productId,
      'productName': productName,
      'startedAt': startedAt.toJson(),
      if (deviceInfo != null) 'deviceInfo': deviceInfo,
      if (snapshotUrl != null) 'snapshotUrl': snapshotUrl,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserArSessionSummaryImpl extends UserArSessionSummary {
  _UserArSessionSummaryImpl({
    required int id,
    required int productId,
    required String productName,
    required DateTime startedAt,
    String? deviceInfo,
    String? snapshotUrl,
  }) : super._(
         id: id,
         productId: productId,
         productName: productName,
         startedAt: startedAt,
         deviceInfo: deviceInfo,
         snapshotUrl: snapshotUrl,
       );

  /// Returns a shallow copy of this [UserArSessionSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserArSessionSummary copyWith({
    int? id,
    int? productId,
    String? productName,
    DateTime? startedAt,
    Object? deviceInfo = _Undefined,
    Object? snapshotUrl = _Undefined,
  }) {
    return UserArSessionSummary(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      startedAt: startedAt ?? this.startedAt,
      deviceInfo: deviceInfo is String? ? deviceInfo : this.deviceInfo,
      snapshotUrl: snapshotUrl is String? ? snapshotUrl : this.snapshotUrl,
    );
  }
}
