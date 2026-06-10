abstract final class VendorRoutes {
  static const prefix = '/vendor';
  static const dashboard = '/vendor';
  static const orders = '/vendor/orders';
  static const products = '/vendor/products';
  static const payments = '/vendor/payments';
  static const profile = '/vendor/profile';
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
