import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Resolves the Serverpod API URL for the current platform.
///
/// `assets/config.json` ships with `localhost`, which does not reach a Mac-hosted
/// server from the Android emulator (`10.0.2.2`) or from a physical device.
Future<String> resolveServerUrl() async {
  const serverUrlFromEnv = String.fromEnvironment('SERVER_URL');
  if (serverUrlFromEnv.isNotEmpty) {
    return _normalizeLoopback(serverUrlFromEnv);
  }

  try {
    final data = await rootBundle.loadString('assets/config.json');
    final config = jsonDecode(data) as Map<String, dynamic>;
    final apiUrl = config['apiUrl'] as String?;
    if (apiUrl != null && apiUrl.isNotEmpty) {
      return _normalizeLoopback(apiUrl);
    }
  } catch (_) {}

  return 'http://$_loopbackHost:8080/';
}

String _normalizeLoopback(String url) {
  if (!_isLoopbackUrl(url)) return url;
  return url
      .replaceAll('localhost', _loopbackHost)
      .replaceAll('127.0.0.1', _loopbackHost);
}

bool _isLoopbackUrl(String url) {
  return url.contains('localhost') || url.contains('127.0.0.1');
}

String get _loopbackHost {
  if (kIsWeb) return 'localhost';

  if (Platform.isAndroid) {
    // Android emulators reach the host machine at 10.0.2.2.
    return '10.0.2.2';
  }

  return 'localhost';
}
