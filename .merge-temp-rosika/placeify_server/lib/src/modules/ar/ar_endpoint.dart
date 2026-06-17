import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'ar_service.dart';

/// AR product viewing session tracking.
class ArEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  final _service = ArService();

  Future<ARSession> recordSession(
    Session session,
    int productId, {
    String? deviceInfo,
    String? snapshotUrl,
  }) {
    return _service.recordSession(
      session,
      productId,
      deviceInfo: deviceInfo,
      snapshotUrl: snapshotUrl,
    );
  }

  Future<List<ARSession>> listMySessions(
    Session session, {
    int limit = 20,
    int offset = 0,
  }) {
    return _service.listMySessions(
      session,
      limit: limit,
      offset: offset,
    );
  }
}
