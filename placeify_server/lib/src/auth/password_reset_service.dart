import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../email/email_service.dart';
import '../generated/protocol.dart';
import 'password_reset_rate_limiter.dart';

class PasswordResetService {
  static const genericForgotPasswordMessage =
      'If an account exists for that email, a password reset link has been sent.';
  static const genericResetPasswordMessage =
      'Your password has been reset successfully.';
  static const invalidResetTokenMessage =
      'The password reset request is invalid or has expired.';

  static const _tokenExpiry = Duration(minutes: 30);
  static const _defaultFrontendUrl = 'http://localhost:3000';

  Future<void> forgotPassword(
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
      throw const PasswordResetHttpException(
        statusCode: 429,
        message: 'Too many password reset requests. Please try again later.',
        code: 'PASSWORD_RESET_RATE_LIMITED',
      );
    }

    final emailIdp = AuthServices.instance.emailIdp;
    final account = await emailIdp.admin.findAccount(
      session,
      email: normalizedEmail,
    );
    if (account == null) {
      return;
    }

    final user = await User.db.findFirstRow(
      session,
      where: (row) => row.authUserId.equals(account.authUserId),
    );
    if (user == null || user.id == null) {
      session.log(
        'Password reset requested for an auth account without a linked Placeify user.',
        level: LogLevel.warning,
      );
      return;
    }

    final rawToken = _generateRawToken();
    final now = DateTime.now().toUtc();

    await PasswordResetToken.db.insertRow(
      session,
      PasswordResetToken(
        userId: user.id!,
        tokenHash: hashToken(rawToken),
        expiresAt: now.add(_tokenExpiry),
      ),
    );

    await EmailService.sendPasswordResetLinkEmail(
      session,
      to: normalizedEmail,
      resetUrl: _buildResetUrl(session, rawToken),
    );
  }

  Future<void> resetPassword(
    Session session, {
    required String token,
    required String newPassword,
  }) async {
    final normalizedToken = token.trim();
    if (normalizedToken.isEmpty) {
      throw const PasswordResetHttpException(
        statusCode: 400,
        message: 'Token is required.',
        code: 'PASSWORD_RESET_TOKEN_REQUIRED',
      );
    }

    final emailIdp = AuthServices.instance.emailIdp;
    if (!emailIdp.config.passwordValidationFunction(newPassword)) {
      throw const PasswordResetHttpException(
        statusCode: 400,
        message:
            'Password is too weak. Use at least 8 characters with letters and numbers.',
        code: 'PASSWORD_POLICY_VIOLATION',
      );
    }

    final tokenHash = hashToken(normalizedToken);
    final now = DateTime.now().toUtc();

    final resetToken = await PasswordResetToken.db.findFirstRow(
      session,
      where: (row) =>
          row.tokenHash.equals(tokenHash) &
          row.used.equals(false) &
          (row.expiresAt > now),
      include: PasswordResetToken.include(user: User.include()),
    );

    if (resetToken == null || resetToken.user == null) {
      throw const PasswordResetHttpException(
        statusCode: 400,
        message: invalidResetTokenMessage,
        code: 'PASSWORD_RESET_INVALID',
      );
    }

    final user = resetToken.user!;
    final authEmail = await _resolveAuthEmail(session, user);

    await session.db.transaction((transaction) async {
      final current = await PasswordResetToken.db.findFirstRow(
        session,
        where: (row) =>
            row.id.equals(resetToken.id!) &
            row.used.equals(false) &
            (row.expiresAt > now),
        transaction: transaction,
      );
      if (current == null) {
        throw const PasswordResetHttpException(
          statusCode: 400,
          message: invalidResetTokenMessage,
          code: 'PASSWORD_RESET_INVALID',
        );
      }

      await emailIdp.admin.setPassword(
        session,
        email: authEmail,
        password: newPassword,
        transaction: transaction,
      );

      await AuthServices.instance.tokenManager.revokeAllTokens(
        session,
        authUserId: user.authUserId,
        method: EmailIdp.method,
        transaction: transaction,
      );

      await PasswordResetToken.db.updateRow(
        session,
        current.copyWith(used: true),
        transaction: transaction,
      );
    });

    await EmailService.sendPasswordChangedConfirmationEmail(
      session,
      to: authEmail,
    );
  }

  String hashToken(String rawToken) {
    return sha256.convert(utf8.encode(rawToken)).toString();
  }

  String generateTokenForTests() => _generateRawToken();

  String _validateEmail(String email) {
    final normalized = email.trim().toLowerCase();
    final valid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(normalized);
    if (!valid) {
      throw const PasswordResetHttpException(
        statusCode: 400,
        message: 'A valid email address is required.',
        code: 'INVALID_EMAIL',
      );
    }
    return normalized;
  }

  Future<String> _resolveAuthEmail(Session session, User user) async {
    final fromProfile = user.email?.trim().toLowerCase();
    if (fromProfile != null && fromProfile.isNotEmpty) {
      return fromProfile;
    }

    final account = await EmailAccount.db.findFirstRow(
      session,
      where: (row) => row.authUserId.equals(user.authUserId),
    );
    if (account == null) {
      throw const PasswordResetHttpException(
        statusCode: 400,
        message: invalidResetTokenMessage,
        code: 'PASSWORD_RESET_INVALID',
      );
    }

    return account.email.trim().toLowerCase();
  }

  String _buildResetUrl(Session session, String rawToken) {
    final configured = session.passwords['frontendUrl']?.trim();
    final envUrl = const String.fromEnvironment('FRONTEND_URL');
    final baseUrl = configured?.isNotEmpty == true
        ? configured!
        : (envUrl.isNotEmpty ? envUrl : _defaultFrontendUrl);

    final uri = Uri.parse(baseUrl);
    final query = Map<String, String>.from(uri.queryParameters)
      ..['token'] = rawToken;

    return uri.replace(
      path: _joinPath(uri.path, 'reset-password'),
      queryParameters: query,
    ).toString();
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

class PasswordResetHttpException implements Exception {
  const PasswordResetHttpException({
    required this.statusCode,
    required this.message,
    required this.code,
  });

  final int statusCode;
  final String message;
  final String code;
}
