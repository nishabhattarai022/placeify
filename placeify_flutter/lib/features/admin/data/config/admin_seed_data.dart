import 'dart:convert';

import 'package:placeify_flutter/features/admin/domain/enums/user_role.dart';
import 'package:placeify_flutter/features/admin/domain/enums/admin_notification_type.dart';
import 'package:placeify_flutter/features/admin/domain/models/admin_notification.dart';
import 'package:placeify_flutter/features/vendor/data/vendor_profile_provisioner.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_registration.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// First-launch seed users, registrations, and admin notifications.
abstract final class AdminSeedData {
  static const seedAppliedKey = 'placeify_admin_seed_applied';
  static const authUsersKey = 'placeify_auth_users';
  static const registrationsKey = 'placeify_vendor_registrations';
  static const notificationsKey = 'placeify_admin_notifications';

  static const demoAdminId = 'demo-admin';

  static const pendingUser1Id = 'seed-pending-user-1';
  static const pendingVendor1Id = 'seed-vendor-pending-1';
  static const pendingUser2Id = 'seed-pending-user-2';
  static const pendingVendor2Id = 'seed-vendor-pending-2';
  static const pendingUser3Id = 'seed-pending-user-3';
  static const pendingVendor3Id = 'seed-vendor-pending-3';

  static const approvedUserId = 'seed-approved-user-1';
  static const approvedVendorId = 'seed-vendor-approved-1';

  static const suspendedUserId = 'seed-suspended-user-1';
  static const suspendedVendorId = 'seed-vendor-suspended-1';

  static final Map<String, DateTime> userCreatedAt = {
    pendingUser1Id: DateTime(2026, 6, 8, 10, 30),
    pendingUser2Id: DateTime(2026, 6, 7, 14, 15),
    pendingUser3Id: DateTime(2026, 6, 6, 9, 0),
    approvedUserId: DateTime(2026, 3, 15, 11, 0),
    suspendedUserId: DateTime(2026, 2, 20, 16, 45),
    'demo-user': DateTime(2026, 1, 1),
    demoAdminId: DateTime(2026, 1, 1),
  };

  static DateTime createdAtFor(String userId) =>
      userCreatedAt[userId] ?? DateTime(2026, 1, 15);

  static Future<void> ensureSeeded(SharedPreferences prefs) async {
    if (prefs.getBool(seedAppliedKey) == true) return;

    await _seedUsers(prefs);
    await _seedRegistrations(prefs);
    await _seedNotifications(prefs);
    _seedApprovedVendorProfiles(prefs);

    await prefs.setBool(seedAppliedKey, true);
  }

  static void _seedApprovedVendorProfiles(SharedPreferences prefs) {
    VendorProfileProvisioner.ensureFromRegistration(approvedVendorId, prefs);
  }

  static Future<void> _seedUsers(SharedPreferences prefs) async {
    final existing = _loadJsonList(prefs.getString(authUsersKey));
    final seedUsers = [
      _storedUser(
        id: pendingUser1Id,
        fullName: 'Ramesh Thapa',
        email: 'ramesh.crafts@placeify.demo',
        vendorStatus: VendorStatus.pending,
        vendorId: pendingVendor1Id,
      ),
      _storedUser(
        id: pendingUser2Id,
        fullName: 'Sunita Gurung',
        email: 'sunita.nest@placeify.demo',
        vendorStatus: VendorStatus.pending,
        vendorId: pendingVendor2Id,
      ),
      _storedUser(
        id: pendingUser3Id,
        fullName: 'Anil Shrestha',
        email: 'anil.himalaya@placeify.demo',
        vendorStatus: VendorStatus.pending,
        vendorId: pendingVendor3Id,
      ),
      _storedUser(
        id: approvedUserId,
        fullName: 'Maya Rai',
        email: 'maya.harmony@placeify.demo',
        vendorStatus: VendorStatus.approved,
        vendorId: approvedVendorId,
      ),
      _storedUser(
        id: suspendedUserId,
        fullName: 'Bikash Koirala',
        email: 'bikash.legacy@placeify.demo',
        vendorStatus: VendorStatus.suspended,
        vendorId: suspendedVendorId,
      ),
    ];

    final merged = [...existing];
    for (final seed in seedUsers) {
      final email = seed['email'] as String;
      if (!merged.any((u) => u['email'] == email)) {
        merged.add(seed);
      }
    }

    await prefs.setString(authUsersKey, jsonEncode(merged));
  }

