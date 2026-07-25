import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/relative_time.dart';

const _keyPrefix = 'placeify_password_changed_at_';

final passwordChangedAtProvider = StateProvider<DateTime?>((ref) => null);

Future<DateTime?> loadPasswordChangedAt(String email) async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(_storageKey(email));
  if (raw == null) return null;
  return DateTime.tryParse(raw);
}

Future<void> savePasswordChangedAt(String email, DateTime changedAt) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_storageKey(email), changedAt.toIso8601String());
}

String passwordLastChangedSubtitle(DateTime? changedAt) {
  if (changedAt == null) return 'Manage your password';
  return 'Last changed ${RelativeTime.format(changedAt)}';
}

String _storageKey(String email) => '$_keyPrefix${email.trim().toLowerCase()}';
