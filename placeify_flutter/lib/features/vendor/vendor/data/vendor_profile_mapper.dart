import 'dart:convert';

import 'package:placeify_client/placeify_client.dart' as api;

import '../../../core/config/placeify_server_client.dart';
import '../domain/models/vendor_operating_day.dart';
import '../domain/models/vendor_profile.dart';
import '../domain/models/vendor_social_links.dart';
import 'vendor_shop_category_codec.dart';

/// Maps vendor profile API models to Flutter domain models.
abstract final class VendorProfileMapper {
  static VendorProfile fromApiDetail(api.VendorProfileDetail detail) {
    return VendorProfile(
      id: detail.id.toString(),
      businessName: detail.businessName,
      email: detail.email,
      phone: detail.phone,
      address: _formatAddress(detail.address, detail.city, detail.country),
      logoUrl: _resolveMediaUrl(detail.logoUrl),
      bio: detail.bio,
      bannerUrl: _resolveMediaUrl(detail.coverUrl ?? detail.bannerUrl),
      tags: VendorShopCategoryCodec.decode(detail.category),
      schedule: _decodeSchedule(detail.operatingHours),
      socialLinks: VendorSocialLinks(
        instagram: detail.instagramHandle,
        facebook: detail.facebookHandle,
        website: _decodeWebsite(detail.operatingHours),
      ),
      createdAt: detail.createdAt,
    );
  }

  static String _formatAddress(String address, String? city, String? country) {
    return [
      address.trim(),
      if (city != null && city.trim().isNotEmpty) city.trim(),
      if (country != null && country.trim().isNotEmpty) country.trim(),
    ].join(', ');
  }

  static api.VendorProfileUpdateInput toUpdateInput(VendorProfile profile) {
    final category = profile.tags.isNotEmpty
        ? VendorShopCategoryCodec.encode(profile.tags)
        : null;

    return api.VendorProfileUpdateInput(
      businessName: profile.businessName,
      email: profile.email.trim().isEmpty ? null : profile.email.trim(),
      phone: profile.phone,
      address: profile.address,
      category: category,
      bio: profile.bio,
      logoUrl: _isRemoteUrl(profile.logoUrl) ? profile.logoUrl : null,
      bannerUrl: _isRemoteUrl(profile.bannerUrl) ? profile.bannerUrl : null,
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
      // Static uploads are served by the Serverpod web server (port 8082).
      final apiUri = Uri.parse(serverUrl);
      final segments =
          trimmed.split('/').where((segment) => segment.isNotEmpty).toList();
      return Uri(
        scheme: apiUri.scheme,
        host: apiUri.host,
        port: 8082,
        pathSegments: segments,
      ).toString();
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
