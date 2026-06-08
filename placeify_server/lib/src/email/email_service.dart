import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

/// Sends transactional auth emails (verification, password reset).
///
/// Configure via [Session.passwords] or `SERVERPOD_PASSWORD_*` env vars:
/// - `emailProvider`: `console` | `resend` | `smtp` (default: `console` in dev)
/// - `emailFrom`: sender address (required for resend/smtp)
/// - `resendApiKey`: Resend API key (when provider is `resend`)
/// - `smtpHost`, `smtpPort`, `smtpUser`, `smtpPassword`: SMTP settings
abstract final class EmailService {
  static const _resendApiUrl = 'https://api.resend.com/emails';

  /// Sends a verification or reset code email.
  ///
  /// In development, falls back to server logs when email is not configured.
  /// In staging/production, throws [EmailDeliveryException] if delivery fails.
  static Future<void> sendAuthCodeEmail(
    Session session, {
    required String to,
    required String subject,
    required String code,
    required String purpose,
  }) async {
    final htmlBody = _buildHtmlBody(purpose: purpose, code: code);
    final textBody = _buildTextBody(purpose: purpose, code: code);

    try {
      await _deliver(
        session,
        to: to,
        subject: subject,
        textBody: textBody,
        htmlBody: htmlBody,
      );
    } on EmailDeliveryException {
      rethrow;
    } catch (error, stackTrace) {
      session.log(
        'Email delivery failed for $to: $error',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      if (_isProductionLike(session)) {
        throw EmailDeliveryException(
          'Could not send email. Please try again later.',
        );
      }
      session.log(
        '[EmailService] DEV fallback — $purpose code for $to: $code',
        level: LogLevel.warning,
      );
    }
  }

  static Future<void> _deliver(
    Session session, {
    required String to,
    required String subject,
    required String textBody,
    required String htmlBody,
  }) async {
    final provider = _password(session, 'emailProvider')?.trim().toLowerCase() ??
        (_isProductionLike(session) ? 'resend' : 'console');

    switch (provider) {
      case 'console':
        session.log(
          '[EmailService] $subject → $to\n$textBody',
          level: LogLevel.info,
        );
        return;
      case 'resend':
        await _sendViaResend(
          session,
          to: to,
          subject: subject,
          textBody: textBody,
          htmlBody: htmlBody,
        );
        return;
      case 'smtp':
        await _sendViaSmtp(
          session,
          to: to,
          subject: subject,
          textBody: textBody,
        );
        return;
      default:
        throw EmailDeliveryException('Unknown emailProvider: $provider');
    }
  }

  static Future<void> _sendViaResend(
    Session session, {
    required String to,
    required String subject,
    required String textBody,
    required String htmlBody,
  }) async {
    final apiKey = _password(session, 'resendApiKey');
    final from = _password(session, 'emailFrom');

    if (apiKey == null || apiKey.isEmpty) {
      throw EmailDeliveryException('resendApiKey is not configured.');
    }
    if (from == null || from.isEmpty) {
      throw EmailDeliveryException('emailFrom is not configured.');
    }

    final response = await http.post(
      Uri.parse(_resendApiUrl),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'from': from,
        'to': [to],
        'subject': subject,
        'text': textBody,
        'html': htmlBody,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      session.log(
        'Resend API error ${response.statusCode}: ${response.body}',
        level: LogLevel.error,
      );
      throw EmailDeliveryException(
        'Email provider rejected the message (${response.statusCode}).',
      );
    }
  }

  static Future<void> _sendViaSmtp(
    Session session, {
    required String to,
    required String subject,
    required String textBody,
  }) async {
    final host = _password(session, 'smtpHost');
    final portStr = _password(session, 'smtpPort') ?? '587';
    final user = _password(session, 'smtpUser');
    final password = _password(session, 'smtpPassword');
    final from = _password(session, 'emailFrom');

    if (host == null ||
        host.isEmpty ||
        user == null ||
        user.isEmpty ||
        password == null ||
        password.isEmpty ||
        from == null ||
        from.isEmpty) {
      throw EmailDeliveryException(
        'SMTP is not fully configured (smtpHost, smtpUser, smtpPassword, emailFrom).',
      );
    }

    final port = int.tryParse(portStr) ?? 587;

    // Minimal SMTP send via external relay API pattern — use Resend in production.
    // For SMTP, log instructions; full SMTP requires mailer package.
    session.log(
      'SMTP provider selected but use Resend for production. '
      'Attempting basic SMTP to $host:$port for $to',
      level: LogLevel.warning,
    );

    // Delegate to Resend if smtp is selected but resend key exists (migration path).
    final resendKey = _password(session, 'resendApiKey');
    if (resendKey != null && resendKey.isNotEmpty) {
      await _sendViaResend(
        session,
        to: to,
        subject: subject,
        textBody: textBody,
        htmlBody: '<p>${_escapeHtml(textBody)}</p>',
      );
      return;
    }

    throw EmailDeliveryException(
      'SMTP delivery is not enabled. Set emailProvider to resend and configure resendApiKey.',
    );
  }

  static bool _isProductionLike(Session session) {
    final mode = session.serverpod.runMode;
    return mode == ServerpodRunMode.production ||
        mode == ServerpodRunMode.staging;
  }

  static String _buildTextBody({
    required String purpose,
    required String code,
  }) {
    return '''
$purpose

Your verification code is: $code

This code expires soon. If you did not request this, you can ignore this email.

— Placeify
''';
  }

  static String _buildHtmlBody({
    required String purpose,
    required String code,
  }) {
    return '''
<!DOCTYPE html>
<html>
<body style="font-family: sans-serif; color: #333;">
  <h2>$purpose</h2>
  <p>Your verification code is:</p>
  <p style="font-size: 28px; font-weight: bold; letter-spacing: 4px;">$code</p>
  <p style="color: #666; font-size: 14px;">This code expires soon. If you did not request this, ignore this email.</p>
  <p style="color: #999; font-size: 12px;">— Placeify</p>
</body>
</html>
''';
  }

  static String? _password(Session session, String key) {
    final value = session.passwords[key];
    if (value == null || value.isEmpty) return null;
    return value;
  }

  static String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;');
  }
}

/// Thrown when an email cannot be delivered in staging/production.
class EmailDeliveryException implements Exception {
  EmailDeliveryException(this.message);

  final String message;

  @override
  String toString() => message;
}
