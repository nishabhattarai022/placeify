import 'dart:typed_data';

String joinPath(String dir, String name) => '$dir/$name';

Future<void> ensureDir(String path) async {}

Future<bool> fileExists(String path) async => false;

Future<void> writeBytes(String path, Uint8List bytes) async {
  throw UnsupportedError('File writes are not supported on web');
}

Future<void> writeString(String path, String contents) async {
  throw UnsupportedError('File writes are not supported on web');
}

Future<String> readString(String path) async {
  throw UnsupportedError('File reads are not supported on web');
}

Future<void> deleteFile(String path) async {}

Future<List<String>> listJpgFileNames(String dirPath) async => const [];

Future<DateTime> modifiedTime(String path) async =>
    DateTime.fromMillisecondsSinceEpoch(0);
