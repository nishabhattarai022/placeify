import 'dart:io';

import 'package:yaml/yaml.dart';

/// Loads the Tripo API key from [configFileName] in the server config folder.
///
/// Falls back to [apiKeyEnv] when the file is missing (e.g. production/Docker).
abstract final class TripoApiKeyConfig {
  static const configFileName = 'tripo_api_key.yaml';
  static const apiKeyEnv = 'PLACEIFY_TRIPO_API_KEY';

  static String? _cached;

  /// Returns the Tripo API key, or null when not configured.
  static String? apiKey() {
    if (_cached != null) {
      return _cached!.isEmpty ? null : _cached;
    }

    final fromFile = _readFromConfigFile();
    if (fromFile != null && fromFile.isNotEmpty) {
      _cached = fromFile;
      return fromFile;
    }

    final fromEnv = Platform.environment[apiKeyEnv]?.trim();
    if (fromEnv != null && fromEnv.isNotEmpty) {
      _cached = fromEnv;
      return fromEnv;
    }

    _cached = '';
    return null;
  }

  static String? _readFromConfigFile() {
    for (final path in _configFileCandidates()) {
      final file = File(path);
      if (!file.existsSync()) continue;

      try {
        final doc = loadYaml(file.readAsStringSync());
        if (doc is! YamlMap) continue;
        final value = doc['apiKey'];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  static Iterable<String> _configFileCandidates() sync* {
    yield _joinAll([Directory.current.path, 'config', configFileName]);
    yield _joinAll([
      Directory.current.path,
      'placeify_server',
      'config',
      configFileName,
    ]);

    final scriptPath = Platform.script.toFilePath();
    final scriptDir = File(scriptPath).parent.path;
    final scriptName = scriptPath.split(Platform.pathSeparator).last;
    if (scriptName == 'main.dart' && scriptDir.endsWith('bin')) {
      final serverRoot = Directory(scriptDir).parent.path;
      yield _joinAll([serverRoot, 'config', configFileName]);
    }
  }

  static String _joinAll(List<String> parts) {
    return parts.join(Platform.pathSeparator);
  }
}
