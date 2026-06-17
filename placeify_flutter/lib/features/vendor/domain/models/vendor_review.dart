final vendorMockReviews = [
  VendorReview(
    id: 'r1',
    customerName: 'Riya Sharma',
    productName: 'Harmony Chair',
    rating: 5,
    comment: 'Beautiful craftsmanship and fast delivery.',
    createdAt: DateTime(2026, 6, 2),
    vendorReply: 'Thank you, Riya! Glad you love it.',
  ),
  VendorReview(
    id: 'r2',
    customerName: 'Samir Thapa',
    productName: 'Brixon Chair',
    rating: 4,
    comment: 'Comfortable and matches the photos. Assembly took a bit longer.',
    createdAt: DateTime(2026, 5, 28),
  ),
  VendorReview(
    id: 'r3',
    customerName: 'Priya Karki',
    productName: 'Astra Chair',
    rating: 5,
    comment: 'Exactly what I needed for my home office.',
    createdAt: DateTime(2026, 5, 20),
  ),
];

class VendorReview {
  const VendorReview({
    required this.id,
    required this.customerName,
    required this.productName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.vendorReply,
  });

  final String id;
  final String customerName;
  final String productName;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final String? vendorReply;
}
