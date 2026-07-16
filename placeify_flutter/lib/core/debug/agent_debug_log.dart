import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const _sessionId = '643556';
const _debugLogPath =
    '/Users/rosikagajurel/Documents/College/placeify/.cursor/debug-643556.log';
const _ingestPath = '/ingest/de5a92ac-2b16-4b3f-8f80-d2c85552e64b';

List<String> _debugEndpoints() {
  // Android emulator → host machine; desktop/iOS sim → loopback.
  if (!kIsWeb && Platform.isAndroid) {
    return [
      'http://10.0.2.2:7719$_ingestPath',
      'http://127.0.0.1:7719$_ingestPath',
    ];
  }
  return ['http://127.0.0.1:7719$_ingestPath'];
}

// #region agent log
void agentDebugLog({
  required String location,
  required String message,
  required String hypothesisId,
  Map<String, Object?> data = const {},
  String runId = 'post-fix',
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
  final line = jsonEncode(payload);
  debugPrint('[AGENT_DEBUG] $line');
  try {
    File(_debugLogPath).writeAsStringSync(
      '$line\n',
      mode: FileMode.append,
      flush: true,
    );
  } catch (_) {}
  for (final endpoint in _debugEndpoints()) {
    http
        .post(
          Uri.parse(endpoint),
          headers: {
            'Content-Type': 'application/json',
            'X-Debug-Session-Id': _sessionId,
          },
          body: line,
        )
        .catchError((_) => http.Response('', 500));
  }
}
// #endregion
