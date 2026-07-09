import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';
import '../../shared/session_service.dart';

class CustomizationStore {
  Future<CustomizationRequest> createRequest(
    Session session,
    int productId,
    String description, {
    String? attachmentUrl,
  }) async {
    final trimmedDescription = description.trim();
    if (trimmedDescription.isEmpty) {
      throw PlaceifyException(
        message: 'Describe the customization you need.',
        code: 'INVALID_DESCRIPTION',
      );
    }

    final user = await SessionService.requireUser(session);
    final product = await Product.db.findById(session, productId);
    if (product == null || product.status != ProductStatus.active) {
      throw PlaceifyException(
        message: 'Product not found.',
        code: 'PRODUCT_NOT_FOUND',
      );
    }

    return CustomizationRequest.db.insertRow(
      session,
      CustomizationRequest(
        userId: user.id!,
        vendorId: product.vendorId,
        productId: productId,
        description: trimmedDescription,
        attachmentUrl: attachmentUrl?.trim(),
        status: RequestStatus.pending,
      ),
    );
  }

  Future<List<CustomizationRequest>> listMyRequests(
    Session session, {
    int limit = 20,
    int offset = 0,
  }) async {
    final user = await SessionService.requireUser(session);
    return CustomizationRequest.db.find(
      session,
      where: (row) => row.userId.equals(user.id!),
      include: CustomizationRequest.include(
        product: Product.include(),
        vendor: Vendor.include(),
      ),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
      limit: limit,
      offset: offset,
    );
  }
}
