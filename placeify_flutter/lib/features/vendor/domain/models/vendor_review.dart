class VendorReview {
  const VendorReview({
    required this.id,
    required this.customerName,
    required this.productName,
    required this.productId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
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
  final DateTime updatedAt;
  final String? vendorReply;

  bool get wasEdited =>
      updatedAt.toUtc().difference(createdAt.toUtc()).inSeconds.abs() >= 1;
}
