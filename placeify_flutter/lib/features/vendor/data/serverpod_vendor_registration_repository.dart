import 'dart:convert';

import 'package:placeify_client/placeify_client.dart';
import 'package:placeify_flutter/core/config/placeify_server_client.dart';
import 'package:placeify_flutter/features/admin/data/config/admin_seed_data.dart';
import 'package:placeify_flutter/features/admin/domain/enums/admin_notification_type.dart';
import 'package:placeify_flutter/features/admin/domain/models/admin_notification.dart';
import 'package:placeify_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:placeify_flutter/features/vendor/domain/constants/vendor_registration_field_keys.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_registration.dart';
import 'package:placeify_flutter/features/vendor/domain/repositories/vendor_registration_repository.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists vendor registration submissions to PostgreSQL via [client.vendor.createShop].
class ServerpodVendorRegistrationRepository
    implements VendorRegistrationRepository {
  ServerpodVendorRegistrationRepository(this._authRepository, this._prefs);

  final AuthRepository _authRepository;
  final SharedPreferences _prefs;

  static const _registrationsKey = 'placeify_vendor_registrations';

  @override
  bool simulateNetworkError = false;

  @override
  Future<String> submitRegistration(VendorRegistration registration) async {
    if (simulateNetworkError) {
      throw VendorRegistrationException(
        'Could not submit registration. Check your connection and try again.',
      );
    }

    if (!client.auth.isAuthenticated) {
      throw VendorRegistrationException('Sign in to register as a vendor.');
    }

    final business = registration.business;
    final address = registration.address;
    final category = registration.category;

    final shopName = business.businessName.trim();
    final phone = business.phone.trim();
    final categoryName = category.category.trim();
    final streetLine = address.street.trim();
    final city = address.city.trim();
    final country = address.country.trim();

    final fullAddress = [
      streetLine,
      if (city.isNotEmpty) city,
      if (address.state.trim().isNotEmpty) address.state.trim(),
      if (address.postalCode.trim().isNotEmpty) address.postalCode.trim(),
      if (country.isNotEmpty) country,
    ].join(', ');

    if (shopName.isEmpty ||
        phone.isEmpty ||
        categoryName.isEmpty ||
        fullAddress.isEmpty) {
      throw VendorRegistrationException(
        'Complete all required fields before submitting.',
      );
    }

    if (!isUploadedVendorDocument(registration.documents.businessLicensePath) ||
        !isUploadedVendorDocument(registration.documents.governmentIdPath)) {
      throw VendorRegistrationException(
        'Upload all required verification documents before submitting.',
      );
    }

    final description = category.description.trim().isNotEmpty
        ? category.description.trim()
        : '$shopName — ${category.category.trim()} vendor on Placeify.';

    try {
      final vendor = await client.vendor.createShop(
        shopName,
        description: description,
        phone: phone,
        address: fullAddress,
        city: city.isEmpty ? null : city,
        country: country.isEmpty ? null : country,
        shopCategory: category.category.trim(),
      );

      final vendorId = vendor.id.toString();

      try {
        await _authRepository.updateVendorStatus(
          status: VendorStatus.pending,
          vendorId: vendorId,
        );
      } catch (_) {
        // Shop is already persisted; profile refresh will sync vendor state.
      }

      await _persistRegistration(vendorId, registration);
      await _appendAdminNotification(
        vendorId: vendorId,
        businessName: shopName,
      );

      return vendorId;
    } catch (error) {
      throw VendorRegistrationException(_mapError(error));
    }
  }

  String _mapError(Object error) {
    if (error is VendorRegistrationException) return error.message;
    if (error is PlaceifyException) {
      return switch (error.code) {
        'VENDOR_EXISTS' =>
          'You already have a vendor shop linked to this account.',
        'INVALID_SHOP_NAME' => 'Enter your business name.',
        'INVALID_DESCRIPTION' ||
        'INVALID_SHOP_DESCRIPTION' =>
          'Add a short store description.',
        'INVALID_PHONE' || 'INVALID_PHONE_FORMAT' =>
          'Enter a valid phone number.',
        'INVALID_ADDRESS' || 'MISSING_REQUIRED_FIELD' =>
          error.message,
        'BUSINESS_NAME_TOO_SHORT' => error.message,
        'BUSINESS_NAME_TOO_LONG' => error.message,
        _ => error.message,
      };
    }

    final raw = error.toString();
    if (raw.toLowerCase().contains('socketexception') ||
        raw.toLowerCase().contains('connection refused')) {
      return 'Cannot reach the server. Make sure placeify_server is running.';
    }
    return 'Could not submit registration. Please try again.';
  }

  Future<void> _appendAdminNotification({
    required String vendorId,
    required String businessName,
  }) async {
    final raw = _prefs.getString(AdminSeedData.notificationsKey);
    final existing = <AdminNotification>[];
    if (raw != null && raw.isNotEmpty) {
      final list = jsonDecode(raw) as List<dynamic>;
      existing.addAll(
        list.map(
          (e) => AdminNotification.fromJson(e as Map<String, dynamic>),
        ),
      );
    }

    existing.insert(
      0,
      AdminNotification(
        id: 'admin-n-${DateTime.now().millisecondsSinceEpoch}',
        title: 'New vendor application',
        body: '$businessName submitted a registration request.',
        createdAt: DateTime.now(),
        type: AdminNotificationType.newApplication,
        linkedVendorId: vendorId,
      ),
    );

    await _prefs.setString(
      AdminSeedData.notificationsKey,
      jsonEncode(existing.map((n) => n.toJson()).toList()),
    );
  }

  Future<void> _persistRegistration(
    String vendorId,
    VendorRegistration registration,
  ) async {
    final existing = _loadRegistrations();
    existing[vendorId] = {
      'vendorId': vendorId,
      'submittedAt': DateTime.now().toIso8601String(),
      ...registration.toJson(),
    };
    await _prefs.setString(_registrationsKey, jsonEncode(existing));
  }

  Map<String, dynamic> _loadRegistrations() {
    final raw = _prefs.getString(_registrationsKey);
    if (raw == null || raw.isEmpty) return {};

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return Map<String, dynamic>.from(decoded);
  }
}
