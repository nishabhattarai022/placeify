import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'customization_service.dart';

/// Consumer customization / design requests for vendor follow-up.
class CustomizationEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  final _service = CustomizationService();

  Future<CustomizationRequest> createRequest(
    Session session,
    int productId,
    String description, {
    String? attachmentUrl,
  }) {
    return _service.createRequest(
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
    return _service.listMyRequests(
      session,
      limit: limit,
      offset: offset,
    );
  }
}
