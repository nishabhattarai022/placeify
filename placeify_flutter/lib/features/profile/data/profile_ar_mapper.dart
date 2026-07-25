import 'package:placeify_client/placeify_client.dart';

import '../../cart/data/product_id_codec.dart';
import '../domain/models/profile_ui_models.dart';

abstract final class ProfileArMapper {
  static ProfileArSession fromSummary(UserArSessionSummary summary) {
    final started = summary.startedAt.toLocal();
    final month = _monthName(started.month);

    return ProfileArSession(
      productId: ProductIdCodec.fromDatabaseId(summary.productId),
      productName: summary.productName,
      thumbEmoji: _emojiForProduct(summary.productName),
      room: _roomLabel(summary.deviceInfo),
      dateLabel: '$month ${started.day}, ${started.year}',
      durationLabel: 'AR session',
    );
  }

  static String _roomLabel(String? deviceInfo) {
    final trimmed = deviceInfo?.trim();
    if (trimmed == null || trimmed.isEmpty) return 'Your space';
    return trimmed;
  }

  static String _emojiForProduct(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('lamp') || lower.contains('light')) return '💡';
    if (lower.contains('table')) return '🪞';
    if (lower.contains('sofa')) return '🛋️';
    if (lower.contains('bed')) return '🛏️';
    return '🪑';
  }

  static String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  static String formatHeroCount(int count) {
    if (count == 0) return 'AR History';
    if (count == 1) return 'AR History · 1 try';
    return 'AR History · $count tries';
  }
}
