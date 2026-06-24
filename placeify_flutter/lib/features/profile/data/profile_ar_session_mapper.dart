import 'package:placeify_client/placeify_client.dart';

import '../../cart/data/product_id_codec.dart';
import '../../../core/utils/formatters.dart';
import 'profile_mock_data.dart';

/// Maps API AR sessions into Nisha [ProfileArSession] cards.
abstract final class ProfileArSessionMapper {
  static ProfileArSession fromSummary(UserArSessionSummary session) {
    final room = _roomLabel(session.deviceInfo);
    return ProfileArSession(
      productId: ProductIdCodec.fromDatabaseId(session.productId),
      productName: session.productName,
      thumbEmoji: _emojiForProduct(session.productName),
      room: room,
      dateLabel: Formatters.longDate(session.startedAt),
      durationLabel: 'AR session',
    );
  }

  static String _roomLabel(String? deviceInfo) {
    final info = deviceInfo?.trim();
    if (info != null && info.isNotEmpty) return info;
    return 'Your space';
  }

  static String _emojiForProduct(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('chair') || lower.contains('sofa')) return '🪑';
    if (lower.contains('lamp') || lower.contains('light')) return '💡';
    if (lower.contains('bed')) return '🛏️';
    if (lower.contains('table') || lower.contains('desk')) return '🪞';
    return '📦';
  }
}
