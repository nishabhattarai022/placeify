import 'package:placeify_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('VendorProfileDetail mapping', () {
    test('maps vendor and user fields for the Flutter profile screen', () {
      final authUserId = UuidValue.fromString('01930000-0000-7000-8000-000000000003');
      final userId = UuidValue.fromString('01930000-0000-7000-8000-000000000001');
      final vendorId = UuidValue.fromString('01930000-0000-7000-8000-000000000002');
      final createdAt = DateTime.utc(2026, 1, 15);

      final user = User(
        id: userId,
        authUserId: authUserId,
        name: 'Anisha Furniture',
        email: 'shop@example.com',
        phone: '+9779800000000',
        address: 'Fallback address',
        role: UserRole.vendor,
        status: UserAccountStatus.approved,
        createdAt: createdAt,
        updatedAt: createdAt,
      );

      final vendor = Vendor(
        id: vendorId,
        userId: userId,
        shopName: 'Anisha Furniture',
        description: 'Handcrafted wood furniture',
        businessAddress: 'Lalitpur, Nepal',
        shopCategory: 'furniture',
        logoUrl: '/uploads/logo.jpg',
        bannerUrl: '/uploads/banner.jpg',
        instagramHandle: '@anisha',
        facebookHandle: 'anisha.furniture',
        operatingHours: 'Sun-Fri 10:00-18:00',
        createdAt: createdAt,
        updatedAt: createdAt,
      );

      final detail = VendorProfileDetail(
        id: vendor.id!,
        businessName: vendor.shopName,
        email: user.email ?? '',
        phone: user.phone ?? '',
        address: vendor.businessAddress ?? user.address ?? '',
        category: vendor.shopCategory ?? '',
        logoUrl: vendor.logoUrl,
        bio: vendor.description ?? '',
        bannerUrl: vendor.bannerUrl,
        instagramHandle: vendor.instagramHandle ?? '',
        facebookHandle: vendor.facebookHandle ?? '',
        operatingHours: vendor.operatingHours ?? '',
        createdAt: vendor.createdAt,
      );

      expect(detail.businessName, 'Anisha Furniture');
      expect(detail.email, 'shop@example.com');
      expect(detail.category, 'furniture');
      expect(detail.bio, 'Handcrafted wood furniture');
      expect(detail.instagramHandle, '@anisha');
      expect(detail.operatingHours, 'Sun-Fri 10:00-18:00');
    });
  });
}
