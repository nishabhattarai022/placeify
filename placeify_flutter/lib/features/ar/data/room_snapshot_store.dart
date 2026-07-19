import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Conditional: real dart:io on VM/mobile; unused on web (guarded by kIsWeb).
import 'room_snapshot_io.dart' if (dart.library.html) 'room_snapshot_io_stub.dart'
    as io;

class RoomSnapshot {
  const RoomSnapshot({
    required this.fileName,
    required this.filePath,
    required this.productId,
    required this.productName,
    required this.capturedAt,
    this.imageBytes,
  });

  /// Filename only (e.g. `1710000000000.jpg`), stable across iOS container moves.
  final String fileName;

  /// Absolute path on mobile; empty / synthetic key on web.
  final String filePath;
  final String productId;
  final String productName;
  final DateTime capturedAt;

  /// In-memory / web-persisted JPEG bytes (used when [filePath] is not a real file).
  final Uint8List? imageBytes;

  Map<String, dynamic> toJson() => {
        'fileName': fileName,
        'productId': productId,
        'productName': productName,
        'capturedAt': capturedAt.toIso8601String(),
      };

  factory RoomSnapshot.fromJson(
    Map<String, dynamic> json, {
    required String resolvedPath,
    required String fileName,
    Uint8List? imageBytes,
  }) =>
      RoomSnapshot(
        fileName: fileName,
        filePath: resolvedPath,
        productId: '${json['productId'] ?? ''}',
        productName: '${json['productName'] ?? 'Room shot'}',
        capturedAt: DateTime.tryParse('${json['capturedAt'] ?? ''}') ??
            DateTime.fromMillisecondsSinceEpoch(0),
        imageBytes: imageBytes,
      );
}

class RoomSnapshotStore {
  static const _indexFileName = 'room_snapshots_index.json';
  static const _subdir = 'room_snapshots';
  static const _webIndexKey = 'placeify_room_snapshots_index';
  static String _webBytesKey(String fileName) =>
      'placeify_room_snapshot_bytes_$fileName';

  /// Prefer explicit [fileName]; otherwise derive from a legacy absolute [filePath].
  static String? _fileNameFromJson(Map<String, dynamic> json) {
    final named = '${json['fileName'] ?? ''}'.trim();
    if (named.isNotEmpty) return named.replaceAll('\\', '/').split('/').last;

    final legacyPath = '${json['filePath'] ?? ''}'.trim();
    if (legacyPath.isEmpty) return null;
    return legacyPath.replaceAll('\\', '/').split('/').last;
  }

  Future<RoomSnapshot> save({
    required Uint8List bytes,
    required String productId,
    required String productName,
  }) async {
    if (kIsWeb) {
      return _saveWeb(
        bytes: bytes,
        productId: productId,
        productName: productName,
      );
    }
    return _saveIo(
      bytes: bytes,
      productId: productId,
      productName: productName,
    );
  }

  /// Lists saved room shots. Safe on web (SharedPreferences) and mobile (files).
  Future<List<RoomSnapshot>> list({bool includeMissing = false}) async {
    try {
      if (kIsWeb) return _listWeb();
      return _listIo(includeMissing: includeMissing);
    } catch (e, st) {
      debugPrint('RoomSnapshotStore.list failed: $e\n$st');
      return const [];
    }
  }

  Future<void> delete(RoomSnapshot snapshot) async {
    try {
      if (kIsWeb) {
        await _deleteWeb(snapshot);
      } else {
        await _deleteIo(snapshot);
      }
    } catch (e, st) {
      debugPrint('RoomSnapshotStore.delete failed: $e\n$st');
    }
  }

  // --- Web (SharedPreferences) ------------------------------------------------

  Future<RoomSnapshot> _saveWeb({
    required Uint8List bytes,
    required String productId,
    required String productName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}.jpg';
    final entry = RoomSnapshot(
      fileName: fileName,
      filePath: 'web:$fileName',
      productId: productId,
      productName: productName,
      capturedAt: DateTime.now(),
      imageBytes: bytes,
    );

    final all = await _listWeb()..insert(0, entry);
    await prefs.setString(_webBytesKey(fileName), base64Encode(bytes));
    await _writeWebIndex(prefs, all);
    return entry;
  }

