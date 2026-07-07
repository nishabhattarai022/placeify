import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'resolve_server_platform.dart';

const _cachedServerUrlKey = 'placeify_server_url_v2';
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
  final candidates = await _buildCandidates();
  final configuredPhysical = await _configuredPhysicalApiUrl();

  if (!forceRefresh) {
    final cached = prefs.getString(_cachedServerUrlKey);
    if (cached != null) {
      final normalizedCached = _ensureTrailingSlash(cached);
      final cacheStillConfigured = candidates.contains(normalizedCached);
      final cacheMatchesConfiguredPhysical = _hostsMatch(
        normalizedCached,
        configuredPhysical,
      );

      if (!cacheStillConfigured ||
          (configuredPhysical != null && !cacheMatchesConfiguredPhysical)) {
        await prefs.remove(_cachedServerUrlKey);
      } else if (_cacheMatchesPlatform(cached) &&
          await _canReachServer(cached)) {
        return normalizedCached;
      }
    }
  }

  for (final candidate in candidates) {
    if (await _canReachServer(candidate)) {
      await prefs.setString(_cachedServerUrlKey, candidate);
      return _ensureTrailingSlash(candidate);
    }
  }

  return _ensureTrailingSlash(candidates.first);
}

Future<String?> _configuredPhysicalApiUrl() async {
  try {
    final data = await rootBundle.loadString('assets/config.json');
    final config = jsonDecode(data) as Map<String, dynamic>;
    final physicalApiUrl = config['physicalApiUrl'] as String?;
    if (physicalApiUrl == null || physicalApiUrl.trim().isEmpty) {
      return null;
    }
    return _ensureTrailingSlash(physicalApiUrl.trim());
  } catch (_) {
    return null;
  }
}

bool _hostsMatch(String a, String? b) {
  if (b == null) return true;
  final hostA = Uri.tryParse(a)?.host;
  final hostB = Uri.tryParse(b)?.host;
  if (hostA == null || hostB == null) return true;
  return hostA == hostB;
}

bool _cacheMatchesPlatform(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return false;

  // A desktop/simulator session may cache localhost; phones must re-probe LAN hosts.
  if (uri.host == 'localhost' || uri.host == '127.0.0.1') {
    return !isMobilePlatform;
  }

  return true;
}

Future<List<String>> _buildCandidates() async {
  final physicalApiUrl = <String>[];
  final localApiUrl = <String>[];
  final emulatorApiUrl = <String>[];
  final loopbackApiUrl = <String>[];

  void add(List<String> bucket, String? url) {
    if (url == null || url.trim().isEmpty) return;
    final normalized = _ensureTrailingSlash(url.trim());
    if (!bucket.contains(normalized)) {
      bucket.add(normalized);
    }
  }

  try {
    final data = await rootBundle.loadString('assets/config.json');
    final config = jsonDecode(data) as Map<String, dynamic>;
    add(physicalApiUrl, config['physicalApiUrl'] as String?);

    final apiUrl = config['apiUrl'] as String?;
    if (apiUrl != null && apiUrl.trim().isNotEmpty) {
      add(localApiUrl, _normalizeLoopback(apiUrl.trim()));
    }
  } catch (_) {}

  if (isAndroid) {
    add(emulatorApiUrl, 'http://10.0.2.2:$_defaultPort');
  }

  add(loopbackApiUrl, 'http://$loopbackHost:$_defaultPort');

  final isPhysical = await _isPhysicalMobileDevice();
  if (isPhysical) {
    return [...physicalApiUrl, ...localApiUrl, ...emulatorApiUrl, ...loopbackApiUrl];
  }

  // Emulators/simulators: never probe a stale LAN IP first.
  return [...emulatorApiUrl, ...localApiUrl, ...loopbackApiUrl, ...physicalApiUrl];
}

Future<bool> _isPhysicalMobileDevice() async {
  if (kIsWeb) return false;
  final deviceInfo = DeviceInfoPlugin();
  try {
    if (isAndroid) {
      return (await deviceInfo.androidInfo).isPhysicalDevice;
    }
    if (isIOS) {
      return (await deviceInfo.iosInfo).isPhysicalDevice;
    }
  } catch (_) {}
  return false;
}

Future<bool> _canReachServer(String url) async {
  try {
    final isPhysical = await _isPhysicalMobileDevice();
    final timeout = isPhysical
        ? const Duration(seconds: 8)
        : const Duration(seconds: 3);
    final response = await http
        .get(Uri.parse(_ensureTrailingSlash(url)))
        .timeout(timeout);
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
  return url
      .replaceAll('localhost', loopbackHost)
      .replaceAll('127.0.0.1', loopbackHost);
}

bool _isLoopbackUrl(String url) {
  return url.contains('localhost') || url.contains('127.0.0.1');
}
