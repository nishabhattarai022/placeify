import 'dart:typed_data';

import 'package:placeify_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/user_test_helpers.dart';

void main() {
  withServerpod('Profile image upload', (sessionBuilder, endpoints) {
    test('uploadProfileImage stores profileImageUrl for the user', () async {
      final auth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Avatar User',
      );

      final bytes = Uint8List.fromList([
        0x89,
        0x50,
        0x4E,
        0x47,
        0x0D,
        0x0A,
        0x1A,
        0x0A,
        0x00,
        0x00,
        0x00,
        0x0D,
      ]);
      final fileData = ByteData.sublistView(bytes);

      final updated = await endpoints.user.uploadProfileImage(
        auth.session,
        fileData,
        'avatar.png',
      );

      expect(updated.profileImageUrl, isNotNull);
      expect(updated.profileImageUrl, startsWith('/uploads/profiles/'));

      final current = await endpoints.user.getCurrentUser(auth.session);
      expect(current?.profileImageUrl, updated.profileImageUrl);
    });
  });
}
