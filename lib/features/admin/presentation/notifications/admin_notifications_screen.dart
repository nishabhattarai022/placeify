import 'package:flutter/material.dart';

/// Admin notification feed — ships in Phase 8.
class AdminNotificationsScreen extends StatelessWidget {
  const AdminNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const Center(
        child: Text('Notifications — Phase 8'),
      ),
    );
  }
}
