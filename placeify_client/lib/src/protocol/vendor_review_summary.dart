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

/// Product review visible on the vendor dashboard.
abstract class VendorReviewSummary implements _i1.SerializableModel {
  VendorReviewSummary._({
    required this.id,
    required this.customerName,
    required this.productName,
    required this.productId,
    this.thumbnailUrl,
    required this.rating,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VendorReviewSummary({
    required int id,
    required String customerName,
    required String productName,
    required int productId,
    String? thumbnailUrl,
    required int rating,
    String? comment,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _VendorReviewSummaryImpl;

  factory VendorReviewSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return VendorReviewSummary(
      id: jsonSerialization['id'] as int,
      customerName: jsonSerialization['customerName'] as String,
      productName: jsonSerialization['productName'] as String,
      productId: jsonSerialization['productId'] as int,
      thumbnailUrl: jsonSerialization['thumbnailUrl'] as String?,
      rating: jsonSerialization['rating'] as int,
      comment: jsonSerialization['comment'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  int id;

  String customerName;

  String productName;

  int productId;

  String? thumbnailUrl;

  int rating;

  String? comment;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [VendorReviewSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VendorReviewSummary copyWith({
    int? id,
    String? customerName,
    String? productName,
    int? productId,
    String? thumbnailUrl,
    int? rating,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VendorReviewSummary',
      'id': id,
      'customerName': customerName,
      'productName': productName,
      'productId': productId,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      'rating': rating,
      if (comment != null) 'comment': comment,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VendorReviewSummaryImpl extends VendorReviewSummary {
  _VendorReviewSummaryImpl({
    required int id,
    required String customerName,
    required String productName,
    required int productId,
    String? thumbnailUrl,
    required int rating,
    String? comment,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         customerName: customerName,
         productName: productName,
         productId: productId,
         thumbnailUrl: thumbnailUrl,
         rating: rating,
         comment: comment,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [VendorReviewSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VendorReviewSummary copyWith({
    int? id,
    String? customerName,
    String? productName,
    int? productId,
    Object? thumbnailUrl = _Undefined,
    int? rating,
    Object? comment = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VendorReviewSummary(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      productName: productName ?? this.productName,
      productId: productId ?? this.productId,
      thumbnailUrl: thumbnailUrl is String? ? thumbnailUrl : this.thumbnailUrl,
      rating: rating ?? this.rating,
      comment: comment is String? ? comment : this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
