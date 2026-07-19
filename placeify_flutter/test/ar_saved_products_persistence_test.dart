import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:placeify_flutter/core/providers/shared_preferences_provider.dart';
import 'package:placeify_flutter/features/ar/presentation/providers/ar_saved_products_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'My AR products survive provider and app-container recreation',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final firstContainer = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(firstContainer.dispose);

      await firstContainer.read(arSavedProductsProvider.notifier).addAll(const [
        'product-1',
        'product-2',
      ]);

      expect(
        prefs.getString('placeify_my_ar_saved_products'),
        isNotNull,
      );

      final restartedContainer = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(restartedContainer.dispose);

      expect(
        restartedContainer.read(arSavedProductsProvider).keys,
        containsAll(const ['product-1', 'product-2']),
      );
    },
  );
}
