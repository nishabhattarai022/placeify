import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

/// Serves a lightweight HTML page for magic-link verification.
///
/// Flutter web at `/app` is not required — phones can open this URL from email.
class VerifyEmailPageRoute extends Route {
  VerifyEmailPageRoute() : super(methods: const {Method.get});

  @override
  Future<Response> handleCall(Session session, Request request) async {
    final token = request.url.queryParameters['token']?.trim() ?? '';

    // #region agent log
    try {
      final logFile = File(
        '/Users/anubudhathoki/Downloads/Placeify-main/.cursor/debug-81ffa2.log',
      );
      logFile.parent.createSync(recursive: true);
      logFile.writeAsStringSync(
        '${jsonEncode({
          'sessionId': '81ffa2',
          'runId': 'verify-link',
          'hypothesisId': 'I',
          'location': 'verify_email_page_route.dart',
          'message': 'HTML verify page requested',
          'data': {
            'hasToken': token.isNotEmpty,
            'tokenLen': token.length,
            'path': request.url.path,
            'isHttps': request.url.scheme == 'https' ||
                (request.headers['x-forwarded-proto']?.contains('https') ??
                    false),
            'hostHeader': request.headers.host,
          },
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        })}\n',
        mode: FileMode.append,
        flush: true,
      );
    } catch (e, st) {
      session.log(
        'debug log write failed: $e',
        level: LogLevel.warning,
        stackTrace: st,
      );
    }
    // #endregion

    final file = File(Uri(path: 'web/pages/verify_email.html').toFilePath());
    if (!file.existsSync()) {
      return Response(
        500,
        body: Body.fromString(
          'Verification page is missing on the server.',
          mimeType: MimeType.plainText,
        ),
      );
    }

    return Response(
      200,
      body: Body.fromString(
        file.readAsStringSync(),
        mimeType: MimeType.html,
      ),
      headers: Headers.build(
        (headers) => headers.cacheControl = CacheControlHeader(
          noCache: true,
          privateCache: true,
        ),
      ),
    );
  }
}
