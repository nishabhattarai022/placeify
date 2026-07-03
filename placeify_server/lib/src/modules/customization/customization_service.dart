import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'customization_store.dart';

class CustomizationService {
  CustomizationService({CustomizationStore? store})
      : _store = store ?? CustomizationStore();

  final CustomizationStore _store;

  Future<CustomizationRequest> createRequest(
    Session session,
    int productId,
    String description, {
    String? attachmentUrl,
  }) {
    return _store.createRequest(
      session,
      productId,
      description,
      attachmentUrl: attachmentUrl,
    );
  }

  Future<List<CustomizationRequest>> listMyRequests(
    Session session, {
    int limit = 20,
    int offset = 0,
  }) {
    return _store.listMyRequests(
      session,
      limit: limit,
      offset: offset,
    );
  }
}
