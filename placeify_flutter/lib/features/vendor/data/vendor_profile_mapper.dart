import 'dart:convert';

import 'package:placeify_client/placeify_client.dart' as api;

import '../../../core/config/placeify_server_client.dart';
import '../domain/models/vendor_operating_day.dart';
import '../domain/models/vendor_profile.dart';
import '../domain/models/vendor_social_links.dart';

/// Maps vendor profile API models to Flutter domain models.
abstract final class VendorProfileMapper {
  static VendorProfile fromApiDetail(api.VendorProfileDetail detail) {
    return VendorProfile(
      id: detail.id.toString(),
      businessName: detail.businessName,
      email: detail.email,
      phone: detail.phone,
      address: detail.address,
      city: detail.city,
      country: detail.country,
      logoUrl: _resolveMediaUrl(detail.logoUrl),
      bio: detail.bio,
      bannerUrl: _resolveMediaUrl(detail.bannerUrl),
      coverUrl: _resolveMediaUrl(detail.coverUrl),
      isOpen: detail.isOpen,
      tags: detail.category.trim().isEmpty ? const [] : [detail.category],
      schedule: _decodeSchedule(detail.operatingHours),
      socialLinks: VendorSocialLinks(
        instagram: detail.instagramHandle,
        facebook: detail.facebookHandle,
        website: _decodeWebsite(detail.operatingHours),
      ),
      createdAt: detail.createdAt,
    );
  }

  static api.VendorProfileUpdateInput toUpdateInput(VendorProfile profile) {
    final category = profile.tags.isNotEmpty
        ? profile.tags.first
        : null;

    return api.VendorProfileUpdateInput(
      businessName: profile.businessName,
      phone: profile.phone,
      address: profile.address,
      city: profile.city,
      country: profile.country,
      category: category,
      bio: profile.bio,
      logoUrl: _isRemoteUrl(profile.logoUrl) ? profile.logoUrl : null,
      bannerUrl: _isRemoteUrl(profile.bannerUrl) ? profile.bannerUrl : null,
      coverUrl: _isRemoteUrl(profile.coverUrl) ? profile.coverUrl : null,
      isOpen: profile.isOpen,
      instagramHandle: profile.socialLinks.instagram,
      facebookHandle: profile.socialLinks.facebook,
      operatingHours: _encodeSchedule(profile.schedule, profile.socialLinks.website),
    );
  }

  static String? _resolveMediaUrl(String? url) {
    if (url == null || url.trim().isEmpty) return null;
    final trimmed = url.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    if (trimmed.startsWith('/')) {
      return '$serverUrl$trimmed';
    }
    return trimmed;
  }

  static bool _isRemoteUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    return url.startsWith('http://') || url.startsWith('https://');
  }

  static List<VendorOperatingDay> _decodeSchedule(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return defaultVendorWeekSchedule();
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        final schedule = decoded['schedule'];
        if (schedule is List) {
          return [
            for (final item in schedule)
              if (item is Map<String, dynamic>)
                VendorOperatingDay.fromJson(item),
          ];
        }
      }
      if (decoded is List) {
        return [
          for (final item in decoded)
            if (item is Map<String, dynamic>)
              VendorOperatingDay.fromJson(item),
        ];
      }
    } catch (_) {
      // Legacy plain-text hours remain readable in the UI via bio/summary helpers.
    }

    return defaultVendorWeekSchedule();
  }

  static String _decodeWebsite(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '';
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded['website'] as String? ?? '';
      }
    } catch (_) {}
    return '';
  }

  /// Persists schedule JSON plus optional website without adding new DB columns.
  static String _encodeSchedule(
    List<VendorOperatingDay> schedule,
    String website,
  ) {
    return jsonEncode({
      'schedule': schedule.map((day) => day.toJson()).toList(),
      if (website.trim().isNotEmpty) 'website': website.trim(),
    });
  }
}
