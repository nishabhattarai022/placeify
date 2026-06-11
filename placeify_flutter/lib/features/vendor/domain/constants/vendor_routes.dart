abstract final class VendorRoutes {
  static const prefix = '/vendor';
  static const dashboard = '/vendor';
  static const orders = '/vendor/orders';

  static String orderDetail(String orderId) => '$orders/$orderId';

  static String deliveryUpdate(String orderId) =>
      '${orderDetail(orderId)}/delivery-update';

  static const analytics = '/vendor/analytics';
  static const reviews = '/vendor/reviews';
  static const products = '/vendor/products';
  static const productsUpload = '/vendor/products/upload';

  static String productEdit(String productId) => '$products/$productId/edit';
  static const payments = '/vendor/payments';
  static const notifications = '/vendor/notifications';
  static const profile = '/vendor/profile';
  static const settings = '/vendor/settings';
  static const register = '/vendor/register';
  static const registerSuccess = '/vendor/register/success';
  static const profileFallback = '/profile';

  /// Tab roots that show the vendor bottom navigation bar.
  static const tabRoots = {
    dashboard,
    orders,
    products,
    payments,
    profile,
  };
}
