import 'dart:io';

/// Resolves `web/static` regardless of whether the server is started from
/// `placeify_server/` or the monorepo root.
abstract final class ServerStaticPaths {
  static String? _cachedRoot;

  static String get root {
    _cachedRoot ??= _resolveRoot();
    return _cachedRoot!;
  }

  static String _resolveRoot() {
    for (final candidate in _rootCandidates()) {
      if (Directory(candidate).existsSync()) {
        return candidate;
      }
    }
    return _join(Directory.current.path, 'web', 'static');
  }

  static Iterable<String> _rootCandidates() sync* {
    yield _join(Directory.current.path, 'web', 'static');
    yield _join(Directory.current.path, 'placeify_server', 'web', 'static');

    final scriptPath = Platform.script.toFilePath();
    final scriptDir = File(scriptPath).parent.path;
    final scriptName = scriptPath.split(Platform.pathSeparator).last;
    if (scriptName == 'main.dart' && scriptDir.endsWith('bin')) {
      final serverRoot = Directory(scriptDir).parent.path;
      yield _join(serverRoot, 'web', 'static');
    }
  }

  static String uploadsDir() => _join(root, 'uploads');

  static String uploadsModelsDir() => _join(root, 'uploads', 'models');

  static String templatePath(String fileName) =>
      _join(root, 'models', 'templates', fileName);

  static File fileFromUrlPath(String urlPath) {
    final normalized = urlPath.startsWith('/') ? urlPath.substring(1) : urlPath;
    final segments = normalized.split('/').where((s) => s.isNotEmpty);
    return File(_joinAll([root, ...segments]));
  }

  static String _join(String base, String part1,
      [String? part2, String? part3]) {
    return _joinAll([base, part1, part2, part3].whereType<String>());
  }

  static String _joinAll(Iterable<String> parts) {
    return parts.join(Platform.pathSeparator);
  }
}