  static Future<void> _seedRegistrations(SharedPreferences prefs) async {
    final existing = _loadJsonMap(prefs.getString(registrationsKey));
    final submitted = {
      pendingVendor1Id: DateTime(2026, 6, 8, 10, 35),
      pendingVendor2Id: DateTime(2026, 6, 7, 14, 20),
      pendingVendor3Id: DateTime(2026, 6, 6, 9, 5),
      approvedVendorId: DateTime(2026, 3, 15, 11, 30),
      suspendedVendorId: DateTime(2026, 2, 20, 17, 0),
    };

    final seedRegistrations = {
      pendingVendor1Id: _registrationEntry(
        vendorId: pendingVendor1Id,
        submittedAt: submitted[pendingVendor1Id]!,
        registration: VendorRegistration(
          business: const VendorBusinessInfo(
            businessName: 'Kathmandu Crafts Co.',
            contactName: 'Ramesh Thapa',
            email: 'ramesh.crafts@placeify.demo',
            phone: '+977 9811111111',
            taxId: 'PAN-123456789',
          ),
          address: const VendorAddress(
            street: 'Thamel Marg 12',
            city: 'Kathmandu',
            state: 'Bagmati',
            postalCode: '44600',
            country: 'Nepal',
          ),
          category: const VendorCategoryInfo(
            categories: ['Handicrafts'],
            description: 'Traditional Nepali crafts and souvenirs.',
          ),
          documents: const VendorDocuments(
            businessLicensePath: '/mock/docs/kathmandu-license.pdf',
            governmentIdPath: '/mock/docs/ramesh-id.pdf',
          ),
          bank: const VendorBankDetails(
            accountHolderName: 'Ramesh Thapa',
            bankName: 'Nepal Investment Bank',
            accountNumber: '0123456789',
            routingNumber: 'NIBLNPKA',
          ),
        ),
      ),
      pendingVendor2Id: _registrationEntry(
        vendorId: pendingVendor2Id,
        submittedAt: submitted[pendingVendor2Id]!,
        registration: VendorRegistration(
          business: const VendorBusinessInfo(
            businessName: 'Nepal Nest Furniture',
            contactName: 'Sunita Gurung',
            email: 'sunita.nest@placeify.demo',
            phone: '+977 9822222222',
            taxId: 'PAN-987654321',
          ),
          address: const VendorAddress(
            street: 'Lakeside Road 4',
            city: 'Pokhara',
            state: 'Gandaki',
            postalCode: '33700',
            country: 'Nepal',
          ),
          category: const VendorCategoryInfo(
            categories: ['Furniture'],
            description: 'Locally sourced wooden furniture.',
          ),
          documents: const VendorDocuments(
            businessLicensePath: '/mock/docs/nest-license.pdf',
            taxCertificatePath: '/mock/docs/nest-tax.pdf',
          ),
          bank: const VendorBankDetails(
            accountHolderName: 'Sunita Gurung',
            bankName: 'Global IME Bank',
            accountNumber: '9876543210',
            routingNumber: 'GLBBNPKA',
          ),
        ),
      ),
      pendingVendor3Id: _registrationEntry(
        vendorId: pendingVendor3Id,
        submittedAt: submitted[pendingVendor3Id]!,
        registration: VendorRegistration(
          business: const VendorBusinessInfo(
            businessName: 'Himalayan Home Decor',
            contactName: 'Anil Shrestha',
            email: 'anil.himalaya@placeify.demo',
            phone: '+977 9833333333',
          ),
          address: const VendorAddress(
            street: 'Durbar Marg 8',
            city: 'Kathmandu',
            state: 'Bagmati',
            postalCode: '44600',
            country: 'Nepal',
          ),
          category: const VendorCategoryInfo(
            categories: ['Decor'],
            description: 'Modern decor inspired by Himalayan aesthetics.',
          ),
          documents: const VendorDocuments(
            governmentIdPath: '/mock/docs/anil-id.pdf',
          ),
          bank: const VendorBankDetails(
            accountHolderName: 'Anil Shrestha',
            bankName: 'Nabil Bank',
            accountNumber: '5555666677',
            routingNumber: 'NARBNPKA',
          ),
        ),
      ),
      approvedVendorId: _registrationEntry(
        vendorId: approvedVendorId,
        submittedAt: submitted[approvedVendorId]!,
        registration: VendorRegistration(
          business: const VendorBusinessInfo(
            businessName: 'Harmony Home Furnishings',
            contactName: 'Maya Rai',
            email: 'maya.harmony@placeify.demo',
            phone: '+977 9844444444',
            taxId: 'PAN-555666777',
          ),
          address: const VendorAddress(
            street: 'Lazimpat',
            city: 'Kathmandu',
            state: 'Bagmati',
            postalCode: '44600',
            country: 'Nepal',
          ),
          category: const VendorCategoryInfo(
            categories: ['Furniture'],
            description: 'Curated modern furniture for Nepali homes.',
          ),
          documents: const VendorDocuments(
            businessLicensePath: '/mock/docs/harmony-license.pdf',
            governmentIdPath: '/mock/docs/maya-id.pdf',
            taxCertificatePath: '/mock/docs/harmony-tax.pdf',
          ),
          bank: const VendorBankDetails(
            accountHolderName: 'Maya Rai',
            bankName: 'Standard Chartered',
            accountNumber: '1111222233',
            routingNumber: 'SCBLNPKA',
          ),
        ),
      ),
      suspendedVendorId: _registrationEntry(
        vendorId: suspendedVendorId,
        submittedAt: submitted[suspendedVendorId]!,
        registration: VendorRegistration(
          business: const VendorBusinessInfo(
            businessName: 'Legacy Imports',
            contactName: 'Bikash Koirala',
            email: 'bikash.legacy@placeify.demo',
            phone: '+977 9855555555',
            taxId: 'PAN-111222333',
          ),
          address: const VendorAddress(
            street: 'New Road 22',
            city: 'Kathmandu',
            state: 'Bagmati',
            postalCode: '44600',
            country: 'Nepal',
          ),
          category: const VendorCategoryInfo(
            categories: ['General'],
            description: 'Imported household goods.',
          ),
          documents: const VendorDocuments(
            businessLicensePath: '/mock/docs/legacy-license.pdf',
          ),
          bank: const VendorBankDetails(
            accountHolderName: 'Bikash Koirala',
            bankName: 'Himalayan Bank',
            accountNumber: '4444555566',
            routingNumber: 'HIMANPKA',
          ),
        ),
      ),
    };

    existing.addAll(seedRegistrations);
    await prefs.setString(registrationsKey, jsonEncode(existing));
  }

