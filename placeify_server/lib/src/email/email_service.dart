import 'dart:convert';
import 'dart:io';

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
/// - `smtpHost`, `smtpPort`, `smtpUser`, `smtpPassword`, `smtpSecure`: SMTP
/// - `gmailUser`, `gmailAppPassword`: Gmail shortcut (provider `gmail`)
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

    await _sendEmail(
      session,
      to: to,
      subject: subject,
      textBody: textBody,
      htmlBody: htmlBody,
      consoleLogBody: true,
      consoleSummary: '$purpose email sent to $to',
      devFallbackSummary: '[EmailService] DEV fallback — $purpose code for $to: $code',
    );
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
      consoleLogBody: false,
      consoleSummary: 'Password reset link email sent to $to',
      devFallbackSummary:
          '[EmailService] DEV fallback — password reset link email simulated for $to',
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
      consoleLogBody: false,
      consoleSummary: 'Email verification link sent to $to',
      devFallbackSummary:
          '[EmailService] DEV fallback — verification link email simulated for $to '
          '(open /verify-email from the app using the link printed above if logged)',
    );

    if (!_isProductionLike(session)) {
      session.log(
        '[EmailService] Verification link for $to: $verifyUrl',
        level: LogLevel.info,
      );
    }
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
      consoleLogBody: true,
      consoleSummary: 'Password changed confirmation email sent to $to',
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
    required bool consoleLogBody,
    required String consoleSummary,
    required String devFallbackSummary,
  }) async {
    try {
      await _deliver(
        session,
        to: to,
        subject: subject,
        textBody: textBody,
        htmlBody: htmlBody,
        consoleLogBody: consoleLogBody,
        consoleSummary: consoleSummary,
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
        devFallbackSummary,
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
    required bool consoleLogBody,
    required String consoleSummary,
  }) async {
    final provider = _password(session, 'emailProvider')?.trim().toLowerCase() ??
        (_isProductionLike(session) ? 'resend' : 'console');
    final hasResendKey =
        (_password(session, 'resendApiKey') ?? '').trim().isNotEmpty;

    // #region agent log
    try {
      final logFile = File(
        '/Users/anubudhathoki/Downloads/Placeify-main/.cursor/debug-81ffa2.log',
      );
      logFile.parent.createSync(recursive: true);
      logFile.writeAsStringSync(
        '${jsonEncode({
          'sessionId': '81ffa2',
          'runId': 'gmail-smtp',
          'hypothesisId': 'F',
          'location': 'email_service.dart:_deliver',
          'message': 'email delivery provider selected',
          'data': {
            'provider': provider,
            'hasResendKey': hasResendKey,
            'toDomain': to.contains('@') ? to.split('@').last : 'unknown',
            'inboxDelivery':
                provider == 'resend' || provider == 'smtp' || provider == 'gmail',
          },
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        })}\n',
        mode: FileMode.append,
        flush: true,
      );
    } catch (_) {}
    // #endregion

    switch (provider) {
      case 'console':
        final message = consoleLogBody
            ? '[EmailService] $subject → $to\n$textBody'
            : '[EmailService] $consoleSummary';
        session.log(message, level: LogLevel.info);
        session.log(
          '[EmailService] emailProvider=console — message was NOT sent to an inbox; use the link in server logs.',
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
        // #region agent log
        try {
          File(
            '/Users/anubudhathoki/Downloads/Placeify-main/.cursor/debug-81ffa2.log',
          ).writeAsStringSync(
            '${jsonEncode({
              'sessionId': '81ffa2',
              'runId': 'gmail-smtp',
              'hypothesisId': 'G',
              'location': 'email_service.dart:_deliver',
              'message': 'resend API accepted message',
              'data': {
                'toDomain': to.contains('@') ? to.split('@').last : 'unknown',
              },
              'timestamp': DateTime.now().millisecondsSinceEpoch,
            })}\n',
            mode: FileMode.append,
            flush: true,
          );
        } catch (_) {}
        // #endregion
        return;
      case 'gmail':
      case 'smtp':
        await _sendViaSmtp(
          session,
          provider: provider,
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
    required String provider,
    required String to,
    required String subject,
    required String textBody,
    required String htmlBody,
  }) async {
    final config = _resolveSmtpConfig(session, provider: provider);
    if (config == null) {
      throw EmailDeliveryException(
        provider == 'gmail'
            ? 'Gmail SMTP is not fully configured (gmailUser, gmailAppPassword, emailFrom).'
            : 'SMTP is not fully configured (smtpHost, smtpUser, smtpPassword, emailFrom).',
      );
    }

    final fromAddress = _parseFromAddress(config.fromRaw);
    final smtpServer = SmtpServer(
      config.host,
      port: config.port,
      ssl: config.useSsl,
      allowInsecure: false,
      username: config.username,
      password: config.password,
    );

    final message = mailer.Message()
      ..from = fromAddress
      ..recipients.add(to)
      ..subject = subject
      ..text = textBody
      ..html = htmlBody;

    try {
      final report = await mailer.send(message, smtpServer);
      session.log(
        '[EmailService] SMTP delivered to $to via ${config.host}:${config.port}',
        level: LogLevel.info,
      );
      // #region agent log
      try {
        File(
          '/Users/anubudhathoki/Downloads/Placeify-main/.cursor/debug-81ffa2.log',
        ).writeAsStringSync(
          '${jsonEncode({
            'sessionId': '81ffa2',
            'runId': 'gmail-smtp',
            'hypothesisId': 'J',
            'location': 'email_service.dart:_sendViaSmtp',
            'message': 'SMTP send succeeded',
            'data': {
              'provider': provider,
              'host': config.host,
              'port': config.port,
              'useSsl': config.useSsl,
              'toDomain': to.contains('@') ? to.split('@').last : 'unknown',
              'smtpOk': report.toString().contains('OK') ||
                  report.toString().contains('250'),
            },
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          })}\n',
          mode: FileMode.append,
          flush: true,
        );
      } catch (_) {}
      // #endregion
    } catch (error, stackTrace) {
      session.log(
        'SMTP error for $to via ${config.host}:${config.port}: $error',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      // #region agent log
      try {
        File(
          '/Users/anubudhathoki/Downloads/Placeify-main/.cursor/debug-81ffa2.log',
        ).writeAsStringSync(
          '${jsonEncode({
            'sessionId': '81ffa2',
            'runId': 'gmail-smtp',
            'hypothesisId': 'J',
            'location': 'email_service.dart:_sendViaSmtp',
            'message': 'SMTP send failed',
            'data': {
              'provider': provider,
              'host': config.host,
              'port': config.port,
              'errorType': error.runtimeType.toString(),
            },
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          })}\n',
          mode: FileMode.append,
          flush: true,
        );
      } catch (_) {}
      // #endregion
      throw EmailDeliveryException(
        'Could not send email via SMTP. Check Gmail app password and SMTP settings.',
      );
    }
  }

  static _SmtpConfig? _resolveSmtpConfig(
    Session session, {
    required String provider,
  }) {
    final fromRaw = _password(session, 'emailFrom');
    if (fromRaw == null || fromRaw.isEmpty) return null;

    if (provider == 'gmail') {
      final user = _password(session, 'gmailUser') ?? _password(session, 'smtpUser');
      final password = _password(session, 'gmailAppPassword') ??
          _password(session, 'smtpPassword');
      if (user == null || user.isEmpty || password == null || password.isEmpty) {
        return null;
      }

      final host = _password(session, 'smtpHost') ?? 'smtp.gmail.com';
      final port = _parsePort(_password(session, 'smtpPort'), defaultPort: 465);
      final secureRaw = _password(session, 'smtpSecure');
      final useSsl = secureRaw == null
          ? port == 465
          : _parseBool(secureRaw, defaultValue: true);

      return _SmtpConfig(
        host: host,
        port: port,
        useSsl: useSsl,
        username: user,
        password: password,
        fromRaw: fromRaw,
      );
    }

    final host = _password(session, 'smtpHost');
    final user = _password(session, 'smtpUser');
    final password = _password(session, 'smtpPassword');
    if (host == null ||
        host.isEmpty ||
        user == null ||
        user.isEmpty ||
        password == null ||
        password.isEmpty) {
      return null;
    }

    final port = _parsePort(_password(session, 'smtpPort'), defaultPort: 587);
    final secureRaw = _password(session, 'smtpSecure');
    final useSsl = secureRaw == null
        ? port == 465
        : _parseBool(secureRaw, defaultValue: port == 465);

    return _SmtpConfig(
      host: host,
      port: port,
      useSsl: useSsl,
      username: user,
      password: password,
      fromRaw: fromRaw,
    );
  }

  static mailer.Address _parseFromAddress(String raw) {
    final trimmed = raw.trim();
    final match = RegExp(r'^(.+?)\s*<([^>]+)>$').firstMatch(trimmed);
    if (match != null) {
      return mailer.Address(match.group(2)!.trim(), match.group(1)!.trim());
    }
    return mailer.Address(trimmed);
  }

  static int _parsePort(String? raw, {required int defaultPort}) {
    if (raw == null || raw.trim().isEmpty) return defaultPort;
    return int.tryParse(raw.trim()) ?? defaultPort;
  }

  static bool _parseBool(String raw, {required bool defaultValue}) {
    final normalized = raw.trim().toLowerCase();
    if (normalized == 'true' || normalized == '1' || normalized == 'yes') {
      return true;
    }
    if (normalized == 'false' || normalized == '0' || normalized == 'no') {
      return false;
    }
    return defaultValue;
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

class _SmtpConfig {
  const _SmtpConfig({
    required this.host,
    required this.port,
    required this.useSsl,
    required this.username,
    required this.password,
    required this.fromRaw,
  });

  final String host;
  final int port;
  final bool useSsl;
  final String username;
  final String password;
  final String fromRaw;
}

/// Thrown when an email cannot be delivered in staging/production.
class EmailDeliveryException implements Exception {
  EmailDeliveryException(this.message);

  final String message;

  @override
  String toString() => message;
}
