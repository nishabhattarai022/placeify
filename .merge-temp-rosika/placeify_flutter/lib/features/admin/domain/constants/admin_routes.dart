abstract final class AdminRoutes {
  static const prefix = '/admin';
  static const dashboard = '/admin';
  static const approvals = '/admin/approvals';
  static const vendors = '/admin/vendors';
  static const users = '/admin/users';
  static const notifications = '/admin/notifications';
  static const settings = '/admin/settings';
  static const auditLog = '/admin/audit-log';

  static String approvalDetail(String applicationId) =>
      '$approvals/$applicationId';

  static String vendorDetail(String vendorId) => '$vendors/$vendorId';

  static String userDetail(String userId) => '$users/$userId';

  /// Tab roots that show the admin bottom navigation bar.
  static const tabRoots = {
    dashboard,
    approvals,
    vendors,
    settings,
  };
}
