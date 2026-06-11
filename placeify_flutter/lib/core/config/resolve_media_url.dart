import 'resolve_server_url.dart';

/// Web server port for static uploads (see placeify_server development.yaml).
const int _webServerPort = 8082;

/// Builds a full URL for product images stored under `/uploads/...`.
Future<String> resolveMediaUrl(String? path) async {
  if (path == null || path.isEmpty) return '';
  if (path.startsWith('http://') || path.startsWith('https://')) return path;

  final apiBase = await resolveServerUrl();
  final apiUri = Uri.parse(apiBase);
  final webHost = apiUri.host;
  final scheme = apiUri.scheme;

  final normalizedPath = path.startsWith('/') ? path : '/$path';
  return Uri(
    scheme: scheme,
    host: webHost,
    port: _webServerPort,
    path: normalizedPath,
  ).toString();
}
