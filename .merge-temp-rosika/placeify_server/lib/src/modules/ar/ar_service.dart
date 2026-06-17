import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'ar_repository.dart';

class ArService {
  ArService({ArSessionStore? repository})
      : _repository = repository ?? ArSessionStore();

  final ArSessionStore _repository;

  Future<ARSession> recordSession(
    Session session,
    int productId, {
    String? deviceInfo,
    String? snapshotUrl,
  }) {
    return _repository.recordSession(
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
    return _repository.listSessions(
      session,
      limit: limit,
      offset: offset,
    );
  }
}
