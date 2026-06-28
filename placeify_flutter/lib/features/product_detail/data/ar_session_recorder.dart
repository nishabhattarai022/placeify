import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/config/placeify_server_client.dart';
import '../../cart/data/product_id_codec.dart';

/// Records AR sessions on the backend without blocking the AR UI.
abstract final class ArSessionRecorder {
  static Future<void> recordQuietly(String uiProductId) async {
    if (!client.auth.isAuthenticated) return;

    final productId = ProductIdCodec.toDatabaseId(uiProductId);
    if (productId == null) return;

    try {
      final deviceInfo = kIsWeb ? 'web' : Platform.operatingSystem;
      await client.ar.recordSession(
        productId,
        deviceInfo: deviceInfo,
      );
    } catch (_) {
      // AR history is best-effort; never interrupt the try-in-room flow.
    }
  }
}
