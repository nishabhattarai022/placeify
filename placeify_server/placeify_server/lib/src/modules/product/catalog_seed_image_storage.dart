import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../../shared/server_static_paths.dart';

/// Copies bundled catalog seed images into `web/static/uploads/catalog-seed/`
/// and returns stable `/uploads/...` paths for [Product.thumbnailUrl].
abstract final class CatalogSeedImageStorage {
  static const uploadSegment = 'catalog-seed';

  static Future<String> resolveUrl(
    Session session,
    String assetFileName,
  ) async {
    final urls = await resolveUrls(session, [assetFileName]);
    return urls.first;
  }

  static Future<List<String>> resolveUrls(
    Session session,
    List<String> assetFileNames,
  ) async {
    final destDir = Directory(
      '${ServerStaticPaths.uploadsDir()}${Platform.pathSeparator}$uploadSegment',
    );
    if (!destDir.existsSync()) {
      destDir.createSync(recursive: true);
    }

    final urls = <String>[];
    for (final fileName in assetFileNames) {
      final source = _sourceFile(fileName);
      if (!source.existsSync()) {
        session.log(
          'Catalog seed image missing: ${source.path}',
          level: LogLevel.warning,
        );
        continue;
      }

      final dest = File(
        '${destDir.path}${Platform.pathSeparator}$fileName',
      );
      // Always refresh uploads from bundled assets so image fixes apply
      // after server restarts (stale files caused duplicate catalog cards).
      await source.copy(dest.path);

      urls.add('/uploads/$uploadSegment/$fileName');
    }

    if (urls.isEmpty) {
      throw StateError(
        'No catalog seed images materialized from $assetFileNames',
      );
    }
    return urls;
  }

  static File _sourceFile(String assetFileName) {
    final assetsDir = _resolveAssetsDir();
    return File(
      '$assetsDir${Platform.pathSeparator}$assetFileName',
    );
  }

  static String _resolveAssetsDir() {
    for (final candidate in _assetsDirCandidates()) {
      if (Directory(candidate).existsSync()) {
        return candidate;
      }
    }
    return _join(Directory.current.path, 'assets', 'catalog_seed');
  }

  static Iterable<String> _assetsDirCandidates() sync* {
    yield _join(Directory.current.path, 'assets', 'catalog_seed');
    yield _join(Directory.current.path, 'placeify_server', 'assets', 'catalog_seed');

    final scriptPath = Platform.script.toFilePath();
    final scriptDir = File(scriptPath).parent.path;
    final scriptName = scriptPath.split(Platform.pathSeparator).last;
    if (scriptName == 'main.dart' && scriptDir.endsWith('bin')) {
      final serverRoot = Directory(scriptDir).parent.path;
      yield _join(serverRoot, 'assets', 'catalog_seed');
    }
  }

  static String _join(String base, String part1, [String? part2, String? part3]) {
    return [base, part1, part2, part3]
        .whereType<String>()
        .join(Platform.pathSeparator);
  }
}
