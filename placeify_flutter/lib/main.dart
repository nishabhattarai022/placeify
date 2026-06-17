import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/config/placeify_server_client.dart';
import 'core/constants/app_colors.dart';
import 'core/providers/shared_preferences_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const PlaceifyBootstrap(),
    ),
  );
}

/// Shows UI immediately while the Serverpod client connects in the background.
class PlaceifyBootstrap extends StatefulWidget {
  const PlaceifyBootstrap({super.key});

  @override
  State<PlaceifyBootstrap> createState() => _PlaceifyBootstrapState();
}

class _PlaceifyBootstrapState extends State<PlaceifyBootstrap> {
  late Future<void> _clientReady;

  @override
  void initState() {
    super.initState();
    _clientReady = initializePlaceifyClient();
  }

  void _retry() {
    setState(() {
      _clientReady = reconnectPlaceifyClient(forceRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _clientReady,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: _StartupSplash(),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: _StartupError(onRetry: _retry),
          );
        }

        return const PlaceifyApp();
      },
    );
  }
}

class _StartupSplash extends StatelessWidget {
  const _StartupSplash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.onboardingBg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Placeify',
              style: TextStyle(
                fontFamily: 'Fraunces',
                fontSize: 42,
                fontWeight: FontWeight.w700,
                color: AppColors.onboardingTextHead,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Connecting to server…',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.onboardingTextBody,
              ),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(
              color: AppColors.onboardingAmber,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _StartupError extends StatelessWidget {
  const _StartupError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.cloud_off_outlined,
                  size: 48,
                  color: AppColors.onboardingAmber,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Could not reach the server',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onboardingTextHead,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '1. cd placeify_server\n'
                  '2. docker compose up -d\n'
                  '3. dart bin/main.dart\n\n'
                  'Then tap Retry.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.onboardingTextBody.withValues(alpha: 0.85),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: onRetry,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.onboardingAmber,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
