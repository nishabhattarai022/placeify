import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_registration.dart';

part 'vendor_application.freezed.dart';
part 'vendor_application.g.dart';

/// Vendor onboarding application joined from auth user status and registration data.
@freezed
abstract class VendorApplication with _$VendorApplication {
  const factory VendorApplication({
    required String vendorId,
    required String userId,
    required String businessName,
    required String contactEmail,
    required DateTime submittedAt,
    required VendorRegistration registration,
    required VendorStatus status,
    String? moderationNote,
    DateTime? moderatedAt,
  }) = _VendorApplication;

  factory VendorApplication.fromJson(Map<String, dynamic> json) =>
      _$VendorApplicationFromJson(json);
}
