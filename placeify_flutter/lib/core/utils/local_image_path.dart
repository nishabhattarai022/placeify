import 'dart:io';

/// Helpers for distinguishing local file paths from remote URLs and assets.
abstract final class LocalImagePath {
  static bool isAsset(String source) => source.startsWith('assets/');

  static bool isLocal(String source) {
    if (source.isEmpty) return false;
    if (isAsset(source)) return false;
    if (source.startsWith('http://') || source.startsWith('https://')) {
      return false;
    }
    return true;
  }

  /// Normalizes Windows-style paths for [File] on the current platform.
  static String normalize(String source) {
    if (!Platform.isWindows) return source;
    if (source.startsWith(r'\\')) return source;
    return source.replaceAll('/', r'\');
  }
}
