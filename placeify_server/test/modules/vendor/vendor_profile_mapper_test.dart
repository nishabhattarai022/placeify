import 'package:placeify_server/src/generated/protocol.dart';
import 'package:placeify_server/src/modules/vendor/vendor_profile_mapper.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('VendorProfileMapper', () {
    late User user;
    late Vendor vendor;
    late NotificationPreference notificationPreferences;

    setUp(() {
      final userId = UuidValue.fromString('01930000-0000-7000-8000-000000000001');
      final vendorId = UuidValue.fromString('01930000-0000-7000-8000-000000000002');
      final createdAt = DateTime.utc(2026, 1, 15);

      user = User(
        id: userId,
        authUserId: UuidValue.fromString('01930000-0000-7000-8000-000000000003'),
        name: 'Anisha Furniture',
        email: 'shop@example.com',
        phone: '+9779800000000',
        address: 'Fallback address',
        role: UserRole.vendor,
        status: UserAccountStatus.approved,
        createdAt: createdAt,
        updatedAt: createdAt,
      );

      vendor = Vendor(
        id: vendorId,
        userId: userId,
        shopName: 'Anisha Furniture',
        description: 'Handcrafted wood furniture',
        businessAddress: 'Patan, Lalitpur',
        city: 'Lalitpur',
        country: 'Nepal',
        shopCategory: 'furniture',
        logoUrl: '/uploads/logo.jpg',
        bannerUrl: '/uploads/banner.jpg',
        coverUrl: '/uploads/cover.jpg',
        instagramHandle: '@anisha',
        facebookHandle: 'anisha.furniture',
        operatingHours: '{"schedule":[]}',
        isOpen: true,
        createdAt: createdAt,
        updatedAt: createdAt,
      );

      notificationPreferences = NotificationPreference(
        userId: userId,
        orderUpdates: true,
        refundStatus: true,
      );
    });

    test('maps vendor, user, metrics, and notification preferences', () {
      const metrics = (
        totalProducts: 12,
        totalOrders: 8,
        totalRevenue: 24500.0,
      );

      final detail = VendorProfileMapper.toDetail(
        vendor: vendor,
        user: user,
        metrics: metrics,
        notificationPreferences: notificationPreferences,
      );

      expect(detail.businessName, 'Anisha Furniture');
      expect(detail.email, 'shop@example.com');
      expect(detail.city, 'Lalitpur');
      expect(detail.country, 'Nepal');
      expect(detail.coverUrl, '/uploads/cover.jpg');
      expect(detail.isOpen, isTrue);
      expect(detail.status, UserAccountStatus.approved);
      expect(detail.totalProducts, 12);
      expect(detail.totalOrders, 8);
      expect(detail.totalRevenue, 24500.0);
      expect(detail.notificationPreferences?.orderUpdates, isTrue);
    });
  });
}
