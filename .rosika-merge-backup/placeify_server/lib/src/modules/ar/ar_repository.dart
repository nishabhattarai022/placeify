import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/session_service.dart';
import '../product/product_repository.dart';

class ArSessionStore {
  ArSessionStore({CatalogRepository? productRepository})
      : _productRepository = productRepository ?? CatalogRepository();

  final CatalogRepository _productRepository;

  Future<ARSession> recordSession(
    Session session,
    int productId, {
    String? deviceInfo,
    String? snapshotUrl,
  }) async {
    await _productRepository.requireActiveProduct(session, productId);
    final user = await SessionService.requireUser(session);

    return ARSession.db.insertRow(
      session,
      ARSession(
        userId: user.id!,
        productId: productId,
        deviceInfo: deviceInfo?.trim(),
        snapshotUrl: snapshotUrl?.trim(),
      ),
    );
  }

  Future<List<ARSession>> listSessions(
    Session session, {
    int limit = 20,
    int offset = 0,
  }) async {
    final user = await SessionService.requireUser(session);
    return ARSession.db.find(
      session,
      where: (row) => row.userId.equals(user.id!),
      include: ARSession.include(product: Product.include()),
      orderBy: (row) => row.startedAt,
      orderDescending: true,
      limit: limit,
      offset: offset,
    );
  }

  Future<int> countForUser(Session session, UuidValue userId) {
    return ARSession.db.count(
      session,
      where: (row) => row.userId.equals(userId),
    );
  }
}
