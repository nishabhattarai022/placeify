import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class RoomSnapshot {
  const RoomSnapshot({
    required this.filePath,
    required this.productId,
    required this.productName,
    required this.capturedAt,
  });

  final String filePath;
  final String productId;
  final String productName;
  final DateTime capturedAt;

  Map<String, dynamic> toJson() => {
        'filePath': filePath,
        'productId': productId,
        'productName': productName,
        'capturedAt': capturedAt.toIso8601String(),
      };

  factory RoomSnapshot.fromJson(Map<String, dynamic> json) => RoomSnapshot(
        filePath: json['filePath'] as String,
        productId: json['productId'] as String,
        productName: json['productName'] as String,
        capturedAt: DateTime.parse(json['capturedAt'] as String),
      );
}

class RoomSnapshotStore {
  static const _indexFileName = 'room_snapshots_index.json';

  Future<Directory> _snapshotsDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/room_snapshots');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<String> _uniqueFileName(Directory dir) async {
    final base = DateTime.now().millisecondsSinceEpoch;
    var fileName = '$base.jpg';
    if (!await File('${dir.path}/$fileName').exists()) return fileName;
    final suffix = Random().nextInt(9999).toString().padLeft(4, '0');
    return '${base}_$suffix.jpg';
  }

  Future<RoomSnapshot> save({
    required Uint8List bytes,
    required String productId,
    required String productName,
  }) async {
    final dir = await _snapshotsDir();
    final fileName = await _uniqueFileName(dir);
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);

    final entry = RoomSnapshot(
      filePath: file.path,
      productId: productId,
      productName: productName,
      capturedAt: DateTime.now(),
    );

    final all = await list()..insert(0, entry);
    await _writeIndex(all);
    return entry;
  }

  Future<List<RoomSnapshot>> list() async {
    final dir = await _snapshotsDir();
    final indexFile = File('${dir.path}/$_indexFileName');
    if (!await indexFile.exists()) return [];
    try {
      final raw = jsonDecode(await indexFile.readAsString()) as List;
      return raw
          .map((e) => RoomSnapshot.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> delete(RoomSnapshot snapshot) async {
    final file = File(snapshot.filePath);
    if (await file.exists()) await file.delete();
    final all = await list()
      ..removeWhere((e) => e.filePath == snapshot.filePath);
    await _writeIndex(all);
  }

  Future<void> _writeIndex(List<RoomSnapshot> entries) async {
    final dir = await _snapshotsDir();
    final indexFile = File('${dir.path}/$_indexFileName');
    await indexFile.writeAsString(
      jsonEncode(entries.map((e) => e.toJson()).toList()),
      flush: true,
    );
  }
}
