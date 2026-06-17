import '../lib/src/shared/removebg_api_key_config.dart';
import '../lib/src/shared/tripo_api_key_config.dart';

void main() {
  final tripo = TripoApiKeyConfig.apiKey();
  final removeBg = RemoveBgApiKeyConfig.apiKey();
  print('Tripo API key: ${tripo == null || tripo.isEmpty ? 'NOT SET' : 'configured (${tripo.length} chars)'}');
  print('Remove.bg API key: ${removeBg == null || removeBg.isEmpty ? 'NOT SET' : 'configured (${removeBg.length} chars)'}');
}
