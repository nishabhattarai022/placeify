import 'dart:io';

import 'package:test/test.dart';

import 'package:placeify_server/src/shared/server_static_paths.dart';

void main() {
  test('resolves web/static uploads directory', () {
    final root = ServerStaticPaths.root;
    expect(Directory(root).existsSync(), isTrue);
    expect(Directory(ServerStaticPaths.uploadsDir()).existsSync(), isTrue);
  });
}
