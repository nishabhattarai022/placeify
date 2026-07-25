import 'package:flutter_test/flutter_test.dart';
import 'package:placeify_flutter/features/admin/domain/enums/user_role.dart';
import 'package:placeify_flutter/features/admin/presentation/guards/admin_auth_guard.dart';
import 'package:placeify_flutter/features/auth/domain/models/app_user.dart';

void main() {
  test('AdminAuthGuard allows admin UI role on /admin', () {
    const user = AppUser(
      id: '1',
      fullName: 'Admin',
      email: 'admin@placeify.com',
      role: UserRole.admin,
    );

    final redirect = AdminAuthGuard.evaluate(
      location: '/admin',
      user: user,
    );

    expect(redirect, isNull);
  });

  test('AdminAuthGuard redirects consumer away from /admin', () {
    const user = AppUser(
      id: '2',
      fullName: 'Shopper',
      email: 'shopper@example.com',
      role: UserRole.customer,
    );

    final redirect = AdminAuthGuard.evaluate(
      location: '/admin',
      user: user,
    );

    expect(redirect?.location, '/home');
  });
}
