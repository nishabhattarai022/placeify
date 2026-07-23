import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../../shared/session_service.dart';
import '../notification/in_app_notification_store.dart';

class ReviewStore {
  ReviewStore({InAppNotificationStore? notifications})
      : _notifications = notifications ?? InAppNotificationStore();

  final InAppNotificationStore _notifications;

  Future<Review> submitReview(
    Session session,
    int productId,
    int orderId,
    int rating, {
    String? comment,
  }) async {
    if (rating < 1 || rating > 5) {
      throw PlaceifyException(message: 'Rating must be between 1 and 5.',
        code: 'INVALID_RATING',
      );
    }

    final user = await SessionService.requireUser(session);
    final order = await Order.db.findById(session, orderId);
    if (order == null || order.userId != user.id) {
      throw PlaceifyException(message: 'Order not found.', code: 'ORDER_NOT_FOUND');
    }
    if (order.status != OrderStatus.delivered) {
      throw PlaceifyException(
        message: 'You can only review products after delivery.',
        code: 'ORDER_NOT_DELIVERED',
      );
    }

    final orderItem = await OrderItem.db.findFirstRow(
      session,
      where: (row) =>
          row.orderId.equals(orderId) & row.productId.equals(productId),
    );
    if (orderItem == null) {
      throw PlaceifyException(
        message: 'That product is not part of this order.',
        code: 'PRODUCT_NOT_IN_ORDER',
      );
    }

    final product = await Product.db.findById(
      session,
      productId,
      include: Product.include(vendor: Vendor.include()),
    );
    if (product == null || product.status != ProductStatus.active) {
      throw PlaceifyException(message: 'Product not found.', code: 'PRODUCT_NOT_FOUND');
    }

    final existing = await Review.db.findFirstRow(
      session,
      where: (row) =>
          row.userId.equals(user.id!) &
          row.productId.equals(productId) &
          row.orderId.equals(orderId),
    );
    if (existing != null) {
      throw PlaceifyException(message: 'You already reviewed this order item.',
        code: 'REVIEW_EXISTS',
      );
    }

    final review = await Review.db.insertRow(
      session,
      Review(
        userId: user.id!,
        productId: productId,
        orderId: orderId,
        rating: rating,
        comment: comment?.trim(),
      ),
    );

    await _recalculateVendorRating(session, product.vendorId);

    final vendorUserId = product.vendor?.userId;
    if (vendorUserId != null) {
      await _notifications.create(
        session,
        userId: vendorUserId,
        title: 'New product review',
        message:
            '${user.name} left a $rating-star review on ${product.name}.',
        type: InAppNotificationType.productUpdate,
        referenceId: review.id,
        referenceKey: productId.toString(),
      );
    }

    return review;
  }

  Future<Review?> getMyReviewForOrderItem(
    Session session,
    int productId,
    int orderId,
  ) async {
    final user = await SessionService.requireUser(session);
    return Review.db.findFirstRow(
      session,
      where: (row) =>
          row.userId.equals(user.id!) &
          row.productId.equals(productId) &
          row.orderId.equals(orderId),
    );
  }

  Future<Review> updateReview(
    Session session,
    int reviewId,
    int rating, {
    String? comment,
  }) async {
    if (rating < 1 || rating > 5) {
      throw PlaceifyException(
        message: 'Rating must be between 1 and 5.',
        code: 'INVALID_RATING',
      );
    }

    final user = await SessionService.requireUser(session);
    final existing = await Review.db.findById(session, reviewId);
    if (existing == null || existing.userId != user.id) {
      throw PlaceifyException(
        message: 'Review not found.',
        code: 'REVIEW_NOT_FOUND',
      );
    }

    final order = await Order.db.findById(session, existing.orderId);
    if (order == null || order.userId != user.id) {
      throw PlaceifyException(
        message: 'Order not found.',
        code: 'ORDER_NOT_FOUND',
      );
    }
    if (order.status != OrderStatus.delivered) {
      throw PlaceifyException(
        message: 'You can only review products after delivery.',
        code: 'ORDER_NOT_DELIVERED',
      );
    }

    final updated = await Review.db.updateRow(
      session,
      existing.copyWith(
        rating: rating,
        comment: comment?.trim(),
        updatedAt: DateTime.now().toUtc(),
      ),
    );

    final product = await Product.db.findById(session, existing.productId);
    if (product != null) {
      await _recalculateVendorRating(session, product.vendorId);
    }

    return updated;
  }

  Future<void> deleteReview(Session session, int reviewId) async {
    final user = await SessionService.requireUser(session);
    final existing = await Review.db.findById(session, reviewId);
    if (existing == null || existing.userId != user.id) {
      throw PlaceifyException(
        message: 'Review not found.',
        code: 'REVIEW_NOT_FOUND',
      );
    }

    final productId = existing.productId;
    await Review.db.deleteRow(session, existing);

    final product = await Product.db.findById(session, productId);
    if (product != null) {
      await _recalculateVendorRating(session, product.vendorId);
    }
  }

  Future<void> _recalculateVendorRating(
    Session session,
    UuidValue vendorId,
  ) async {
    final products = await Product.db.find(
      session,
      where: (row) => row.vendorId.equals(vendorId),
    );
    final productIds =
        products.map((p) => p.id).whereType<int>().toSet();
    if (productIds.isEmpty) {
      final vendor = await Vendor.db.findById(session, vendorId);
      if (vendor != null) {
        await Vendor.db.updateRow(session, vendor.copyWith(rating: 0));
      }
      return;
    }

    final reviews = await Review.db.find(
      session,
      where: (row) => row.productId.inSet(productIds),
    );
    final average = reviews.isEmpty
        ? 0.0
        : reviews.fold<double>(0, (sum, r) => sum + r.rating) /
            reviews.length;

    final vendor = await Vendor.db.findById(session, vendorId);
    if (vendor != null) {
      await Vendor.db.updateRow(
        session,
        vendor.copyWith(rating: double.parse(average.toStringAsFixed(2))),
      );
    }
  }

  Future<List<VendorReviewSummary>> listVendorReviews(
    Session session,
    UuidValue vendorId, {
    int limit = 20,
    int offset = 0,
  }) async {
    final products = await Product.db.find(
      session,
      where: (row) => row.vendorId.equals(vendorId),
    );
    final productIds = products.map((product) => product.id).whereType<int>().toList();
    if (productIds.isEmpty) return const [];

    final reviews = await Review.db.find(
      session,
      where: (row) => row.productId.inSet(productIds.toSet()),
      include: Review.include(user: User.include(), product: Product.include()),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
      limit: limit,
      offset: offset,
    );

    return [
      for (final review in reviews)
        if (review.id != null)
          VendorReviewSummary(
            id: review.id!,
            customerName: review.user?.name ?? 'Customer',
            productName: review.product?.name ?? 'Product',
            productId: review.productId,
            thumbnailUrl: review.product?.thumbnailUrl,
            rating: review.rating,
            comment: review.comment,
            createdAt: review.createdAt,
            updatedAt: review.updatedAt,
          ),
    ];
  }

  Future<List<Review>> listProductReviews(
    Session session,
    int productId, {
    int limit = 20,
    int offset = 0,
  }) {
    return Review.db.find(
      session,
      where: (row) => row.productId.equals(productId),
      include: Review.include(user: User.include()),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
      limit: limit,
      offset: offset,
    );
  }
}
