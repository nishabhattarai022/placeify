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
import 'product_status.dart' as _i2;

/// Vendor product row for admin catalog screens.
abstract class AdminProductSummary implements _i1.SerializableModel {
  AdminProductSummary._({
    required this.productId,
    required this.productName,
    required this.description,
    required this.price,
    this.categoryName,
    this.thumbnailUrl,
    required this.status,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.vendorId,
    required this.shopName,
    required this.ownerName,
    required this.vendorEmail,
    int? complaintCount,
    this.latestComplaintAt,
  }) : complaintCount = complaintCount ?? 0;

  factory AdminProductSummary({
    required int productId,
    required String productName,
    required String description,
    required double price,
    String? categoryName,
    String? thumbnailUrl,
    required _i2.ProductStatus status,
    required bool isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
    required _i1.UuidValue vendorId,
    required String shopName,
    required String ownerName,
    required String vendorEmail,
    int? complaintCount,
    DateTime? latestComplaintAt,
  }) = _AdminProductSummaryImpl;

  factory AdminProductSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminProductSummary(
      productId: jsonSerialization['productId'] as int,
      productName: jsonSerialization['productName'] as String,
      description: jsonSerialization['description'] as String,
      price: (jsonSerialization['price'] as num).toDouble(),
      categoryName: jsonSerialization['categoryName'] as String?,
      thumbnailUrl: jsonSerialization['thumbnailUrl'] as String?,
      status: _i2.ProductStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      isDeleted: _i1.BoolJsonExtension.fromJson(jsonSerialization['isDeleted']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      vendorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['vendorId'],
      ),
      shopName: jsonSerialization['shopName'] as String,
      ownerName: jsonSerialization['ownerName'] as String,
      vendorEmail: jsonSerialization['vendorEmail'] as String,
      complaintCount: jsonSerialization['complaintCount'] as int?,
      latestComplaintAt: jsonSerialization['latestComplaintAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['latestComplaintAt'],
            ),
    );
  }

  int productId;

  String productName;

  String description;

  double price;

  String? categoryName;

  String? thumbnailUrl;

  _i2.ProductStatus status;

  bool isDeleted;

  DateTime createdAt;

  DateTime updatedAt;

  _i1.UuidValue vendorId;

  String shopName;

  String ownerName;

  String vendorEmail;

  int complaintCount;

  DateTime? latestComplaintAt;

  /// Returns a shallow copy of this [AdminProductSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AdminProductSummary copyWith({
    int? productId,
    String? productName,
    String? description,
    double? price,
    String? categoryName,
    String? thumbnailUrl,
    _i2.ProductStatus? status,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    _i1.UuidValue? vendorId,
    String? shopName,
    String? ownerName,
    String? vendorEmail,
    int? complaintCount,
    DateTime? latestComplaintAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminProductSummary',
      'productId': productId,
      'productName': productName,
      'description': description,
      'price': price,
      if (categoryName != null) 'categoryName': categoryName,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      'status': status.toJson(),
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'vendorId': vendorId.toJson(),
      'shopName': shopName,
      'ownerName': ownerName,
      'vendorEmail': vendorEmail,
      'complaintCount': complaintCount,
      if (latestComplaintAt != null)
        'latestComplaintAt': latestComplaintAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminProductSummaryImpl extends AdminProductSummary {
  _AdminProductSummaryImpl({
    required int productId,
    required String productName,
    required String description,
    required double price,
    String? categoryName,
    String? thumbnailUrl,
    required _i2.ProductStatus status,
    required bool isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
    required _i1.UuidValue vendorId,
    required String shopName,
    required String ownerName,
    required String vendorEmail,
    int? complaintCount,
    DateTime? latestComplaintAt,
  }) : super._(
         productId: productId,
         productName: productName,
         description: description,
         price: price,
         categoryName: categoryName,
         thumbnailUrl: thumbnailUrl,
         status: status,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
         vendorId: vendorId,
         shopName: shopName,
         ownerName: ownerName,
         vendorEmail: vendorEmail,
         complaintCount: complaintCount,
         latestComplaintAt: latestComplaintAt,
       );

  /// Returns a shallow copy of this [AdminProductSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AdminProductSummary copyWith({
    int? productId,
    String? productName,
    String? description,
    double? price,
    Object? categoryName = _Undefined,
    Object? thumbnailUrl = _Undefined,
    _i2.ProductStatus? status,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    _i1.UuidValue? vendorId,
    String? shopName,
    String? ownerName,
    String? vendorEmail,
    int? complaintCount,
    Object? latestComplaintAt = _Undefined,
  }) {
    return AdminProductSummary(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      description: description ?? this.description,
      price: price ?? this.price,
      categoryName: categoryName is String? ? categoryName : this.categoryName,
      thumbnailUrl: thumbnailUrl is String? ? thumbnailUrl : this.thumbnailUrl,
      status: status ?? this.status,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      vendorId: vendorId ?? this.vendorId,
      shopName: shopName ?? this.shopName,
      ownerName: ownerName ?? this.ownerName,
      vendorEmail: vendorEmail ?? this.vendorEmail,
      complaintCount: complaintCount ?? this.complaintCount,
      latestComplaintAt: latestComplaintAt is DateTime?
          ? latestComplaintAt
          : this.latestComplaintAt,
    );
  }
}
