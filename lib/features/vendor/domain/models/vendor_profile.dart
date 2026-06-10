import 'package:freezed_annotation/freezed_annotation.dart';

part 'vendor_profile.freezed.dart';
part 'vendor_profile.g.dart';

@freezed
abstract class VendorProfile with _$VendorProfile {
  const factory VendorProfile({
    required String id,
    required String businessName,
    required String email,
    required String phone,
    required String address,
    required String category,
    String? logoUrl,
    required DateTime createdAt,
  }) = _VendorProfile;

  factory VendorProfile.fromJson(Map<String, dynamic> json) =>
      _$VendorProfileFromJson(json);
}