  static Future<void> _seedNotifications(SharedPreferences prefs) async {
    if (prefs.getString(notificationsKey) != null) return;

    final notifications = [
      AdminNotification(
        id: 'admin-n1',
        title: 'New vendor application',
        body: 'Kathmandu Crafts Co. submitted a registration request.',
        createdAt: DateTime(2026, 6, 8, 10, 40),
        type: AdminNotificationType.newApplication,
        linkedVendorId: pendingVendor1Id,
      ),
      AdminNotification(
        id: 'admin-n2',
        title: 'New vendor application',
        body: 'Nepal Nest Furniture is awaiting review.',
        createdAt: DateTime(2026, 6, 7, 14, 25),
        type: AdminNotificationType.newApplication,
        linkedVendorId: pendingVendor2Id,
      ),
      AdminNotification(
        id: 'admin-n3',
        title: 'Vendor suspended',
        body: 'Legacy Imports was suspended for policy review.',
        createdAt: DateTime(2026, 5, 28, 9, 0),
        read: true,
        type: AdminNotificationType.vendorFlagged,
        linkedVendorId: suspendedVendorId,
      ),
    ];

    await prefs.setString(
      notificationsKey,
      jsonEncode(notifications.map((n) => n.toJson()).toList()),
    );
  }

  static Map<String, dynamic> _registrationEntry({
    required String vendorId,
    required DateTime submittedAt,
    required VendorRegistration registration,
  }) {
    return {
      'vendorId': vendorId,
      'submittedAt': submittedAt.toIso8601String(),
      ...registration.toJson(),
    };
  }

  static Map<String, dynamic> _storedUser({
    required String id,
    required String fullName,
    required String email,
    required VendorStatus vendorStatus,
    required String vendorId,
  }) {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'password': 'demo1234',
      'role': UserRole.customer.name,
      'vendorStatus': vendorStatus.name,
      'vendorId': vendorId,
    };
  }

  static List<Map<String, dynamic>> _loadJsonList(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  static Map<String, dynamic> _loadJsonMap(String? raw) {
    if (raw == null || raw.isEmpty) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return Map<String, dynamic>.from(decoded);
  }
}
