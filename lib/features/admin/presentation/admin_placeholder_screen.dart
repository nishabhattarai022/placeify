import 'package:flutter/material.dart';

/// Temporary landing screen until the admin shell ships in Phase 4.
class AdminPlaceholderScreen extends StatelessWidget {
  const AdminPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Admin Dashboard — Phase 4'),
      ),
    );
  }
}
