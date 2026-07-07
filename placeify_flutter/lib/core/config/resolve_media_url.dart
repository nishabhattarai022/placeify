import 'package:placeify_flutter/core/utils/local_image_store.dart';

import 'resolve_server_url.dart';

/// Web server port for static uploads (see placeify_server development.yaml).
const int _webServerPort = 8082;

String? _cachedApiBase;

Future<String> _apiBase() async {
  if (_cachedApiBase != null) return _cachedApiBase!;
  _cachedApiBase = await resolveServerUrl();
  return _cachedApiBase!;
}

/// Clears cached API base (e.g. after [reconnectPlaceifyClient]).
void clearResolvedMediaApiBase() {
  _cachedApiBase = null;
}

/// Builds a full URL for product images stored under `/uploads/...`.
Future<String> resolveMediaUrl(String? path) async {
  if (path == null || path.isEmpty) return '';
  if (path.startsWith('http://') || path.startsWith('https://')) return path;
  if (path.startsWith(LocalImageStore.scheme)) return '';

  final parsed = Uri.parse(path.startsWith('/') ? path : '/$path');
  final apiBase = await _apiBase();
  final apiUri = Uri.parse(apiBase);
  final webHost = apiUri.host;
  final scheme = apiUri.scheme;

  return Uri(
    scheme: scheme,
    host: webHost,
    port: _webServerPort,
    pathSegments: parsed.pathSegments,
    query: parsed.query.isEmpty ? null : parsed.query,
  ).toString();
}
