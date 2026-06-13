import 'dart:io';

import 'package:yaml/yaml.dart';

/// Loads API keys from gitignored yaml files under `config/`, with env fallback.
abstract final class YamlApiKeyConfig {
  static final _cache = <String, String?>{};

  static String? read({
    required String configFileName,
    required String fieldName,
    required String envVarName,
  }) {
    final cacheKey = '$configFileName:$fieldName';
    if (_cache.containsKey(cacheKey)) {
      final cached = _cache[cacheKey];
      return cached == null || cached.isEmpty ? null : cached;
    }

    final fromFile = _readFromConfigFile(configFileName, fieldName);
    if (fromFile != null && fromFile.isNotEmpty) {
      _cache[cacheKey] = fromFile;
      return fromFile;
    }

    final fromEnv = Platform.environment[envVarName]?.trim();
    if (fromEnv != null && fromEnv.isNotEmpty) {
      _cache[cacheKey] = fromEnv;
      return fromEnv;
    }

    _cache[cacheKey] = '';
    return null;
  }

  static String? _readFromConfigFile(String configFileName, String fieldName) {
    for (final path in _configFileCandidates(configFileName)) {
      final file = File(path);
      if (!file.existsSync()) continue;

      try {
        final doc = loadYaml(file.readAsStringSync());
        if (doc is! YamlMap) continue;
        final value = doc[fieldName];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  static Iterable<String> _configFileCandidates(String configFileName) sync* {
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
