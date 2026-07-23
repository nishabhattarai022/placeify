import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../email/email_service.dart';
import '../generated/protocol.dart';
import 'password_reset_rate_limiter.dart';

/// Completes Serverpod Email IDP registration via a password-reset-style
/// magic link. Does not replace Email IDP — it bridges link click →
/// verifyRegistrationCode → finishRegistration.
class EmailVerificationService {
  static const successMessage =
      'Your email has been verified successfully. Your Placeify account is now active.';
  static const genericResendMessage =
      'If an unverified account exists for this email address, a new verification link has been sent.';
  static const invalidTokenMessage =
      'This verification link is invalid. Request a new one.';
  static const expiredTokenMessage =
      'This verification link has expired. Request a new one.';

  static const _defaultTokenExpiry = Duration(hours: 24);
  static const _defaultFrontendUrl = 'http://localhost:8082';

  /// Called from [sendRegistrationVerificationCode] to issue a magic link.
  Future<void> issueMagicLink(
    Session session, {
    required String email,
    required UuidValue accountRequestId,
    required String verificationCode,
    Transaction? transaction,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final now = DateTime.now().toUtc();
    final tokenExpiry = _resolveTokenExpiry(session);

    // Invalidate previous unused links for this email so only the newest works.
    final previous = await EmailVerificationPending.db.find(
      session,
      where: (row) =>
          row.email.equals(normalizedEmail) & row.used.equals(false),
      transaction: transaction,
    );
    for (final row in previous) {
      await EmailVerificationPending.db.updateRow(
        session,
        row.copyWith(used: true),
        transaction: transaction,
      );
    }

    final rawToken = _generateRawToken();
    await EmailVerificationPending.db.insertRow(
      session,
      EmailVerificationPending(
        email: normalizedEmail,
        accountRequestId: accountRequestId,
        verificationCode: verificationCode,
        tokenHash: hashToken(rawToken),
        expiresAt: now.add(tokenExpiry),
      ),
      transaction: transaction,
    );

    final verifyUrl = _buildVerifyUrl(session, rawToken);
    session.log(
      '[EmailVerification] Link for $normalizedEmail: $verifyUrl',
      level: LogLevel.info,
    );
    await EmailService.sendVerificationLinkEmail(
      session,
      to: normalizedEmail,
      verifyUrl: verifyUrl,
    );

  }

  Future<Map<String, Object?>> verifyEmail(
    Session session, {
    required String token,
    required String password,
    String? fullName,
  }) async {
    final normalizedToken = token.trim();
    if (normalizedToken.isEmpty) {
      throw const EmailVerificationHttpException(
        statusCode: 400,
        message: 'Token is required.',
        code: 'TOKEN_REQUIRED',
      );
    }

    final emailIdp = AuthServices.instance.emailIdp;
    if (!emailIdp.config.passwordValidationFunction(password)) {
      throw const EmailVerificationHttpException(
        statusCode: 400,
        message:
            'Password is too weak. Use at least 8 characters with letters and numbers.',
        code: 'PASSWORD_POLICY_VIOLATION',
      );
    }

    final tokenHash = hashToken(normalizedToken);
    final now = DateTime.now().toUtc();

    final pending = await EmailVerificationPending.db.findFirstRow(
      session,
      where: (row) =>
          row.tokenHash.equals(tokenHash) & row.used.equals(false),
    );

    if (pending == null) {
      throw const EmailVerificationHttpException(
        statusCode: 400,
        message: invalidTokenMessage,
        code: 'INVALID_TOKEN',
      );
    }

    if (!pending.expiresAt.isAfter(now)) {
      await EmailVerificationPending.db.updateRow(
        session,
        pending.copyWith(used: true),
      );
      throw const EmailVerificationHttpException(
        statusCode: 410,
        message: expiredTokenMessage,
        code: 'TOKEN_EXPIRED',
      );
    }

    late final String registrationToken;
    try {
      registrationToken = await emailIdp.verifyRegistrationCode(
        session,
        accountRequestId: pending.accountRequestId,
        verificationCode: pending.verificationCode,
      );
    } catch (_) {
      throw const EmailVerificationHttpException(
        statusCode: 400,
        message: invalidTokenMessage,
        code: 'INVALID_TOKEN',
      );
    }

    late final AuthSuccess authSuccess;
    try {
      authSuccess = await emailIdp.finishRegistration(
        session,
        registrationToken: registrationToken,
        password: password,
      );
    } catch (error) {
      throw EmailVerificationHttpException(
        statusCode: 400,
        message: 'Could not complete registration. $error',
        code: 'REGISTRATION_FAILED',
      );
    }

    // Do not leave the user signed-in from the verify click.
    await AuthServices.instance.tokenManager.revokeAllTokens(
      session,
      authUserId: authSuccess.authUserId,
      method: EmailIdp.method,
    );

    final trimmedName = fullName?.trim();
    if (trimmedName != null && trimmedName.isNotEmpty) {
      final user = await User.db.findFirstRow(
        session,
        where: (row) => row.authUserId.equals(authSuccess.authUserId),
      );
      if (user != null) {
        await User.db.updateRow(
          session,
          user.copyWith(name: trimmedName, updatedAt: DateTime.now()),
        );
      }
    }

    await EmailVerificationPending.db.updateRow(
      session,
      pending.copyWith(used: true),
    );

    // Invalidate any other unused links for this email.
    final leftovers = await EmailVerificationPending.db.find(
      session,
      where: (row) =>
          row.email.equals(pending.email) &
          row.used.equals(false) &
          row.id.notEquals(pending.id),
    );
    for (final row in leftovers) {
      await EmailVerificationPending.db.updateRow(
        session,
        row.copyWith(used: true),
      );
    }


    return {
      'message': successMessage,
      'code': 'EMAIL_VERIFIED',
    };
  }

  Future<Map<String, Object?>> resendVerification(
    Session session, {
    required String email,
    required String ipAddress,
  }) async {
    final normalizedEmail = _validateEmail(email);

    final allowed = PasswordResetRateLimiter.allow(
      ipAddress: ipAddress,
      email: normalizedEmail,
    );
    if (!allowed) {
      throw const EmailVerificationHttpException(
        statusCode: 429,
        message: 'Too many requests. Please try again later.',
        code: 'RATE_LIMITED',
      );
    }

    final emailIdp = AuthServices.instance.emailIdp;
    final existing = await emailIdp.admin.findAccount(
      session,
      email: normalizedEmail,
    );
    if (existing != null) {
      // Already a finished Placeify auth account — do not hint existence.
      return {'message': genericResendMessage};
    }

    try {
      await emailIdp.startRegistration(
        session,
        email: normalizedEmail,
      );
    } catch (_) {
      // Generic response even on IDP errors (enumeration-safe).
    }

    return {'message': genericResendMessage};
  }

  String hashToken(String rawToken) {
    return sha256.convert(utf8.encode(rawToken)).toString();
  }

  String _validateEmail(String email) {
    final normalized = email.trim().toLowerCase();
    final valid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(normalized);
    if (!valid) {
      throw const EmailVerificationHttpException(
        statusCode: 400,
        message: 'A valid email address is required.',
        code: 'INVALID_EMAIL',
      );
    }
    return normalized;
  }

  Duration _resolveTokenExpiry(Session session) {
    final raw = session.passwords['emailVerificationTokenExpiry']?.trim();
    if (raw == null || raw.isEmpty) return _defaultTokenExpiry;
    final hours = int.tryParse(raw);
    if (hours == null || hours <= 0) return _defaultTokenExpiry;
    return Duration(hours: hours);
  }

  String _buildVerifyUrl(Session session, String rawToken) {
    final configured = session.passwords['frontendUrl']?.trim();
    final envUrl = const String.fromEnvironment('FRONTEND_URL');

    final baseUrl = configured?.isNotEmpty == true
        ? configured!
        : (envUrl.isNotEmpty ? envUrl : _defaultFrontendUrl);

    final uri = Uri.parse(baseUrl);
    final query = Map<String, String>.from(uri.queryParameters)
      ..['token'] = rawToken;

    return uri
        .replace(
          path: _joinPath(uri.path, 'verify-email'),
          queryParameters: query,
        )
        .toString();
  }

  String _joinPath(String basePath, String suffix) {
    final trimmedBase = basePath.trim();
    if (trimmedBase.isEmpty || trimmedBase == '/') {
      return '/$suffix';
    }
    return '${trimmedBase.replaceFirst(RegExp(r'/$'), '')}/$suffix';
  }

  String _generateRawToken() {
    final bytes = List<int>.generate(
      32,
      (_) => Random.secure().nextInt(256),
      growable: false,
    );
    return base64UrlEncode(bytes).replaceAll('=', '');
  }
}

class EmailVerificationHttpException implements Exception {
  const EmailVerificationHttpException({
    required this.statusCode,
    required this.message,
    required this.code,
  });

  final int statusCode;
  final String message;
  final String code;
}
