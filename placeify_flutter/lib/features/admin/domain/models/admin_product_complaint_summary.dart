class AdminProductComplaintSummary {
  const AdminProductComplaintSummary({
    required this.complaintId,
    required this.reason,
    required this.status,
    required this.createdAt,
    this.description,
  });

  final String complaintId;
  final String reason;
  final String status;
  final DateTime createdAt;
  final String? description;
}
