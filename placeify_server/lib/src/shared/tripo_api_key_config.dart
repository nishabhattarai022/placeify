import 'yaml_api_key_config.dart';

/// Loads the Tripo API key from [configFileName] in the server config folder.
///
/// Falls back to [apiKeyEnv] when the file is missing (e.g. production/Docker).
abstract final class TripoApiKeyConfig {
  static const configFileName = 'tripo_api_key.yaml';
  static const apiKeyEnv = 'PLACEIFY_TRIPO_API_KEY';

  static String? apiKey() => YamlApiKeyConfig.read(
    configFileName: configFileName,
    fieldName: 'apiKey',
    envVarName: apiKeyEnv,
  );
}
