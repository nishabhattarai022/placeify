import 'dart:convert';

import 'package:http/http.dart' as http;

import 'agent_debug_log_stub.dart'
    if (dart.library.io) 'agent_debug_log_io.dart';

/// Foldable debug logging for Cursor debug sessions.
abstract final class AgentDebugLog {
  static const _endpoint =
      'http://127.0.0.1:7719/ingest/de5a92ac-2b16-4b3f-8f80-d2c85552e64b';
  static const _sessionId = '15cd3e';

  static void log(
    String location,
    String message,
    Map<String, Object?> data, {
    required String hypothesisId,
    String runId = 'pre-fix',
  }) {
    final payload = <String, Object?>{
      'sessionId': _sessionId,
      'location': location,
      'message': message,
      'data': data,
      'hypothesisId': hypothesisId,
      'runId': runId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    // #region agent log
    writeAgentDebugLog(payload);
    http
        .post(
          Uri.parse(_endpoint),
          headers: {
            'Content-Type': 'application/json',
            'X-Debug-Session-Id': _sessionId,
          },
          body: jsonEncode(payload),
        )
        .catchError((_) => http.Response('', 500));
    // #endregion
  }
}
