import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import 'widgets/user_dashboard_header.dart';
import 'widgets/user_dashboard_sidebar.dart';

/// Responsive layout: persistent sidebar on desktop, drawer on mobile.
class UserDashboardShell extends StatefulWidget {
  const UserDashboardShell({required this.child, super.key});

  final Widget child;

  static const double desktopBreakpoint = 900;
  static const double sidebarWidth = 260;

  @override
  State<UserDashboardShell> createState() => _UserDashboardShellState();
}

class _UserDashboardShellState extends State<UserDashboardShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final isDesktop = MediaQuery.sizeOf(context).width >=
        UserDashboardShell.desktopBreakpoint;

    final sidebar = UserDashboardSidebar(
      currentLocation: location,
      onItemSelected: isDesktop
          ? null
          : () => Navigator.of(context).maybePop(),
    );

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UserDashboardHeader(
          currentLocation: location,
          onMenuTap: isDesktop
              ? null
              : () => _scaffoldKey.currentState?.openDrawer(),
        ),
        Expanded(child: widget.child),
      ],
    );

    if (isDesktop) {
      return Scaffold(
        backgroundColor: AppColors.cream,
        body: Row(
          children: [
            SizedBox(
              width: UserDashboardShell.sidebarWidth,
              child: sidebar,
            ),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.cream,
      drawer: Drawer(
        width: UserDashboardShell.sidebarWidth,
        child: sidebar,
      ),
      body: body,
    );
  }
}
