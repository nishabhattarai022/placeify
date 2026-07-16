import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server.dart';
import 'package:yaml/yaml.dart';
import 'dart:io';

/// Quick Gmail SMTP smoke test. Usage:
/// dart run tool/smtp_smoke_test.dart test@example.com
Future<void> main(List<String> args) async {
  final to = args.isNotEmpty ? args.first : 'nishabhattarai2003@gmail.com';
  final yaml = loadYaml(
    File('config/passwords.yaml').readAsStringSync(),
  ) as YamlMap;
  final dev = yaml['development'] as YamlMap;

  final user = dev['gmailUser']?.toString() ?? dev['smtpUser']?.toString();
  final pass =
      dev['gmailAppPassword']?.toString() ?? dev['smtpPassword']?.toString();
  final from = dev['emailFrom']?.toString() ?? user;
  final host = dev['smtpHost']?.toString() ?? 'smtp.gmail.com';
  final port = int.tryParse(dev['smtpPort']?.toString() ?? '465') ?? 465;

  if (user == null || pass == null || from == null) {
    stderr.writeln('Missing gmailUser/gmailAppPassword/emailFrom in development');
    exit(1);
  }

  final smtpServer = SmtpServer(
    host,
    port: port,
    ssl: port == 465,
    username: user,
    password: pass,
  );

  final message = mailer.Message()
    ..from = mailer.Address(user, 'Placeify')
    ..recipients.add(to)
    ..subject = 'Placeify SMTP smoke test'
    ..text = 'If you received this, Gmail SMTP works for Placeify.';

  final report = await mailer.send(message, smtpServer);
  stdout.writeln('SMTP OK: $report');
}
