import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:placeify/features/vendor/domain/models/vendor_operating_day.dart';
import 'package:placeify/features/vendor/domain/models/vendor_social_links.dart';

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
    String? logoUrl,
    @Default('') String bio,
    String? bannerUrl,
    @Default([]) List<String> tags,
    @Default([]) List<VendorOperatingDay> schedule,
    @Default(VendorSocialLinks()) VendorSocialLinks socialLinks,
    required DateTime createdAt,
  }) = _VendorProfile;

  factory VendorProfile.fromJson(Map<String, dynamic> json) =>
      _$VendorProfileFromJson(_migrateVendorProfileJson(json));
}

Map<String, dynamic> _migrateVendorProfileJson(Map<String, dynamic> json) {
  final migrated = Map<String, dynamic>.from(json);

  final tags = migrated['tags'];
  if (tags == null || (tags is List && tags.isEmpty)) {
    final category = migrated.remove('category');
    if (category is String && category.trim().isNotEmpty) {
      migrated['tags'] = [category];
    }
  } else {
    migrated.remove('category');
  }

  final schedule = migrated['schedule'];
  if (schedule == null || (schedule is List && schedule.isEmpty)) {
    migrated.remove('operatingHours');
    migrated['schedule'] = defaultVendorWeekSchedule()
        .map((day) => day.toJson())
        .toList();
  } else {
    migrated.remove('operatingHours');
  }

  if (migrated['socialLinks'] == null) {
    migrated['socialLinks'] = VendorSocialLinks(
      instagram: migrated.remove('instagramHandle') as String? ?? '',
      facebook: migrated.remove('facebookHandle') as String? ?? '',
      website: migrated.remove('websiteUrl') as String? ?? '',
    ).toJson();
  } else {
    migrated.remove('instagramHandle');
    migrated.remove('facebookHandle');
    migrated.remove('websiteUrl');
  }

  return migrated;
}
