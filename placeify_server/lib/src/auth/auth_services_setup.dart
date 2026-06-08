import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import 'auth_callbacks.dart';
import '../email/email_service.dart';

/// Registers JWT + email identity provider auth on [pod].
/// Called from [run] and from integration tests.
void setupPlaceifyAuthServices(Serverpod pod, {List<String> args = const []}) {
  pod.initializeAuthServices(
    tokenManagerBuilders: [
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      EmailIdpConfigFromPasswords(
        sendRegistrationVerificationCode: sendRegistrationVerificationCode,
        sendPasswordResetVerificationCode: sendPasswordResetVerificationCode,
        onAfterAccountCreated: onAfterAccountCreated,
        registrationVerificationCodeGenerator: verificationCodeGenerator(args),
        passwordResetVerificationCodeGenerator: verificationCodeGenerator(args),
      ),
    ],
  );
}

/// Fixed codes in test mode so integration tests can complete registration.
String Function() verificationCodeGenerator(List<String> args) {
  if (_isTestMode(args)) {
    return () => '123456';
  }
  return defaultVerificationCodeGenerator;
}

bool _isTestMode(List<String> args) {
  return args.contains('--mode=test') ||
      args.any((arg) => arg.startsWith('--mode') && arg.contains('test'));
}

Future<void> sendRegistrationVerificationCode(
  Session session, {
  required String email,
  required UuidValue accountRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) async {
  await EmailService.sendAuthCodeEmail(
    session,
    to: email,
    subject: 'Verify your Placeify account',
    code: verificationCode,
    purpose:
        'Welcome to Placeify! Verify your email to finish creating your account.',
  );
}

Future<void> sendPasswordResetVerificationCode(
  Session session, {
  required String email,
  required UuidValue passwordResetRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) async {
  await EmailService.sendAuthCodeEmail(
    session,
    to: email,
    subject: 'Reset your Placeify password',
    code: verificationCode,
    purpose: 'Use this code to reset your Placeify password.',
  );
}
