/// Shared profile UI models (orders / refunds / AR history).
enum RefundStatus { underReview, refunded, rejected }

class ProfileStat {
  const ProfileStat({required this.value, required this.label});

  final String value;
  final String label;
}

class ProfileRefund {
  const ProfileRefund({
    required this.id,
    required this.productName,
    required this.thumbEmoji,
    required this.reason,
    required this.amountLabel,
    required this.status,
    required this.statusLabel,
    required this.requestedDateLabel,
    required this.isCompleted,
    this.destinationLabel,
    this.referenceNumber,
    this.rejectionReason,
    this.gatewayReference,
    this.completedDateLabel,
  });

  final int id;
  final String productName;
  final String thumbEmoji;
  final String reason;
  final String amountLabel;
  final RefundStatus status;
  final String statusLabel;
  final String requestedDateLabel;
  final bool isCompleted;
  final String? destinationLabel;
  final String? referenceNumber;
  final String? rejectionReason;
  final String? gatewayReference;
  final String? completedDateLabel;
}

class ProfileArSession {
  const ProfileArSession({
    required this.productId,
    required this.productName,
    required this.thumbEmoji,
    required this.room,
    required this.dateLabel,
    required this.durationLabel,
  });

  final String productId;
  final String productName;
  final String thumbEmoji;
  final String room;
  final String dateLabel;
  final String durationLabel;
}

class NotificationPref {
  const NotificationPref({
    required this.title,
    required this.subtitle,
    this.enabled = true,
  });

  final String title;
  final String subtitle;
  final bool enabled;
}
