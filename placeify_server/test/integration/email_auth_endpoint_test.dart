import 'package:placeify_server/src/auth/auth_callbacks.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_test/serverpod_test.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given EmailIdp authentication',
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
              sendRegistrationVerificationCode: (
                session, {
                required email,
                required accountRequestId,
                required verificationCode,
                required transaction,
              }) async {
                session.log(
                  '[test] registration code for $email: $verificationCode',
                );
              },
              sendPasswordResetVerificationCode: (
                session, {
                required email,
                required passwordResetRequestId,
                required verificationCode,
                required transaction,
              }) async {
                session.log(
                  '[test] password reset code for $email: $verificationCode',
                );
              },
              onAfterAccountCreated: onAfterAccountCreated,
            ),
          ],
        );
      });

      const testPassword = 'SecurePass123!';
      const testCode = '123456';

      test(
        'when full registration flow completes then login and profile work',
        () async {
          final testEmail =
              'auth-flow-${DateTime.now().microsecondsSinceEpoch}@placeify.test';

          final requestId = await endpoints.emailIdp.startRegistration(
            sessionBuilder,
            email: testEmail,
          );

          final registrationToken =
              await endpoints.emailIdp.verifyRegistrationCode(
            sessionBuilder,
            accountRequestId: requestId,
            verificationCode: testCode,
          );

          final authSuccess = await endpoints.emailIdp.finishRegistration(
            sessionBuilder,
            registrationToken: registrationToken,
            password: testPassword,
          );

          expect(authSuccess.token, isNotEmpty);
          expect(authSuccess.refreshToken, isNotEmpty);

          final loginResult = await endpoints.emailIdp.login(
            sessionBuilder,
            email: testEmail,
            password: testPassword,
          );
          expect(loginResult.token, isNotEmpty);

          final authenticated = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              authSuccess.authUserId.toString(),
              {},
            ),
          );

          final profile = await endpoints.user.getCurrentUser(authenticated);
          expect(profile, isNotNull);
          expect(profile!.role.name, 'consumer');
        },
      );

      test(
        'when refresh token is used then new access token is issued',
        () async {
          final testEmail =
              'auth-refresh-${DateTime.now().microsecondsSinceEpoch}@placeify.test';

          final requestId = await endpoints.emailIdp.startRegistration(
            sessionBuilder,
            email: testEmail,
          );
          final token = await endpoints.emailIdp.verifyRegistrationCode(
            sessionBuilder,
            accountRequestId: requestId,
            verificationCode: testCode,
          );
          await endpoints.emailIdp.finishRegistration(
            sessionBuilder,
            registrationToken: token,
            password: testPassword,
          );

          final loginResult = await endpoints.emailIdp.login(
            sessionBuilder,
            email: testEmail,
            password: testPassword,
          );

          final refreshToken = loginResult.refreshToken;
          expect(refreshToken, isNotNull);

          final refreshed = await endpoints.jwtRefresh.refreshAccessToken(
            sessionBuilder,
            refreshToken: refreshToken!,
          );

          expect(refreshed.token, isNotEmpty);
          expect(refreshed.refreshToken, isNotEmpty);
        },
      );
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
