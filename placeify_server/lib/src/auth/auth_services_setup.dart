import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import 'auth_callbacks.dart';
import 'email_verification_service.dart';
import '../email/email_service.dart';

/// Registers JWT + email identity provider auth on [pod].
/// Called from [run] and from integration tests.
void setupPlaceifyAuthServices(Serverpod pod, {List<String> args = const []}) {
  final fixedVerificationCode = verificationCodeGenerator(pod, args);

  pod.initializeAuthServices(
    tokenManagerBuilders: [
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      EmailIdpConfigFromPasswords(
        sendRegistrationVerificationCode: sendRegistrationVerificationCode,
        sendPasswordResetVerificationCode: sendPasswordResetVerificationCode,
        onAfterAccountCreated: onAfterAccountCreated,
        registrationVerificationCodeGenerator: fixedVerificationCode,
        passwordResetVerificationCodeGenerator: fixedVerificationCode,
      ),
    ],
  );
}

/// Fixed codes in test/development so registration works without a verification UI.
String Function() verificationCodeGenerator(Serverpod pod, List<String> args) {
  if (_isTestMode(args) || pod.runMode == ServerpodRunMode.development) {
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
  // Magic link completes Email IDP verify+finish. OTP stays in the pending
  // row for Serverpod's verifyRegistrationCode.
  await EmailVerificationService().issueMagicLink(
    session,
    email: email,
    accountRequestId: accountRequestId,
    verificationCode: verificationCode,
    transaction: transaction,
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
