import 'package:placeify_client/placeify_client.dart';

import 'package:placeify_flutter/features/auth/domain/models/app_user.dart';

abstract final class AdminAuthGuard {
  static const _prefix = '/admin';

  /// Redirects non-admin users away from admin routes.
  static String? evaluate({
    required String location,
    required AppUser? user,
  }) {
    if (!location.startsWith(_prefix)) return null;
    if (user?.role == UserRole.admin) return null;
    return '/home';
  }
}
