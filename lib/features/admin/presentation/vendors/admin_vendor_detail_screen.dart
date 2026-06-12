import 'package:flutter/material.dart';

/// Vendor detail with suspend/reinstate — ships in Phase 7.
class AdminVendorDetailScreen extends StatelessWidget {
  const AdminVendorDetailScreen({required this.vendorId, super.key});

  final String vendorId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vendor')),
      body: Center(
        child: Text('Vendor $vendorId — Phase 7'),
      ),
    );
  }
}
