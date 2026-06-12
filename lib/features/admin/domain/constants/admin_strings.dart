import 'package:placeify/features/admin/domain/enums/application_decision.dart';
import 'package:placeify/features/admin/domain/enums/audit_action.dart';
import 'package:placeify/features/admin/domain/models/admin_audit_log_entry.dart';

/// User-facing copy for the super admin dashboard.
abstract final class AdminStrings {
  // Dashboard
  static const adminOverview = 'Admin Overview';
  static const pendingLabel = 'Pending';
  static const pendingSubtitle = 'Awaiting review';
  static const approvedLabel = 'Approved';
  static const approvedSubtitle = 'Active vendors';
  static const suspendedLabel = 'Suspended';
  static const suspendedSubtitle = 'Restricted access';
  static const totalUsersLabel = 'Total users';
  static const totalUsersSubtitle = 'Registered on platform';
  static const recentApplications = 'Recent Applications';
  static const seeAll = 'See all';
  static const noApplicationsYet = 'No vendor applications yet';
  static const dashboardLoadError = 'Could not load dashboard';
  static const retry = 'Retry';

  // Notifications
  static const notificationsTitle = 'Notifications';
  static const markAllRead = 'Mark all read';
  static const noNotifications = 'No notifications yet';
  static const notificationMarkedRead = 'Marked as read';

  // Settings
  static const settingsTitle = 'Settings';
  static const accountSection = 'Account';
  static const adminProfile = 'Admin profile';
  static const signedInAs = 'Signed in as';
  static const auditLog = 'Audit log';
  static const auditLogSubtitle = 'Review admin actions on the platform';
  static const signOut = 'Sign Out';
  static const signOutSubtitle = 'Return to the welcome screen';
  static const signedOut = 'Signed out';

  // Audit log
  static const auditLogTitle = 'Audit Log';
  static const noAuditEntries = 'No audit entries yet';
  static const targetUser = 'User';
  static const noteLabel = 'Note';

  // Toasts (approvals — referenced from sheets)
  static const vendorApproved = 'Vendor approved';
  static const vendorDeclined = 'Application declined';
  static const vendorSuspended = 'Vendor suspended';
  static const vendorReinstated = 'Vendor reinstated';

  static String auditActionLabel(AdminAuditAction action) {
    return action.when(
      application: (decision) => switch (decision) {
        ApplicationDecision.approved => 'Application approved',
        ApplicationDecision.declined => 'Application declined',
      },
      vendor: (auditAction) => switch (auditAction) {
        AuditAction.suspended => 'Vendor suspended',
        AuditAction.reinstated => 'Vendor reinstated',
      },
    );
  }
}
