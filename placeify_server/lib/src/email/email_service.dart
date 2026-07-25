import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server.dart';
import 'package:serverpod/serverpod.dart';

/// Sends transactional auth emails (verification, password reset).
///
/// Configure via [Session.passwords] or `SERVERPOD_PASSWORD_*` env vars:
/// - `emailProvider`: `console` | `resend` | `smtp` | `gmail`
/// - `emailFrom`: sender address (required for resend/smtp/gmail)
/// - `resendApiKey`: Resend API key (when provider is `resend`)
/// - `smtpHost`, `smtpPort`, `smtpUser`/`gmailUser`,
///   `smtpPassword`/`gmailAppPassword`, `smtpSecure`
abstract final class EmailService {
  static const _resendApiUrl = 'https://api.resend.com/emails';

  /// Sends a verification or reset code email.
  ///
  /// In development, falls back to server logs when email delivery fails.
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

    await _sendEmail(
      session,
      to: to,
      subject: subject,
      textBody: textBody,
      htmlBody: htmlBody,
      devFallbackSummary:
          '[EmailService] DEV fallback — $purpose code for $to: $code',
    );
  }

  static Future<void> sendVerificationLinkEmail(
    Session session, {
    required String to,
    required String verifyUrl,
  }) async {
    const subject = 'Verify your Placeify account';
    final textBody = _buildVerificationLinkTextBody(verifyUrl: verifyUrl);
    final htmlBody = _buildVerificationLinkHtmlBody(verifyUrl: verifyUrl);

    await _sendEmail(
      session,
      to: to,
      subject: subject,
      textBody: textBody,
      htmlBody: htmlBody,
      devFallbackSummary:
          '[EmailService] DEV fallback — verification link email simulated for $to',
    );

    if (!_isProductionLike(session)) {
      session.log(
        '[EmailService] Verification link for $to: $verifyUrl',
        level: LogLevel.info,
      );
    }
  }

  static Future<void> sendPasswordResetLinkEmail(
    Session session, {
    required String to,
    required String resetUrl,
  }) async {
    final subject = 'Reset your Placeify password';
    final textBody = _buildPasswordResetLinkTextBody(resetUrl: resetUrl);
    final htmlBody = _buildPasswordResetLinkHtmlBody(resetUrl: resetUrl);

    await _sendEmail(
      session,
      to: to,
      subject: subject,
      textBody: textBody,
      htmlBody: htmlBody,
      devFallbackSummary:
          '[EmailService] DEV fallback — password reset link email simulated for $to',
    );
  }

  static Future<void> sendPasswordChangedConfirmationEmail(
    Session session, {
    required String to,
  }) async {
    const subject = 'Your Placeify password was changed';
    const textBody = '''
Your Placeify password was changed successfully.

If you made this change, no further action is needed.
If you did not make this change, contact support immediately.

— Placeify
''';
    const htmlBody = '''
<!DOCTYPE html>
<html>
<body style="font-family: sans-serif; color: #333;">
  <h2>Your Placeify password was changed</h2>
  <p>Your password was changed successfully.</p>
  <p>If you made this change, no further action is needed.</p>
  <p style="color: #666; font-size: 14px;">If you did not make this change, contact support immediately.</p>
  <p style="color: #999; font-size: 12px;">— Placeify</p>
</body>
</html>
''';

    await _sendEmail(
      session,
      to: to,
      subject: subject,
      textBody: textBody,
      htmlBody: htmlBody,
      devFallbackSummary:
          '[EmailService] DEV fallback — password changed confirmation simulated for $to',
    );
  }

  static Future<void> _sendEmail(
    Session session, {
    required String to,
    required String subject,
    required String textBody,
    required String htmlBody,
    required String devFallbackSummary,
  }) async {
    try {
      await _deliver(
        session,
        to: to,
        subject: subject,
        textBody: textBody,
        htmlBody: htmlBody,
      );
    } on EmailDeliveryException catch (error, stackTrace) {
      session.log(
        'Email delivery failed for $to: $error',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      if (_isProductionLike(session)) rethrow;
      session.log(devFallbackSummary, level: LogLevel.warning);
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
      session.log(devFallbackSummary, level: LogLevel.warning);
    }
  }

  static Future<void> _deliver(
    Session session, {
    required String to,
    required String subject,
    required String textBody,
    required String htmlBody,
  }) async {
    final provider =
        _password(session, 'emailProvider')?.trim().toLowerCase() ??
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
      case 'gmail':
        await _sendViaSmtp(
          session,
          to: to,
          subject: subject,
          textBody: textBody,
          htmlBody: htmlBody,
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
    required String htmlBody,
  }) async {
    final host = _password(session, 'smtpHost') ?? 'smtp.gmail.com';
    final portStr = _password(session, 'smtpPort') ?? '465';
    final user =
        _password(session, 'smtpUser') ?? _password(session, 'gmailUser');
    final password =
        _password(session, 'smtpPassword') ??
        _password(session, 'gmailAppPassword');
    final from = _password(session, 'emailFrom');
    final secureFlag = _password(session, 'smtpSecure')?.trim().toLowerCase();
    final port = int.tryParse(portStr) ?? 465;
    final useSsl = secureFlag == null
        ? port == 465
        : secureFlag == 'true' || secureFlag == '1' || secureFlag == 'ssl';

    if (user == null ||
        user.isEmpty ||
        password == null ||
        password.isEmpty ||
        from == null ||
        from.isEmpty) {
      throw EmailDeliveryException(
        'SMTP is not fully configured '
        '(smtpHost/gmail credentials and emailFrom).',
      );
    }

    final smtpServer = SmtpServer(
      host,
      port: port,
      username: user,
      password: password,
      ssl: useSsl,
      allowInsecure: !useSsl,
    );

    final message = mailer.Message()
      ..from = mailer.Address(
        _extractEmailAddress(from),
        _extractDisplayName(from),
      )
      ..recipients.add(to)
      ..subject = subject
      ..text = textBody
      ..html = htmlBody;

    try {
      final report = await mailer.send(message, smtpServer);
      session.log(
        'SMTP email sent to $to via $host:$port (${report.toString()})',
        level: LogLevel.info,
      );
    } on mailer.MailerException catch (error, stackTrace) {
      session.log(
        'SMTP mailer error for $to: $error',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      throw EmailDeliveryException(
        'Could not send email via SMTP. Please try again later.',
      );
    }
  }

  static String _extractEmailAddress(String from) {
    final match = RegExp(r'<([^>]+)>').firstMatch(from);
    if (match != null) return match.group(1)!.trim();
    return from.trim();
  }

  static String? _extractDisplayName(String from) {
    final match = RegExp(r'^(.*)<[^>]+>\s*$').firstMatch(from.trim());
    if (match == null) return null;
    final name = match.group(1)!.trim().replaceAll('"', '');
    return name.isEmpty ? null : name;
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

  static String _buildPasswordResetLinkTextBody({required String resetUrl}) {
    return '''
Reset your Placeify password

Open the link below to choose a new password:
$resetUrl

This link expires in 30 minutes. If you did not request this, you can ignore this email.

— Placeify
''';
  }

  static String _buildPasswordResetLinkHtmlBody({required String resetUrl}) {
    final escapedUrl = _escapeHtml(resetUrl);
    return '''
<!DOCTYPE html>
<html>
<body style="font-family: sans-serif; color: #333;">
  <h2>Reset your Placeify password</h2>
  <p>Open the link below to choose a new password:</p>
  <p><a href="$escapedUrl">$escapedUrl</a></p>
  <p style="color: #666; font-size: 14px;">This link expires in 30 minutes. If you did not request this, ignore this email.</p>
  <p style="color: #999; font-size: 12px;">— Placeify</p>
</body>
</html>
''';
  }

  static String _buildVerificationLinkTextBody({required String verifyUrl}) {
    return '''
Welcome to Placeify!

You cannot access your account until you verify this email address.

Open the link below to activate your Placeify account:
$verifyUrl

This link expires soon. If you did not create a Placeify account, you can ignore this email.

— Placeify
''';
  }

  static String _buildVerificationLinkHtmlBody({required String verifyUrl}) {
    final escapedUrl = _escapeHtml(verifyUrl);
    return '''
<!DOCTYPE html>
<html>
<body style="font-family: sans-serif; color: #333;">
  <h2>Verify your Placeify account</h2>
  <p>You cannot access your account until you verify this email address.</p>
  <p>Open the link below to activate your Placeify account:</p>
  <p><a href="$escapedUrl">$escapedUrl</a></p>
  <p style="color: #666; font-size: 14px;">This link expires soon. If you did not create a Placeify account, ignore this email.</p>
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
