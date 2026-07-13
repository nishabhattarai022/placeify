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

/// Payload for background Tripo 3D model generation.
abstract class Product3dGenerationTrigger implements _i1.SerializableModel {
  Product3dGenerationTrigger._({
    required this.productId,
    this.vendorId,
    this.requestedAt,
  });

  factory Product3dGenerationTrigger({
    required int productId,
    _i1.UuidValue? vendorId,
    DateTime? requestedAt,
  }) = _Product3dGenerationTriggerImpl;

  factory Product3dGenerationTrigger.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return Product3dGenerationTrigger(
      productId: jsonSerialization['productId'] as int,
      vendorId: jsonSerialization['vendorId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['vendorId']),
      requestedAt: jsonSerialization['requestedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['requestedAt'],
            ),
    );
  }

  int productId;

  _i1.UuidValue? vendorId;

  DateTime? requestedAt;

  /// Returns a shallow copy of this [Product3dGenerationTrigger]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Product3dGenerationTrigger copyWith({
    int? productId,
    _i1.UuidValue? vendorId,
    DateTime? requestedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Product3dGenerationTrigger',
      'productId': productId,
      if (vendorId != null) 'vendorId': vendorId?.toJson(),
      if (requestedAt != null) 'requestedAt': requestedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _Product3dGenerationTriggerImpl extends Product3dGenerationTrigger {
  _Product3dGenerationTriggerImpl({
    required int productId,
    _i1.UuidValue? vendorId,
    DateTime? requestedAt,
  }) : super._(
         productId: productId,
         vendorId: vendorId,
         requestedAt: requestedAt,
       );

  /// Returns a shallow copy of this [Product3dGenerationTrigger]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Product3dGenerationTrigger copyWith({
    int? productId,
    Object? vendorId = _Undefined,
    Object? requestedAt = _Undefined,
  }) {
    return Product3dGenerationTrigger(
      productId: productId ?? this.productId,
      vendorId: vendorId is _i1.UuidValue? ? vendorId : this.vendorId,
      requestedAt: requestedAt is DateTime? ? requestedAt : this.requestedAt,
    );
  }
}
