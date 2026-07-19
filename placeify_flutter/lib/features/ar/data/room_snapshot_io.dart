import 'dart:io';
import 'dart:typed_data';

String joinPath(String dir, String name) => '$dir/$name';

Future<void> ensureDir(String path) async {
  final dir = Directory(path);
  if (!await dir.exists()) await dir.create(recursive: true);
}

Future<bool> fileExists(String path) => File(path).exists();

Future<void> writeBytes(String path, Uint8List bytes) async {
  await File(path).writeAsBytes(bytes, flush: true);
}

Future<void> writeString(String path, String contents) async {
  await File(path).writeAsString(contents, flush: true);
}

Future<String> readString(String path) => File(path).readAsString();

Future<void> deleteFile(String path) => File(path).delete();

Future<List<String>> listJpgFileNames(String dirPath) async {
  final dir = Directory(dirPath);
  if (!await dir.exists()) return const [];
  final names = <String>[];
  await for (final entity in dir.list()) {
    if (entity is! File) continue;
    final name = entity.uri.pathSegments.isNotEmpty
        ? entity.uri.pathSegments.last
        : entity.path.split(Platform.pathSeparator).last;
    if (name.toLowerCase().endsWith('.jpg')) names.add(name);
  }
  return names;
}

Future<DateTime> modifiedTime(String path) async {
  return (await File(path).stat()).modified;
}
