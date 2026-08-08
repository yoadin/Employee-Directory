// Core application constants — API endpoints, storage keys, durations.

class AppConstants {
  AppConstants._();

  // API
  static const String baseUrl = 'https://fakestoreapi.com';
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // SharedPreferences keys
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';

  // Hive box names
  static const String cartBox = 'cart_box';
  static const String productsBox = 'products_box';

  // Hive type IDs
  static const int cartItemTypeId = 0;
  static const int productCacheTypeId = 1;

  // Search debounce
  static const Duration searchDebounce = Duration(milliseconds: 400);

  // Grid
  static const int phoneGridColumns = 2;
  static const int tabletGridColumns = 3;
  static const double tabletBreakpoint = 600.0;
}
