import 'dart:io';

import 'package:test/test.dart';

import 'package:placeify_server/src/shared/server_static_paths.dart';

void main() {
  test('resolves web/static with template files', () {
    final root = ServerStaticPaths.root;
    expect(Directory(root).existsSync(), isTrue);
    expect(
      File(ServerStaticPaths.templatePath('chairs.glb')).existsSync(),
      isTrue,
    );
  });
}
