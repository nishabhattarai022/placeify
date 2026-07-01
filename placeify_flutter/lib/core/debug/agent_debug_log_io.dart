import 'dart:convert';
import 'dart:io';

const _logPath =
    '/Users/rosikagajurel/Documents/College/placeify/.cursor/debug-15cd3e.log';

void writeAgentDebugLog(Map<String, Object?> payload) {
  try {
    final file = File(_logPath);
    file.parent.createSync(recursive: true);
    file.writeAsStringSync('${jsonEncode(payload)}\n', mode: FileMode.append);
  } catch (_) {}
}
