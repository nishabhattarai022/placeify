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
import 'product_status.dart' as _i2;
import 'admin_product_complaint_summary.dart' as _i3;
import 'package:placeify_server/src/generated/protocol.dart' as _i4;

/// Full admin view of a vendor product with vendor and complaint context.
abstract class AdminProductDetail
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  AdminProductDetail._({
    required this.productId,
    required this.productName,
    required this.description,
    required this.price,
    this.discountPrice,
    this.categoryName,
    this.thumbnailUrl,
    this.viewImageUrls,
    required this.status,
    required this.isDeleted,
    this.removedReason,
    this.removedAt,
    this.removedByAdminName,
    required this.createdAt,
    required this.updatedAt,
    required this.vendorId,
    required this.shopName,
    required this.ownerName,
    required this.vendorEmail,
    int? complaintCount,
    this.latestComplaintAt,
    required this.complaints,
  }) : complaintCount = complaintCount ?? 0;

  factory AdminProductDetail({
    required int productId,
    required String productName,
    required String description,
    required double price,
    double? discountPrice,
    String? categoryName,
    String? thumbnailUrl,
    List<String>? viewImageUrls,
    required _i2.ProductStatus status,
    required bool isDeleted,
    String? removedReason,
    DateTime? removedAt,
    String? removedByAdminName,
    required DateTime createdAt,
    required DateTime updatedAt,
    required _i1.UuidValue vendorId,
    required String shopName,
    required String ownerName,
    required String vendorEmail,
    int? complaintCount,
    DateTime? latestComplaintAt,
    required List<_i3.AdminProductComplaintSummary> complaints,
  }) = _AdminProductDetailImpl;

  factory AdminProductDetail.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminProductDetail(
      productId: jsonSerialization['productId'] as int,
      productName: jsonSerialization['productName'] as String,
      description: jsonSerialization['description'] as String,
      price: (jsonSerialization['price'] as num).toDouble(),
      discountPrice: (jsonSerialization['discountPrice'] as num?)?.toDouble(),
      categoryName: jsonSerialization['categoryName'] as String?,
      thumbnailUrl: jsonSerialization['thumbnailUrl'] as String?,
      viewImageUrls: jsonSerialization['viewImageUrls'] == null
          ? null
          : _i4.Protocol().deserialize<List<String>>(
              jsonSerialization['viewImageUrls'],
            ),
      status: _i2.ProductStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      isDeleted: _i1.BoolJsonExtension.fromJson(jsonSerialization['isDeleted']),
      removedReason: jsonSerialization['removedReason'] as String?,
      removedAt: jsonSerialization['removedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['removedAt']),
      removedByAdminName: jsonSerialization['removedByAdminName'] as String?,
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
      complaints: _i4.Protocol()
          .deserialize<List<_i3.AdminProductComplaintSummary>>(
            jsonSerialization['complaints'],
          ),
    );
  }

  int productId;

  String productName;

  String description;

  double price;

  double? discountPrice;

  String? categoryName;

  String? thumbnailUrl;

  List<String>? viewImageUrls;

  _i2.ProductStatus status;

  bool isDeleted;

  String? removedReason;

  DateTime? removedAt;

  String? removedByAdminName;

  DateTime createdAt;

  DateTime updatedAt;

  _i1.UuidValue vendorId;

  String shopName;

  String ownerName;

  String vendorEmail;

  int complaintCount;

  DateTime? latestComplaintAt;

  List<_i3.AdminProductComplaintSummary> complaints;

  /// Returns a shallow copy of this [AdminProductDetail]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AdminProductDetail copyWith({
    int? productId,
    String? productName,
    String? description,
    double? price,
    double? discountPrice,
    String? categoryName,
    String? thumbnailUrl,
    List<String>? viewImageUrls,
    _i2.ProductStatus? status,
    bool? isDeleted,
    String? removedReason,
    DateTime? removedAt,
    String? removedByAdminName,
    DateTime? createdAt,
    DateTime? updatedAt,
    _i1.UuidValue? vendorId,
    String? shopName,
    String? ownerName,
    String? vendorEmail,
    int? complaintCount,
    DateTime? latestComplaintAt,
    List<_i3.AdminProductComplaintSummary>? complaints,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminProductDetail',
      'productId': productId,
      'productName': productName,
      'description': description,
      'price': price,
      if (discountPrice != null) 'discountPrice': discountPrice,
      if (categoryName != null) 'categoryName': categoryName,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      if (viewImageUrls != null) 'viewImageUrls': viewImageUrls?.toJson(),
      'status': status.toJson(),
      'isDeleted': isDeleted,
      if (removedReason != null) 'removedReason': removedReason,
      if (removedAt != null) 'removedAt': removedAt?.toJson(),
      if (removedByAdminName != null) 'removedByAdminName': removedByAdminName,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'vendorId': vendorId.toJson(),
      'shopName': shopName,
      'ownerName': ownerName,
      'vendorEmail': vendorEmail,
      'complaintCount': complaintCount,
      if (latestComplaintAt != null)
        'latestComplaintAt': latestComplaintAt?.toJson(),
      'complaints': complaints.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminProductDetail',
      'productId': productId,
      'productName': productName,
      'description': description,
      'price': price,
      if (discountPrice != null) 'discountPrice': discountPrice,
      if (categoryName != null) 'categoryName': categoryName,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      if (viewImageUrls != null) 'viewImageUrls': viewImageUrls?.toJson(),
      'status': status.toJson(),
      'isDeleted': isDeleted,
      if (removedReason != null) 'removedReason': removedReason,
      if (removedAt != null) 'removedAt': removedAt?.toJson(),
      if (removedByAdminName != null) 'removedByAdminName': removedByAdminName,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'vendorId': vendorId.toJson(),
      'shopName': shopName,
      'ownerName': ownerName,
      'vendorEmail': vendorEmail,
      'complaintCount': complaintCount,
      if (latestComplaintAt != null)
        'latestComplaintAt': latestComplaintAt?.toJson(),
      'complaints': complaints.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminProductDetailImpl extends AdminProductDetail {
  _AdminProductDetailImpl({
    required int productId,
    required String productName,
    required String description,
    required double price,
    double? discountPrice,
    String? categoryName,
    String? thumbnailUrl,
    List<String>? viewImageUrls,
    required _i2.ProductStatus status,
    required bool isDeleted,
    String? removedReason,
    DateTime? removedAt,
    String? removedByAdminName,
    required DateTime createdAt,
    required DateTime updatedAt,
    required _i1.UuidValue vendorId,
    required String shopName,
    required String ownerName,
    required String vendorEmail,
    int? complaintCount,
    DateTime? latestComplaintAt,
    required List<_i3.AdminProductComplaintSummary> complaints,
  }) : super._(
         productId: productId,
         productName: productName,
         description: description,
         price: price,
         discountPrice: discountPrice,
         categoryName: categoryName,
         thumbnailUrl: thumbnailUrl,
         viewImageUrls: viewImageUrls,
         status: status,
         isDeleted: isDeleted,
         removedReason: removedReason,
         removedAt: removedAt,
         removedByAdminName: removedByAdminName,
         createdAt: createdAt,
         updatedAt: updatedAt,
         vendorId: vendorId,
         shopName: shopName,
         ownerName: ownerName,
         vendorEmail: vendorEmail,
         complaintCount: complaintCount,
         latestComplaintAt: latestComplaintAt,
         complaints: complaints,
       );

  /// Returns a shallow copy of this [AdminProductDetail]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AdminProductDetail copyWith({
    int? productId,
    String? productName,
    String? description,
    double? price,
    Object? discountPrice = _Undefined,
    Object? categoryName = _Undefined,
    Object? thumbnailUrl = _Undefined,
    Object? viewImageUrls = _Undefined,
    _i2.ProductStatus? status,
    bool? isDeleted,
    Object? removedReason = _Undefined,
    Object? removedAt = _Undefined,
    Object? removedByAdminName = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    _i1.UuidValue? vendorId,
    String? shopName,
    String? ownerName,
    String? vendorEmail,
    int? complaintCount,
    Object? latestComplaintAt = _Undefined,
    List<_i3.AdminProductComplaintSummary>? complaints,
  }) {
    return AdminProductDetail(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      description: description ?? this.description,
      price: price ?? this.price,
      discountPrice: discountPrice is double?
          ? discountPrice
          : this.discountPrice,
      categoryName: categoryName is String? ? categoryName : this.categoryName,
      thumbnailUrl: thumbnailUrl is String? ? thumbnailUrl : this.thumbnailUrl,
      viewImageUrls: viewImageUrls is List<String>?
          ? viewImageUrls
          : this.viewImageUrls?.map((e0) => e0).toList(),
      status: status ?? this.status,
      isDeleted: isDeleted ?? this.isDeleted,
      removedReason: removedReason is String?
          ? removedReason
          : this.removedReason,
      removedAt: removedAt is DateTime? ? removedAt : this.removedAt,
      removedByAdminName: removedByAdminName is String?
          ? removedByAdminName
          : this.removedByAdminName,
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
      complaints:
          complaints ?? this.complaints.map((e0) => e0.copyWith()).toList(),
    );
  }
}
