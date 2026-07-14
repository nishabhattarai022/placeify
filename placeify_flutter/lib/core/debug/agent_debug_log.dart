import 'dart:convert';

import 'package:http/http.dart' as http;

const _debugEndpoint =
    'http://127.0.0.1:7719/ingest/de5a92ac-2b16-4b3f-8f80-d2c85552e64b';
const _sessionId = 'bf89e7';

// #region agent log
void agentDebugLog({
  required String location,
  required String message,
  required String hypothesisId,
  Map<String, Object?> data = const {},
  String runId = 'verify',
}) {
  final payload = <String, Object?>{
    'sessionId': _sessionId,
    'runId': runId,
    'hypothesisId': hypothesisId,
    'location': location,
    'message': message,
    'data': data,
    'timestamp': DateTime.now().millisecondsSinceEpoch,
  };
  http
      .post(
        Uri.parse(_debugEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'X-Debug-Session-Id': _sessionId,
        },
        body: jsonEncode(payload),
      )
      .catchError((_) => http.Response('', 500));
}
// #endregion
