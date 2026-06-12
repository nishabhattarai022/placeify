/// Standardized decline reasons for vendor application review.
enum DeclineReason {
  incompleteDocuments,
  invalidBusinessInfo,
  duplicateApplication,
  other,
}

extension DeclineReasonLabels on DeclineReason {
  String get label => switch (this) {
        DeclineReason.incompleteDocuments => 'Incomplete documents',
        DeclineReason.invalidBusinessInfo => 'Invalid business info',
        DeclineReason.duplicateApplication => 'Duplicate application',
        DeclineReason.other => 'Other',
      };

  String formatNote({String? otherDetail}) {
    if (this == DeclineReason.other) {
      final detail = otherDetail?.trim();
      return detail != null && detail.isNotEmpty ? 'Other: $detail' : 'Other';
    }
    return label;
  }
}