  Future<List<RoomSnapshot>> _listWeb() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_webIndexKey);
    if (raw == null || raw.isEmpty) return const [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];

      final parsed = <RoomSnapshot>[];
      for (final item in decoded) {
        if (item is! Map) continue;
        final json = Map<String, dynamic>.from(item);
        final fileName = _fileNameFromJson(json);
        if (fileName == null || fileName.isEmpty) continue;

        final b64 = prefs.getString(_webBytesKey(fileName));
        Uint8List? bytes;
        if (b64 != null && b64.isNotEmpty) {
          try {
            bytes = base64Decode(b64);
          } catch (_) {}
        }
        if (bytes == null || bytes.isEmpty) continue;

        parsed.add(
          RoomSnapshot.fromJson(
            json,
            fileName: fileName,
            resolvedPath: 'web:$fileName',
            imageBytes: bytes,
          ),
        );
      }
      return parsed;
    } catch (e, st) {
      debugPrint('RoomSnapshotStore._listWeb parse failed: $e\n$st');
      return const [];
    }
  }

  Future<void> _deleteWeb(RoomSnapshot snapshot) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_webBytesKey(snapshot.fileName));
    final all = await _listWeb()
      ..removeWhere((e) => e.fileName == snapshot.fileName);
    await _writeWebIndex(prefs, all);
  }

  Future<void> _writeWebIndex(
    SharedPreferences prefs,
    List<RoomSnapshot> entries,
  ) async {
    await prefs.setString(
      _webIndexKey,
      jsonEncode(entries.map((e) => e.toJson()).toList()),
    );
  }

  // --- Mobile / desktop (dart:io) --------------------------------------------

  Future<RoomSnapshot> _saveIo({
    required Uint8List bytes,
    required String productId,
    required String productName,
  }) async {
    final dir = await _snapshotsDir();
    final fileName = await _uniqueFileName(dir);
    final filePath = io.joinPath(dir, fileName);
    await io.writeBytes(filePath, bytes);

    final entry = RoomSnapshot(
      fileName: fileName,
      filePath: filePath,
      productId: productId,
      productName: productName,
      capturedAt: DateTime.now(),
    );

    final all = await list(includeMissing: true)..insert(0, entry);
    await _writeIndex(all);
    return entry;
  }

  Future<List<RoomSnapshot>> _listIo({bool includeMissing = false}) async {
    final dir = await _snapshotsDir();
    final indexPath = io.joinPath(dir, _indexFileName);

    List<RoomSnapshot> fromIndex = const [];
    if (await io.fileExists(indexPath)) {
      try {
        final decoded = jsonDecode(await io.readString(indexPath));
        if (decoded is List) {
          final parsed = <RoomSnapshot>[];
          for (final item in decoded) {
            if (item is! Map) continue;
            final json = Map<String, dynamic>.from(item);
            final fileName = _fileNameFromJson(json);
            if (fileName == null || fileName.isEmpty) continue;
            if (fileName == _indexFileName) continue;
            parsed.add(
              RoomSnapshot.fromJson(
                json,
                fileName: fileName,
                resolvedPath: io.joinPath(dir, fileName),
              ),
            );
          }
          fromIndex = parsed;
        }
      } catch (e, st) {
        debugPrint('RoomSnapshotStore.list index parse failed: $e\n$st');
      }
    }

    if (fromIndex.isEmpty) {
      fromIndex = await _recoverFromDirectory(dir);
      if (fromIndex.isNotEmpty) {
        await _writeIndex(fromIndex);
      }
    }

    if (includeMissing) return fromIndex;

    final existing = <RoomSnapshot>[];
    for (final entry in fromIndex) {
      if (await io.fileExists(entry.filePath)) {
        existing.add(entry);
      }
    }
    return existing;
  }

  Future<String> _snapshotsDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dirPath = '${docs.path}/$_subdir';
    await io.ensureDir(dirPath);
    return dirPath;
  }

  Future<String> _uniqueFileName(String dir) async {
    final base = DateTime.now().millisecondsSinceEpoch;
    var fileName = '$base.jpg';
    if (!await io.fileExists(io.joinPath(dir, fileName))) return fileName;
    final suffix = Random().nextInt(9999).toString().padLeft(4, '0');
    return '${base}_$suffix.jpg';
  }

  Future<List<RoomSnapshot>> _recoverFromDirectory(String dir) async {
    try {
      final names = await io.listJpgFileNames(dir);
      names.sort((a, b) => b.compareTo(a));
      return [
        for (final name in names)
          RoomSnapshot(
            fileName: name,
            filePath: io.joinPath(dir, name),
            productId: '',
            productName: 'Room shot',
            capturedAt: await io.modifiedTime(io.joinPath(dir, name)),
          ),
      ];
    } catch (e, st) {
      debugPrint('RoomSnapshotStore recover failed: $e\n$st');
      return const [];
    }
  }

  Future<void> _deleteIo(RoomSnapshot snapshot) async {
    if (await io.fileExists(snapshot.filePath)) {
      await io.deleteFile(snapshot.filePath);
    }
    final all = await list(includeMissing: true)
      ..removeWhere(
        (e) =>
            e.fileName == snapshot.fileName || e.filePath == snapshot.filePath,
      );
    await _writeIndex(all);
  }

  Future<void> _writeIndex(List<RoomSnapshot> entries) async {
    final dir = await _snapshotsDir();
    final indexPath = io.joinPath(dir, _indexFileName);
    await io.writeString(
      indexPath,
      jsonEncode(entries.map((e) => e.toJson()).toList()),
    );
  }
}
