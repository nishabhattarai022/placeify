/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Admin moderation and finance action types for audit logging.
enum AdminActionType implements _i1.SerializableModel {
  approveVendor,
  rejectVendor,
  suspendVendor,
  reinstateVendor,
  suspendUser,
  activateUser,
  deactivateUser,
  updateUserStatus,
  removeProduct,
  restoreProduct,
  deleteProduct,
  flagProduct,
  featureProduct,
  resolveComplaint,
  assignComplaint,
  reopenComplaint,
  approvePayout,
  failPayout,
  approveRefund,
  rejectRefund,
  checkEsewaRefundStatus,
  completeManualEsewaSettlement;

  static AdminActionType fromJson(String name) {
    switch (name) {
      case 'approveVendor':
        return AdminActionType.approveVendor;
      case 'rejectVendor':
        return AdminActionType.rejectVendor;
      case 'suspendVendor':
        return AdminActionType.suspendVendor;
      case 'reinstateVendor':
        return AdminActionType.reinstateVendor;
      case 'suspendUser':
        return AdminActionType.suspendUser;
      case 'activateUser':
        return AdminActionType.activateUser;
      case 'deactivateUser':
        return AdminActionType.deactivateUser;
      case 'updateUserStatus':
        return AdminActionType.updateUserStatus;
      case 'removeProduct':
        return AdminActionType.removeProduct;
      case 'restoreProduct':
        return AdminActionType.restoreProduct;
      case 'deleteProduct':
        return AdminActionType.deleteProduct;
      case 'flagProduct':
        return AdminActionType.flagProduct;
      case 'featureProduct':
        return AdminActionType.featureProduct;
      case 'resolveComplaint':
        return AdminActionType.resolveComplaint;
      case 'assignComplaint':
        return AdminActionType.assignComplaint;
      case 'reopenComplaint':
        return AdminActionType.reopenComplaint;
      case 'approvePayout':
        return AdminActionType.approvePayout;
      case 'failPayout':
        return AdminActionType.failPayout;
      case 'approveRefund':
        return AdminActionType.approveRefund;
      case 'rejectRefund':
        return AdminActionType.rejectRefund;
      case 'checkEsewaRefundStatus':
        return AdminActionType.checkEsewaRefundStatus;
      case 'completeManualEsewaSettlement':
        return AdminActionType.completeManualEsewaSettlement;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "AdminActionType"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
