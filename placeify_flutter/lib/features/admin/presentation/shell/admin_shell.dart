import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Indexed-stack container for admin tab branches inside [MainShell].
class AdminShell extends StatelessWidget {
  const AdminShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => navigationShell;
}
