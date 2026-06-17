import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'resolve_server_url_io.dart'
    if (dart.library.html) 'resolve_server_url_web.dart' as io;

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
  int retries = 1,
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

  if (kIsWeb) {
    return uri.host == 'localhost' || uri.host == '127.0.0.1';
  }

  if (uri.host == 'localhost' || uri.host == '127.0.0.1') {
    return !io.isMobilePlatform;
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

  if (kIsWeb || io.isDesktopPlatform) {
    add('http://localhost:$_defaultPort');
  }

  try {
    final data = await rootBundle.loadString('assets/config.json');
    final config = jsonDecode(data) as Map<String, dynamic>;

    final apiUrl = config['apiUrl'] as String?;
    if (apiUrl != null && apiUrl.trim().isNotEmpty) {
      add(_normalizeLoopback(apiUrl.trim()));
    }

    add(config['physicalApiUrl'] as String?);
  } catch (_) {}

  if (io.isAndroid) {
    add('http://10.0.2.2:$_defaultPort');
  }

  if (!kIsWeb) {
    add('http://${io.loopbackHost}:$_defaultPort');
  }

  if (candidates.isEmpty) {
    add('http://localhost:$_defaultPort');
  }

  return candidates;
}

Future<bool> _canReachServer(String url) async {
  try {
    final response = await http
        .get(Uri.parse(_ensureTrailingSlash(url)))
        .timeout(const Duration(seconds: 2));
    return response.statusCode == 200;
  } catch (_) {
    return false;
  }
}

String _ensureTrailingSlash(String url) {
  return url.endsWith('/') ? url : '$url/';
}

String _normalizeLoopback(String url) {
  if (!_isLoopbackUrl(url)) return url;
  final host = kIsWeb ? 'localhost' : io.loopbackHost;
  return url
      .replaceAll('localhost', host)
      .replaceAll('127.0.0.1', host);
}

bool _isLoopbackUrl(String url) {
  return url.contains('localhost') || url.contains('127.0.0.1');
}
