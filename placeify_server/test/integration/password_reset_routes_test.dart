import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:placeify_server/src/auth/auth_services_setup.dart';
import 'package:placeify_server/src/auth/password_reset_rate_limiter.dart';
import 'package:placeify_server/src/auth/password_reset_service.dart';
import 'package:placeify_server/src/generated/protocol.dart';
import 'package:placeify_server/src/web/routes/password_reset_routes.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given password reset web routes',
    (sessionBuilder, endpoints) {
      const initialPassword = 'SecurePass123!';
      const newPassword = 'NewSecurePass456!';
      final service = PasswordResetService();

    setUpAll(() async {
      final session = sessionBuilder.build();
      try {
        setupPlaceifyAuthServices(session.serverpod, args: const ['--mode=test']);
        session.serverpod.webServer.addRoute(
          ForgotPasswordRoute(),
          '/auth/forgot-password',
        );
        session.serverpod.webServer.addRoute(
          ResetPasswordRoute(),
          '/auth/reset-password',
        );
        await session.serverpod.webServer.start();
      } finally {
        await session.close();
      }
    });

    tearDownAll(() async {
      final session = sessionBuilder.build();
      try {
        await session.serverpod.webServer.stop();
      } finally {
        await session.close();
      }
    });

    setUp(() {
      PasswordResetRateLimiter.reset();
    });

    Future<Uri> baseUri() async {
      final session = sessionBuilder.build();
      final port = session.serverpod.webServer.port!;
      await session.close();
      return Uri.parse('http://localhost:$port');
    }

    Future<AuthSuccess> registerUser(String email, String password) async {
      final requestId = await endpoints.emailIdp.startRegistration(
        sessionBuilder,
        email: email,
      );
      final registrationToken = await endpoints.emailIdp.verifyRegistrationCode(
        sessionBuilder,
        accountRequestId: requestId,
        verificationCode: '123456',
      );
      return endpoints.emailIdp.finishRegistration(
        sessionBuilder,
        registrationToken: registrationToken,
        password: password,
      );
    }

    Future<User> lookupUserByEmail(String email) async {
      final session = sessionBuilder.build();
      try {
        final account = await EmailAccount.db.findFirstRow(
          session,
          where: (row) => row.email.equals(email.trim().toLowerCase()),
        );
        expect(account, isNotNull);

        final user = await User.db.findFirstRow(
          session,
          where: (row) => row.authUserId.equals(account!.authUserId),
        );
        expect(user, isNotNull);
        return user!;
      } finally {
        await session.close();
      }
    }

    Future<String> seedResetToken(
      User user, {
      bool used = false,
      DateTime? expiresAt,
    }) async {
      final rawToken = service.generateTokenForTests();
      final session = sessionBuilder.build();
      try {
        await PasswordResetToken.db.insertRow(
          session,
          PasswordResetToken(
            userId: user.id!,
            tokenHash: service.hashToken(rawToken),
            expiresAt: expiresAt ?? DateTime.now().toUtc().add(const Duration(minutes: 30)),
            used: used,
          ),
        );
      } finally {
        await session.close();
      }
      return rawToken;
    }

    test('forgot-password returns generic success for non-existent email', () async {
      final response = await http.post(
        (await baseUri()).resolve('/auth/forgot-password'),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({'email': 'missing-${DateTime.now().microsecondsSinceEpoch}@placeify.test'}),
      );

      expect(response.statusCode, 200);
      expect(
        jsonDecode(response.body),
        {'message': PasswordResetService.genericForgotPasswordMessage},
      );
    });

    test('forgot-password creates a reset token for an existing account', () async {
      final email = 'forgot-${DateTime.now().microsecondsSinceEpoch}@placeify.test';
      await registerUser(email, initialPassword);
      final user = await lookupUserByEmail(email);

      final response = await http.post(
        (await baseUri()).resolve('/auth/forgot-password'),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      expect(response.statusCode, 200);

      final session = sessionBuilder.build();
      try {
        final tokens = await PasswordResetToken.db.find(
          session,
          where: (row) => row.userId.equals(user.id!),
        );
        expect(tokens, hasLength(1));
        expect(tokens.single.used, isFalse);
        expect(tokens.single.tokenHash, isNotEmpty);
        expect(tokens.single.expiresAt.isAfter(DateTime.now().toUtc()), isTrue);
      } finally {
        await session.close();
      }
    });

    test('reset-password completes valid flow and invalidates prior refresh tokens', () async {
      final email = 'reset-valid-${DateTime.now().microsecondsSinceEpoch}@placeify.test';
      final auth = await registerUser(email, initialPassword);
      final user = await lookupUserByEmail(email);
      final rawToken = await seedResetToken(user);

      final loginBeforeReset = await endpoints.emailIdp.login(
        sessionBuilder,
        email: email,
        password: initialPassword,
      );

      final response = await http.post(
        (await baseUri()).resolve('/auth/reset-password'),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({'token': rawToken, 'newPassword': newPassword}),
      );

      expect(response.statusCode, 200);
      expect(
        jsonDecode(response.body),
        {'message': PasswordResetService.genericResetPasswordMessage},
      );

      await expectLater(
        endpoints.emailIdp.login(
          sessionBuilder,
          email: email,
          password: initialPassword,
        ),
        throwsA(isA<EmailAccountLoginException>()),
      );

      final loginAfterReset = await endpoints.emailIdp.login(
        sessionBuilder,
        email: email,
        password: newPassword,
      );
      expect(loginAfterReset.token, isNotEmpty);

      final session = sessionBuilder.build();
      try {
        final storedToken = await PasswordResetToken.db.findFirstRow(
          session,
          where: (row) =>
              row.userId.equals(user.id!) &
              row.tokenHash.equals(service.hashToken(rawToken)),
        );
        expect(storedToken, isNotNull);
        expect(storedToken!.used, isTrue);
      } finally {
        await session.close();
      }

      await expectLater(
        endpoints.jwtRefresh.refreshAccessToken(
          sessionBuilder,
          refreshToken: loginBeforeReset.refreshToken!,
        ),
        throwsA(anything),
      );

      expect(auth.authUserId, equals(user.authUserId));
    });

    test('reset-password rejects an expired token with a generic error', () async {
      final email = 'reset-expired-${DateTime.now().microsecondsSinceEpoch}@placeify.test';
      await registerUser(email, initialPassword);
      final user = await lookupUserByEmail(email);
      final rawToken = await seedResetToken(
        user,
        expiresAt: DateTime.now().toUtc().subtract(const Duration(minutes: 1)),
      );

      final response = await http.post(
        (await baseUri()).resolve('/auth/reset-password'),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({'token': rawToken, 'newPassword': newPassword}),
      );

      expect(response.statusCode, 400);
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      expect(body['message'], PasswordResetService.invalidResetTokenMessage);
      expect(body['code'], 'PASSWORD_RESET_INVALID');
    });

    test('reset-password rejects an already-used token with a generic error', () async {
      final email = 'reset-used-${DateTime.now().microsecondsSinceEpoch}@placeify.test';
      await registerUser(email, initialPassword);
      final user = await lookupUserByEmail(email);
      final rawToken = await seedResetToken(user, used: true);

      final response = await http.post(
        (await baseUri()).resolve('/auth/reset-password'),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({'token': rawToken, 'newPassword': newPassword}),
      );

      expect(response.statusCode, 400);
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      expect(body['message'], PasswordResetService.invalidResetTokenMessage);
      expect(body['code'], 'PASSWORD_RESET_INVALID');
    });

    test('reset-password rejects an invalid token with a generic error', () async {
      final response = await http.post(
        (await baseUri()).resolve('/auth/reset-password'),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({
          'token': service.generateTokenForTests(),
          'newPassword': newPassword,
        }),
      );

      expect(response.statusCode, 400);
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      expect(body['message'], PasswordResetService.invalidResetTokenMessage);
      expect(body['code'], 'PASSWORD_RESET_INVALID');
    });
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
