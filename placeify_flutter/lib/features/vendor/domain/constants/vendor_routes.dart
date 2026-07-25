abstract final class VendorRoutes {
  static const prefix = '/vendor';
  static const dashboard = '/vendor';
  static const orders = '/vendor/orders';
  static const ordersAll = '/vendor/orders?view=all';

  static String orderDetail(String orderId) => '$orders/$orderId';

  static String deliveryUpdate(String orderId) =>
      '${orderDetail(orderId)}/delivery-update';

  static const analytics = '/vendor/analytics';
  static const reviews = '/vendor/reviews';
  static const products = '/vendor/products';
  static const productsUpload = '/vendor/products/upload';
  static const productsBuild3d = '/vendor/products/build-3d';
  static const productsUpload3d = '/vendor/products/upload-3d';

  static String productsBuild3dFor(String? productId) {
    if (productId == null || productId.isEmpty) {
      return productsBuild3d;
    }
    return '$productsBuild3d?productId=$productId';
  }

  static String productEdit(String productId) => '$products/$productId/edit';
  static const payments = '/vendor/payments';
  static const messages = '/vendor/messages';
  static const notifications = '/vendor/notifications';
  static const profile = '/vendor/profile';

  static String messageChat(String conversationId) =>
      '$messages/$conversationId';
  static const settings = '$profile/settings';
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

  /// Tab roots plus the dashboard "See all orders" list view.
  static bool isOrdersListView(Uri uri) =>
      uri.path == orders && uri.queryParameters['view'] == 'all';
}
