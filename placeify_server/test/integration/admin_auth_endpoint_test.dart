import 'package:placeify_server/src/auth/auth_callbacks.dart';
import 'package:placeify_server/src/generated/protocol.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given AdminAuthEndpoint',
    (sessionBuilder, endpoints) {
      setUpAll(() {
        AuthServices.set(
          tokenManagerBuilders: [
            JwtConfig(
              refreshTokenHashPepper: 'placeify_test_refresh_pepper',
              algorithm: JwtAlgorithm.hmacSha512(
                SecretKey('placeify_test_jwt_private_key'),
              ),
            ),
          ],
          identityProviderBuilders: [
            EmailIdpConfig(
              secretHashPepper: 'placeify_test_email_pepper',
              registrationVerificationCodeGenerator: () => '123456',
              passwordResetVerificationCodeGenerator: () => '123456',
              sendRegistrationVerificationCode:
                  (
                    session, {
                    required email,
                    required accountRequestId,
                    required verificationCode,
                    required transaction,
                  }) async {},
              sendPasswordResetVerificationCode:
                  (
                    session, {
                    required email,
                    required passwordResetRequestId,
                    required verificationCode,
                    required transaction,
                  }) async {},
              onAfterAccountCreated: onAfterAccountCreated,
            ),
          ],
        );
      });

      const adminId = 'admin@placeify.com';
      const adminPassword = 'demo1234';

      test(
        'when correct admin credentials are used then session is admin',
        () async {
          final authSuccess = await endpoints.adminAuth.login(
            sessionBuilder,
            adminId,
            adminPassword,
          );
          expect(authSuccess.token, isNotEmpty);

          final authenticated = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              authSuccess.authUserId.toString(),
              {},
            ),
          );

          final isAdmin = await endpoints.admin.hasAdminProfile(authenticated);
          expect(isAdmin, isTrue);

          final user = await endpoints.user.getCurrentUser(authenticated);
          expect(user?.role, UserRole.admin);
          expect(user?.email?.toLowerCase(), adminId);
        },
      );

      test(
        'when correct credentials are used repeatedly then login is idempotent',
        () async {
          final first = await endpoints.adminAuth.login(
            sessionBuilder,
            adminId,
            adminPassword,
          );
          final second = await endpoints.adminAuth.login(
            sessionBuilder,
            adminId,
            adminPassword,
          );
          expect(first.authUserId, second.authUserId);

          final count = await User.db.count(
            sessionBuilder.build(),
            where: (row) =>
                row.email.equals(adminId) & row.role.equals(UserRole.admin),
          );
          expect(count, 1);
        },
      );

      test(
        'when wrong password is used then no consumer session is created',
        () async {
          await expectLater(
            endpoints.adminAuth.login(
              sessionBuilder,
              adminId,
              'WrongPassword999!',
            ),
            throwsA(isA<PlaceifyException>()),
          );
        },
      );

      test(
        'when non-admin identity is used then login fails',
        () async {
          await expectLater(
            endpoints.adminAuth.login(
              sessionBuilder,
              'consumer@placeify.test',
              adminPassword,
            ),
            throwsA(isA<PlaceifyException>()),
          );
        },
      );

      test(
        'when consumer session calls admin API then it is rejected',
        () async {
          final consumerEmail =
              'consumer-admin-auth-${DateTime.now().microsecondsSinceEpoch}@placeify.test';
          const consumerPassword = 'SecurePass123!';

          final requestId = await endpoints.emailIdp.startRegistration(
            sessionBuilder,
            email: consumerEmail,
          );
          final token = await endpoints.emailIdp.verifyRegistrationCode(
            sessionBuilder,
            accountRequestId: requestId,
            verificationCode: '123456',
          );
          final authSuccess = await endpoints.emailIdp.finishRegistration(
            sessionBuilder,
            registrationToken: token,
            password: consumerPassword,
          );

          final consumerSession = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              authSuccess.authUserId.toString(),
              {},
            ),
          );

          expect(
            await endpoints.admin.hasAdminProfile(consumerSession),
            isFalse,
          );

          await expectLater(
            endpoints.admin.getPlatformStats(consumerSession),
            throwsA(anything),
          );
        },
      );
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
