import 'package:placeify_client/placeify_client.dart';
import 'package:serverpod_client/serverpod_client.dart';

import '../../../core/config/placeify_server_client.dart';

class AdminApiException implements Exception {
  AdminApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Serverpod-backed admin moderation actions.
class ServerpodAdminApi {
  const ServerpodAdminApi();

  Future<void> approveVendor(String userId) async {
    try {
      await client.admin.approveVendor(UuidValue.fromString(userId));
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  Future<void> rejectVendor(String userId) async {
    try {
      await client.admin.rejectVendor(UuidValue.fromString(userId));
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  Future<void> suspendVendor(String userId, {required String reason}) async {
    try {
      await client.admin.suspendVendor(
        UuidValue.fromString(userId),
        reason,
      );
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  Future<String> getVendorReinstateTerms() async {
    try {
      return await client.admin.getVendorReinstateTerms();
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  Future<void> reactivateVendor(
    String userId, {
    required bool termsAccepted,
    String? termsNote,
  }) async {
    try {
      await client.admin.reactivateVendor(
        UuidValue.fromString(userId),
        termsAccepted: termsAccepted,
        termsNote: termsNote,
      );
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  Future<void> suspendUser(String userId) async {
    try {
      await client.admin.suspendUser(UuidValue.fromString(userId));
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  Future<void> activateUser(String userId) async {
    try {
      await client.admin.activateUser(UuidValue.fromString(userId));
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  Future<PlatformUserDetail?> getUserDetail(String userId) async {
    try {
      return await client.admin.getUserDetail(UuidValue.fromString(userId));
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  Future<User> updateUserStatus(
    String userId,
    UserAccountStatus status, {
    bool? isActive,
  }) async {
    try {
      return await client.admin.updateUserStatus(
        UuidValue.fromString(userId),
        status,
        isActive: isActive,
      );
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  Future<User> deactivateUser(String userId) async {
    try {
      return await client.admin.deactivateUser(UuidValue.fromString(userId));
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  Future<Product> removeProduct(int productId, String reason) async {
    try {
      return await client.admin.removeProduct(productId, reason);
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  Future<Product> restoreProduct(int productId) async {
    try {
      return await client.admin.restoreProduct(productId);
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  Future<Product> flagProduct(int productId) async {
    try {
      return await client.admin.flagProduct(productId);
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  Future<List<Complaint>> listComplaints({ComplaintStatus? status}) async {
    try {
      return await client.admin.listComplaints(status: status);
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  Future<Complaint> resolveComplaint(String complaintId) async {
    try {
      return await client.admin.resolveComplaint(
        UuidValue.fromString(complaintId),
      );
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  Future<List<AdminVendorPayoutSummary>> listVendorPayouts({
    VendorPayoutStatus? status,
  }) async {
    try {
      return await client.admin.listVendorPayouts(status: status);
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  Future<AdminVendorPayoutSummary> approveVendorPayout(int payoutId) async {
    try {
      return await client.admin.approveVendorPayout(payoutId);
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  Future<AdminVendorPayoutSummary> failVendorPayout(int payoutId) async {
    try {
      return await client.admin.failVendorPayout(payoutId);
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  Future<List<AdminRefundRequestSummary>> listRefundRequests({
    RequestStatus? status,
  }) async {
    try {
      return await client.admin.listRefundRequests(status: status);
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  Future<AdminRefundRequestSummary> approveRefundRequest(int refundId) async {
    try {
      return await client.admin.approveRefundRequest(refundId);
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  Future<AdminRefundRequestSummary> rejectRefundRequest(int refundId) async {
    try {
      return await client.admin.rejectRefundRequest(refundId);
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  String _mapError(Object error) {
    if (error is AdminApiException) return error.message;
    if (error is PlaceifyException) return error.message;

    final raw = switch (error) {
      ServerpodClientException(:final message) => message,
      _ => error.toString(),
    };

    if (raw.contains('Method not found')) {
      return 'Server is missing suspend support. Restart placeify_server after pulling the latest code.';
    }

    if (raw.contains('moderationNote') || raw.contains('moderatedAt')) {
      return 'Database migration pending. Restart placeify_server to apply migrations.';
    }

    final colonIndex = raw.indexOf(': ');
    if (colonIndex > 0 && colonIndex < 40) {
      final message = raw.substring(colonIndex + 2).trim();
      if (message.isNotEmpty && !message.startsWith('Exception')) {
        return message.length <= 200 ? message : message.substring(0, 200);
      }
    }

    if (error is ServerpodClientException) return error.message;
    return raw;
  }
}
