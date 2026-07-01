import 'dart:convert';
import 'dart:io';

/// Foldable debug logging for Cursor debug sessions.
abstract final class AgentDebugLog {
  static const _logPath =
      '/Users/rosikagajurel/Documents/College/placeify/.cursor/debug-15cd3e.log';
  static const _sessionId = '15cd3e';

  static void log(
    String location,
    String message,
    Map<String, Object?> data, {
    required String hypothesisId,
    String runId = 'pre-fix',
  }) {
    // #region agent log
    try {
      final file = File(_logPath);
      file.parent.createSync(recursive: true);
      file.writeAsStringSync(
        '${jsonEncode({
          'sessionId': _sessionId,
          'location': location,
          'message': message,
          'data': data,
          'hypothesisId': hypothesisId,
          'runId': runId,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        })}\n',
        mode: FileMode.append,
      );
    } catch (_) {}
    // #endregion
  }
}
