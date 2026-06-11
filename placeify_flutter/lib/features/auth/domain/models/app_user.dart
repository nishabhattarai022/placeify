import 'package:placeify_client/placeify_client.dart';

import '../../../vendor/domain/enums/vendor_status.dart';

/// Authenticated Placeify user returned from the auth backend.
class AppUser {
  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.phone,
    this.address,
    this.hasVendorShop = false,
    this.registeredVendorStatus,
    this.registeredVendorId,
  });

  final String id;
  final String fullName;
  final String email;
  final UserRole role;
  final String? phone;
  final String? address;
  final bool hasVendorShop;
  final VendorStatus? registeredVendorStatus;
  final String? registeredVendorId;

  bool get isVendorMode => role == UserRole.vendor;

  bool get canOpenVendorDashboard => hasVendorShop;

  /// Maps serverpod shop state to the Nishabhattarai vendor UI model.
  VendorStatus get vendorStatus {
    if (registeredVendorStatus != null) return registeredVendorStatus!;
    if (!hasVendorShop) return VendorStatus.none;
    return VendorStatus.approved;
  }

  /// Mock vendor frontend uses a fixed demo vendor id for seed data.
  String? get vendorId {
    if (registeredVendorId != null) return registeredVendorId;
    return hasVendorShop ? 'demo-vendor' : null;
  }

  AppUser copyWith({
    String? id,
    String? fullName,
    String? email,
    UserRole? role,
    String? phone,
    String? address,
    bool? hasVendorShop,
    VendorStatus? registeredVendorStatus,
    String? registeredVendorId,
  }) {
    return AppUser(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      hasVendorShop: hasVendorShop ?? this.hasVendorShop,
      registeredVendorStatus:
          registeredVendorStatus ?? this.registeredVendorStatus,
      registeredVendorId: registeredVendorId ?? this.registeredVendorId,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'role': role.name,
        'phone': phone,
        'address': address,
        'hasVendorShop': hasVendorShop,
      };

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      role: UserRole.fromJson(json['role'] as String),
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      hasVendorShop: json['hasVendorShop'] as bool? ?? false,
    );
  }
}
