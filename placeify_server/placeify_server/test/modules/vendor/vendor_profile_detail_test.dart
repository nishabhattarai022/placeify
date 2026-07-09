import 'package:placeify_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('VendorProfileDetail contract', () {
    test('includes all fields required by the vendor profile screen', () {
      final vendorId = UuidValue.fromString('01930000-0000-7000-8000-000000000002');
      final userId = UuidValue.fromString('01930000-0000-7000-8000-000000000001');
      final createdAt = DateTime.utc(2026, 1, 15);

      final detail = VendorProfileDetail(
        id: vendorId,
        businessName: 'Anisha Furniture',
        email: 'shop@example.com',
        phone: '+9779800000000',
        address: 'Patan, Lalitpur',
        city: 'Lalitpur',
        country: 'Nepal',
        category: 'furniture',
        logoUrl: '/uploads/logo.jpg',
        bio: 'Handcrafted wood furniture',
        bannerUrl: '/uploads/banner.jpg',
        coverUrl: '/uploads/cover.jpg',
        instagramHandle: '@anisha',
        facebookHandle: 'anisha.furniture',
        operatingHours: 'Sun-Fri 10:00-18:00',
        isOpen: true,
        status: UserAccountStatus.approved,
        totalProducts: 5,
        totalOrders: 3,
        totalRevenue: 1200,
        notificationPreferences: NotificationPreference(userId: userId),
        createdAt: createdAt,
      );

      expect(detail.businessName, 'Anisha Furniture');
      expect(detail.city, 'Lalitpur');
      expect(detail.country, 'Nepal');
      expect(detail.status, UserAccountStatus.approved);
      expect(detail.totalRevenue, 1200);
    });
  });
}
