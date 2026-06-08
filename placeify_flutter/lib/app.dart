import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/placeify_theme.dart';

class PlaceifyApp extends ConsumerWidget {
  const PlaceifyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Placeify',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: PlaceifyTheme.light(),
    );
  }
}
