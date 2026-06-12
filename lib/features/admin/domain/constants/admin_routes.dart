abstract final class AdminRoutes {
  static const prefix = '/admin';
  static const dashboard = '/admin';
  static const applications = '/admin/applications';
  static const vendors = '/admin/vendors';
  static const users = '/admin/users';
  static const notifications = '/admin/notifications';
  static const settings = '/admin/settings';
  static const auditLog = '/admin/audit-log';

  static String applicationDetail(String vendorId) => '$applications/$vendorId';

  static String vendorDetail(String vendorId) => '$vendors/$vendorId';

  /// Tab roots that show the admin bottom navigation bar.
  static const tabRoots = {
    dashboard,
    applications,
    vendors,
    users,
  };
}
