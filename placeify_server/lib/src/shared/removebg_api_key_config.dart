import 'yaml_api_key_config.dart';

/// remove.bg API key for vendor product photo background removal.
abstract final class RemoveBgApiKeyConfig {
  static const configFileName = 'removebg_api_key.yaml';
  static const apiKeyEnv = 'PLACEIFY_REMOVEBG_API_KEY';

  static String? apiKey() => YamlApiKeyConfig.read(
    configFileName: configFileName,
    fieldName: 'apiKey',
    envVarName: apiKeyEnv,
  );
}
