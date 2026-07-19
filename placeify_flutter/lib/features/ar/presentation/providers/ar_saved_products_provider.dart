import 'dart:async';
import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/shared_preferences_provider.dart';

part 'ar_saved_products_provider.g.dart';

/// Product id → time saved (newest first when listed).
@Riverpod(keepAlive: true)
class ArSavedProducts extends _$ArSavedProducts {
  static const _storageKey = 'placeify_my_ar_saved_products';

  @override
  Map<String, DateTime> build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return {};

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return {};
      final saved = <String, DateTime>{};
      for (final entry in decoded.entries) {
        final savedAt = DateTime.tryParse('${entry.value}');
        if (savedAt != null) saved['${entry.key}'] = savedAt;
      }
      return saved;
    } catch (_) {
      return {};
    }
  }

  bool isSaved(String productId) => state.containsKey(productId);

  void toggle(String productId) {
    if (state.containsKey(productId)) {
      state = Map<String, DateTime>.from(state)..remove(productId);
    } else {
      state = Map<String, DateTime>.from(state)..[productId] = DateTime.now();
    }
    _persist();
  }

  Future<void> addAll(Iterable<String> productIds) async {
    if (productIds.isEmpty) return;
    final now = DateTime.now();
    final next = Map<String, DateTime>.from(state);
    for (final id in productIds) {
      next[id] = now;
    }
    state = next;
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(
      _storageKey,
      jsonEncode(
        state.map((id, savedAt) => MapEntry(id, savedAt.toIso8601String())),
      ),
    );
  }
}
