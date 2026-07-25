import 'package:flutter/material.dart';

import '../domain/user_dashboard_nav.dart';
import 'widgets/user_dashboard_empty_page.dart';

class UserRefundPage extends StatelessWidget {
  const UserRefundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UserDashboardEmptyPage(
      title: 'Refund & Return',
      description: 'Return and refund requests will be handled here.',
      icon: Icons.assignment_return_outlined,
    );
  }
}

class UserNotificationsPage extends StatelessWidget {
  const UserNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UserDashboardEmptyPage(
      title: 'Notifications',
      description: 'Alerts and updates will show up in this section.',
      icon: Icons.notifications_outlined,
    );
  }
}

class UserAccountPage extends StatelessWidget {
  const UserAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return UserDashboardEmptyPage(
      title: UserDashboardNav.profile.pageTitle,
      description: 'Profile details and account information will live here.',
      icon: UserDashboardNav.profile.icon,
    );
  }
}

class UserSettingsPage extends StatelessWidget {
  const UserSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UserDashboardEmptyPage(
      title: 'Settings',
      description: 'Account preferences and security settings coming soon.',
      icon: Icons.settings_outlined,
    );
  }
}

class UserTryMePage extends StatelessWidget {
  const UserTryMePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UserDashboardEmptyPage(
      title: 'Try Me',
      description: 'AR try-on experiences will be available from here.',
      icon: Icons.view_in_ar_outlined,
    );
  }
}
