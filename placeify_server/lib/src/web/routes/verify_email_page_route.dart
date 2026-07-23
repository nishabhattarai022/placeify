import 'dart:io';

import 'package:serverpod/serverpod.dart';

/// Serves a lightweight HTML page for magic-link verification.
///
/// Phones can open this URL from email without the Flutter web app at `/app`.
class VerifyEmailPageRoute extends Route {
  VerifyEmailPageRoute() : super(methods: const {Method.get});

  @override
  Future<Response> handleCall(Session session, Request request) async {
    session.log(
      '[VerifyEmailPage] GET /verify-email tokenPresent='
      '${(request.url.queryParameters['token'] ?? '').trim().isNotEmpty}',
      level: LogLevel.info,
    );
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
