import 'package:placeify_flutter/features/admin/domain/models/admin_product_complaint_summary.dart';

class AdminProductSummary {
  const AdminProductSummary({
    required this.productId,
    required this.productName,
    required this.description,
    required this.price,
    required this.status,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.vendorId,
    required this.shopName,
    required this.ownerName,
    required this.vendorEmail,
    this.categoryName,
    this.thumbnailUrl,
    this.complaintCount = 0,
    this.latestComplaintAt,
  });

  final int productId;
  final String productName;
  final String description;
  final double price;
  final String? categoryName;
  final String? thumbnailUrl;
  final String status;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String vendorId;
  final String shopName;
  final String ownerName;
  final String vendorEmail;
  final int complaintCount;
  final DateTime? latestComplaintAt;

  bool get isRemoved => isDeleted || status == 'removed';
}

class AdminProductDetail extends AdminProductSummary {
  const AdminProductDetail({
    required super.productId,
    required super.productName,
    required super.description,
    required super.price,
    required super.status,
    required super.isDeleted,
    required super.createdAt,
    required super.updatedAt,
    required super.vendorId,
    required super.shopName,
    required super.ownerName,
    required super.vendorEmail,
    super.categoryName,
    super.thumbnailUrl,
    super.complaintCount = 0,
    super.latestComplaintAt,
    this.discountPrice,
    this.viewImageUrls = const [],
    this.removedReason,
    this.removedAt,
    this.removedByAdminName,
    this.complaints = const [],
  });

  final double? discountPrice;
  final List<String> viewImageUrls;
  final String? removedReason;
  final DateTime? removedAt;
  final String? removedByAdminName;
  final List<AdminProductComplaintSummary> complaints;
}
