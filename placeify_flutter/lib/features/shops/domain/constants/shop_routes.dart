abstract final class ShopRoutes {
  static const shops = '/shops';

  static String shopDetail(String vendorId) => '$shops/$vendorId';
}
