import 'dart:io' show Platform;

import 'package:android_intent_plus/android_intent.dart' as android_intent;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:webview_flutter/webview_flutter.dart';

/// Opens the product GLB in the device AR viewer (Scene Viewer / Quick Look).
abstract final class ArRoomLauncher {
  static Future<bool> launch({
    required String modelSrc,
    WebViewController? webViewController,
  }) async {
    if (kIsWeb) {
      return _activateArInViewer(webViewController);
    }
    if (Platform.isAndroid) {
      final launched = await _launchAndroidSceneViewer(modelSrc);
      if (launched) return true;
      return _activateArInViewer(webViewController);
    }
    if (Platform.isIOS) {
      return _activateArInViewer(webViewController);
    }
    return false;
  }

  static Future<bool> _activateArInViewer(WebViewController? controller) async {
    if (controller == null) return false;
    try {
      await controller.runJavaScript(
        "(() => { const mv = document.querySelector('model-viewer'); "
        "if (mv && typeof mv.activateAR === 'function') { mv.activateAR(); "
        'return true; } return false; })()',
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> _launchAndroidSceneViewer(String modelSrc) async {
    if (!modelSrc.startsWith('http')) return false;
    try {
      final intent = android_intent.AndroidIntent(
        action: 'android.intent.action.VIEW',
        data: Uri(
          scheme: 'https',
          host: 'arvr.google.com',
          path: '/scene-viewer/1.0',
          queryParameters: {'mode': 'ar_preferred', 'file': modelSrc},
        ).toString(),
        package: 'com.google.android.googlequicksearchbox',
      );
      await intent.launch();
      return true;
    } catch (_) {
      return false;
    }
  }
}
