class VendorReview {
  const VendorReview({
    required this.id,
    required this.customerName,
    required this.productName,
    required this.productId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.thumbnailUrl,
    this.vendorReply,
  });

  final String id;
  final String customerName;
  final String productName;
  final String productId;
  final String? thumbnailUrl;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final String? vendorReply;
}
