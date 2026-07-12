import 'resolve_server_url.dart';

/// Web server port for static uploads (see placeify_server development.yaml).
const int _webServerPort = 8082;

/// Bump when catalog-seed image bytes change so [CachedNetworkImage] refetches.
const String _catalogSeedCacheBust = '20260712c';

/// Builds a full URL for product images stored under `/uploads/...`.
Future<String> resolveMediaUrl(String? path) async {
  if (path == null || path.isEmpty) return '';
  if (path.startsWith('http://') || path.startsWith('https://')) return path;

  final apiBase = await resolveServerUrl();
  final apiUri = Uri.parse(apiBase);
  final webHost = apiUri.host;
  final scheme = apiUri.scheme;

  final segments = path
      .split('/')
      .where((segment) => segment.isNotEmpty)
      .toList();
  final isCatalogSeed =
      segments.length >= 2 &&
      segments[0] == 'uploads' &&
      segments[1] == 'catalog-seed';
  return Uri(
    scheme: scheme,
    host: webHost,
    port: _webServerPort,
    pathSegments: segments,
    queryParameters: isCatalogSeed ? {'v': _catalogSeedCacheBust} : null,
  ).toString();
}
