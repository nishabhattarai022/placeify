import '../../generated/protocol.dart';

/// Aggregated vendor metrics loaded without relation includes (avoids N+1).
typedef VendorProfileMetrics = ({
  int totalProducts,
  int totalOrders,
  double totalRevenue,
});

/// Maps persisted vendor/user rows into [VendorProfileDetail].
abstract final class VendorProfileMapper {
  static VendorProfileDetail toDetail({
    required Vendor vendor,
    required User user,
    required VendorProfileMetrics metrics,
    NotificationPreference? notificationPreferences,
  }) {
    return VendorProfileDetail(
      id: vendor.id!,
      businessName: vendor.shopName,
      email: vendor.contactEmail ?? user.email ?? '',
      phone: user.phone ?? '',
      address: vendor.businessAddress ?? user.address ?? '',
      city: vendor.city ?? '',
      country: vendor.country ?? '',
      category: vendor.shopCategory ?? '',
      logoUrl: vendor.logoUrl,
      bio: vendor.description ?? '',
      bannerUrl: vendor.bannerUrl,
      coverUrl: vendor.coverUrl,
      instagramHandle: vendor.instagramHandle ?? '',
      facebookHandle: vendor.facebookHandle ?? '',
      operatingHours: vendor.operatingHours ?? '',
      isOpen: vendor.isOpen,
      status: user.status,
      moderationNote: vendor.moderationNote,
      appealMessage: vendor.appealMessage,
      appealSubmittedAt: vendor.appealSubmittedAt,
      totalProducts: metrics.totalProducts,
      totalOrders: metrics.totalOrders,
      totalRevenue: metrics.totalRevenue,
      notificationPreferences: notificationPreferences,
      createdAt: vendor.createdAt,
    );
  }
}
