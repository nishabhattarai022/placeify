import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Resolves the Serverpod API URL for the current platform.
///
/// `assets/config.json` ships with `localhost`, which works on desktop and on
/// Android emulators (`10.0.2.2`). For a physical phone over Wi‑Fi, set
/// `apiUrl` to your PC's LAN address (e.g. `http://192.168.1.42:8080`).
Future<String> resolveServerUrl() async {
  const serverUrlFromEnv = String.fromEnvironment('SERVER_URL');
  if (serverUrlFromEnv.isNotEmpty) {
    return _normalizeLoopback(serverUrlFromEnv, await _loopbackHost());
  }

  try {
    final data = await rootBundle.loadString('assets/config.json');
    final config = jsonDecode(data) as Map<String, dynamic>;
    final apiUrl = config['apiUrl'] as String?;
    if (apiUrl != null && apiUrl.isNotEmpty) {
      return _normalizeLoopback(apiUrl, await _loopbackHost());
    }
  } catch (_) {}

  final loopbackHost = await _loopbackHost();
  return 'http://$loopbackHost:8080/';
}

String _normalizeLoopback(String url, String loopbackHost) {
  if (!_isLoopbackUrl(url)) return url;
  return url
      .replaceAll('localhost', loopbackHost)
      .replaceAll('127.0.0.1', loopbackHost);
}

bool _isLoopbackUrl(String url) {
  return url.contains('localhost') || url.contains('127.0.0.1');
}

Future<String> _loopbackHost() async {
  if (kIsWeb) return 'localhost';

  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (!androidInfo.isPhysicalDevice) {
      // Android emulators reach the host machine at 10.0.2.2.
      return '10.0.2.2';
    }
  }

  return 'localhost';
}
