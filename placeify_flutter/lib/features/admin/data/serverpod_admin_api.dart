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
    return error.toString();
  }
}
