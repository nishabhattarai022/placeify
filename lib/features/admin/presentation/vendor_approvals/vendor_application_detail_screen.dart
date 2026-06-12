import 'package:flutter/material.dart';

/// Vendor application detail — ships in Phase 6.
class VendorApplicationDetailScreen extends StatelessWidget {
  const VendorApplicationDetailScreen({required this.vendorId, super.key});

  final String vendorId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Application')),
      body: Center(
        child: Text('Application $vendorId — Phase 6'),
      ),
    );
  }
}
