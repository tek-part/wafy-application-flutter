// Routes constants for GetX navigation
abstract class Routes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const home = '/home';

  // Home tabs and subroutes
  static const orders = '/orders';
  static const orderDetails = '/orders/details';
  static const printOrder = '/orders/print';
  static const menu = '/menu';
  static const tables = '/tables';

  // Table details routes
  static const tableDetails = '/tables/details';
  static const tableInvoice = '/tables/invoice';
  static const tableAddItems = '/tables/add-items';

  // Settings route
  static const settings = '/settings';

  // Legacy routes (deprecated - use tableDetails instead)
  static const tableOrders = '/tables/orders';
}
