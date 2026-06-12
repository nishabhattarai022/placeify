import 'package:flutter/material.dart';

/// Admin profile and settings — ships in Phase 8.
class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(
        child: Text('Settings — Phase 8'),
      ),
    );
  }
}
