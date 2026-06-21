import 'package:placeify_client/placeify_client.dart';
import 'package:placeify_flutter/features/auth/domain/models/app_user.dart';

class AdminAuthRedirect {
  const AdminAuthRedirect({required this.location, this.toastMessage});

  final String location;
  final String? toastMessage;
}

abstract final class AdminAuthGuard {
  static const _prefix = '/admin';

  /// Redirects non-admin users away from admin routes.
  static AdminAuthRedirect? evaluate({
    required String location,
    required AppUser? user,
  }) {
    if (!location.startsWith(_prefix)) return null;
    if (user?.role == UserRole.admin) return null;

    if (user == null) {
      return const AdminAuthRedirect(
        location: '/login',
        toastMessage: 'Sign in with an admin account to continue.',
      );
    }

    return const AdminAuthRedirect(
      location: '/home',
      toastMessage: 'This account does not have admin access.',
    );
  }
}
