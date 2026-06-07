import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_test/serverpod_test.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given User endpoint', (sessionBuilder, endpoints) {
    test(
      'when authenticated then getCurrentUser returns profile',
      () async {
        final setupSession = sessionBuilder.build();
        final authUser = await AuthUsers().create(setupSession);
        await setupSession.close();

        final authenticated = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            authUser.id.toString(),
            {},
          ),
        );

        await endpoints.user.updateProfile(
          authenticated,
          'Anu Budathoki',
          phone: '9800000000',
        );

        final user = await endpoints.user.getCurrentUser(authenticated);

        expect(user, isNotNull);
        expect(user!.name, 'Anu Budathoki');
        expect(user.phone, '9800000000');
        expect(user.authUserId, authUser.id);
      },
    );

    test(
      'when not authenticated then getCurrentUser throws',
      () async {
        await expectLater(
          endpoints.user.getCurrentUser(sessionBuilder),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      },
    );
  });
}
