import 'dart:typed_data';

import 'package:ar_flutter_plugin_plus/managers/ar_session_manager.dart';

class ArSnapshotService {
  const ArSnapshotService(this._sessionManager);

  final ARSessionManager _sessionManager;

  static const _captureTimeout = Duration(seconds: 8);

  Future<Uint8List?> capture() async {
    try {
      return await _sessionManager
          .captureSnapshotBytes()
          .timeout(_captureTimeout, onTimeout: () => null);
    } catch (_) {
      return null;
    }
  }
}
