import 'dart:collection';

import 'package:meta/meta.dart';

class PasswordResetRateLimiter {
  PasswordResetRateLimiter._();

  static const _ipWindow = Duration(minutes: 15);
  static const _emailWindow = Duration(minutes: 30);
  static const _maxRequestsPerIp = 10;
  static const _maxRequestsPerEmail = 3;

  static final _ipAttempts = HashMap<String, List<DateTime>>();
  static final _emailAttempts = HashMap<String, List<DateTime>>();

  static bool allow({
    required String ipAddress,
    required String email,
    DateTime? now,
  }) {
    final clock = now ?? DateTime.now().toUtc();
    _prune(clock);

    final ipEntries = _ipAttempts.putIfAbsent(ipAddress, () => <DateTime>[]);
    if (ipEntries.length >= _maxRequestsPerIp) {
      return false;
    }

    final emailEntries = _emailAttempts.putIfAbsent(email, () => <DateTime>[]);
    if (emailEntries.length >= _maxRequestsPerEmail) {
      return false;
    }

    ipEntries.add(clock);
    emailEntries.add(clock);
    return true;
  }

  static void _prune(DateTime now) {
    _pruneBucket(_ipAttempts, now.subtract(_ipWindow));
    _pruneBucket(_emailAttempts, now.subtract(_emailWindow));
  }

  static void _pruneBucket(
    Map<String, List<DateTime>> bucket,
    DateTime cutoff,
  ) {
    final expiredKeys = <String>[];
    for (final entry in bucket.entries) {
      entry.value.removeWhere((attempt) => attempt.isBefore(cutoff));
      if (entry.value.isEmpty) {
        expiredKeys.add(entry.key);
      }
    }

    for (final key in expiredKeys) {
      bucket.remove(key);
    }
  }

  @visibleForTesting
  static void reset() {
    _ipAttempts.clear();
    _emailAttempts.clear();
  }
}
