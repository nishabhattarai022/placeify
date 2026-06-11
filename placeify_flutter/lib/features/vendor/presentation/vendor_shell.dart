import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Indexed-stack container for vendor tab branches inside [MainShell].
class VendorShell extends StatelessWidget {
  const VendorShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => navigationShell;
}
