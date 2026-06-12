import 'package:placeify/features/admin/domain/enums/application_decision.dart';
import 'package:placeify/features/admin/domain/enums/audit_action.dart';
import 'package:placeify/features/admin/domain/models/admin_audit_log_entry.dart';

/// User-facing copy for the super admin dashboard.
abstract final class AdminStrings {
  // Dashboard
  static const adminOverview = 'Admin Overview';
  static const totalVendorsLabel = 'Total Vendors';
  static const totalVendorsSubtitle = 'Approved on platform';
  static const pendingLabel = 'Pending';
  static const pendingSubtitle = 'Awaiting review';
  static const approvedLabel = 'Approved';
  static const approvedSubtitle = 'Active vendors';
  static const suspendedLabel = 'Suspended';
  static const suspendedSubtitle = 'Restricted access';
  static const totalUsersLabel = 'Total Users';
  static const totalUsersSubtitle = 'Registered accounts';
  static const platformGmvLabel = 'Platform GMV';
  static const platformGmvSubtitle = 'Mock gross volume';
  static const needsAttention = 'Needs Attention';
  static const needsAttentionBody = 'vendor applications awaiting review';
  static const reviewNow = 'Review now';
  static const recentActivity = 'Recent Activity';
  static const newSignups = 'New Signups';
  static const last7Days = 'Last 7 days';
  static const quickLinks = 'Quick Links';
  static const usersLink = 'Users';
  static const notificationsLink = 'Notifications';
  static const recentApplications = 'Recent Applications';
  static const seeAll = 'See all';
  static const noApplicationsYet = 'No vendor applications yet';
  static const allCaughtUpPending = 'All caught up! No pending applications.';
  static const approvalsTitle = 'Approvals';
  static const dashboardLoadError = 'Could not load dashboard';
  static const retry = 'Retry';
  static const declineReasonLabel = 'Reason for decline';
  static const declineOtherHint = 'Please describe the reason';
  static const selectReason = 'Select a reason';
  static const confirmDecline = 'Confirm Decline';
  static const suspendReasonLabel = 'Reason for suspension';
  static const confirmSuspend = 'Confirm Suspend';
  static const roleAdmin = 'Admin';
  static const notificationPrefs = 'Notification preferences';
  static const notificationPrefsSubtitle = 'Choose which alerts you receive';
  static const newApplicationAlerts = 'New vendor applications';
  static const systemAlerts = 'System alerts';
  static const usersTitle = 'Platform Users';
  static const userDetailTitle = 'User Detail';
  static const noActivityYet = 'No recent activity';
  static const filterAll = 'All';
  static const filterLast7Days = 'Last 7 days';
  static const filterLast30Days = 'Last 30 days';

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
