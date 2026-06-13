import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _cachedServerUrlKey = 'placeify_server_url';
const _defaultPort = 8080;

/// Clears a previously cached API base URL (e.g. after a connection failure).
Future<void> clearCachedServerUrl() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_cachedServerUrlKey);
}

/// Resolves the Serverpod API URL for the current platform.
///
/// Probes several candidates (LAN IP, Android emulator host, localhost) and
/// caches the first URL that responds. Retries when [retries] > 0 so the app
/// can outlive a server that starts slightly after Flutter.
Future<String> resolveServerUrl({
  bool forceRefresh = false,
  int retries = 2,
}) async {
  const serverUrlFromEnv = String.fromEnvironment('SERVER_URL');
  if (serverUrlFromEnv.isNotEmpty) {
    return _ensureTrailingSlash(_normalizeLoopback(serverUrlFromEnv));
  }

  for (var attempt = 0; attempt <= retries; attempt++) {
    final resolved = await _resolveOnce(forceRefresh: forceRefresh || attempt > 0);
    if (await _canReachServer(resolved)) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cachedServerUrlKey, resolved);
      return _ensureTrailingSlash(resolved);
    }

    if (attempt < retries) {
      await Future<void>.delayed(const Duration(seconds: 2));
    }
  }

  final fallback = (await _buildCandidates()).first;
  return _ensureTrailingSlash(fallback);
}

Future<String> _resolveOnce({required bool forceRefresh}) async {
  final prefs = await SharedPreferences.getInstance();

  if (!forceRefresh) {
    final cached = prefs.getString(_cachedServerUrlKey);
    if (cached != null &&
        _cacheMatchesPlatform(cached) &&
        await _canReachServer(cached)) {
      return _ensureTrailingSlash(cached);
    }
  }

  for (final candidate in await _buildCandidates()) {
    if (await _canReachServer(candidate)) {
      await prefs.setString(_cachedServerUrlKey, candidate);
      return _ensureTrailingSlash(candidate);
    }
  }

  return _ensureTrailingSlash((await _buildCandidates()).first);
}

bool _cacheMatchesPlatform(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return false;

  // A desktop/simulator session may cache localhost; phones must re-probe LAN hosts.
  if (uri.host == 'localhost' || uri.host == '127.0.0.1') {
    return !(Platform.isAndroid || Platform.isIOS);
  }

  return true;
}

Future<List<String>> _buildCandidates() async {
  final candidates = <String>[];

  void add(String? url) {
    if (url == null || url.trim().isEmpty) return;
    final normalized = _ensureTrailingSlash(url.trim());
    if (!candidates.contains(normalized)) {
      candidates.add(normalized);
    }
  }

  try {
    final data = await rootBundle.loadString('assets/config.json');
    final config = jsonDecode(data) as Map<String, dynamic>;
    add(config['physicalApiUrl'] as String?);

    final apiUrl = config['apiUrl'] as String?;
    if (apiUrl != null && apiUrl.trim().isNotEmpty) {
      add(_normalizeLoopback(apiUrl.trim()));
    }
  } catch (_) {}

  if (Platform.isAndroid) {
    add('http://10.0.2.2:$_defaultPort');
  }

  add('http://$_desktopLoopbackHost:$_defaultPort');
  return candidates;
}

Future<bool> _canReachServer(String url) async {
  final client = HttpClient();
  client.connectionTimeout = const Duration(seconds: 3);
  try {
    final request = await client.getUrl(Uri.parse(_ensureTrailingSlash(url)));
    final response = await request.close();
    await response.drain<void>();
    return response.statusCode == 200;
  } catch (_) {
    return false;
  } finally {
    client.close(force: true);
  }
}

String _ensureTrailingSlash(String url) {
  return url.endsWith('/') ? url : '$url/';
}

String _normalizeLoopback(String url) {
  if (!_isLoopbackUrl(url)) return url;
  return url
      .replaceAll('localhost', _desktopLoopbackHost)
      .replaceAll('127.0.0.1', _desktopLoopbackHost);
}

bool _isLoopbackUrl(String url) {
  return url.contains('localhost') || url.contains('127.0.0.1');
}

String get _desktopLoopbackHost {
  if (kIsWeb) return 'localhost';
  if (Platform.isAndroid) return '10.0.2.2';
  return 'localhost';
}
