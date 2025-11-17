import 'package:get/get.dart';
import 'package:wafy/app/middlewares/auth_middleware.dart';
import 'package:wafy/app/routes/app_routes.dart';
import 'package:wafy/features/auth/presentation/bindings/login_binding.dart';
import 'package:wafy/features/auth/presentation/pages/login_page.dart';
import 'package:wafy/features/home/presentation/bindings/home_binding.dart';
import 'package:wafy/features/home/presentation/pages/home_page.dart';
import 'package:wafy/features/home/presentation/pages/print_order_page.dart';
import 'package:wafy/features/menu/presentation/bindings/menu_binding.dart';
import 'package:wafy/features/table_details/presentation/bindings/table_details_binding.dart';
import 'package:wafy/features/table_details/presentation/pages/table_details_page.dart';
import 'package:wafy/features/table_details/presentation/pages/table_invoice_page.dart';
import 'package:wafy/features/table_details/presentation/pages/table_add_items_page.dart';
import 'package:wafy/features/menu/presentation/pages/menu_page.dart';
import 'package:wafy/features/onboarding/presentation/bindings/onboarding_binding.dart';
import 'package:wafy/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:wafy/features/oreder/presentation/bindings/order_details_binding.dart';
import 'package:wafy/features/oreder/presentation/pages/order_details_page.dart';
import 'package:wafy/features/settings/presentation/bindings/settings_binding.dart';
import 'package:wafy/features/settings/presentation/pages/settings_page.dart';
import 'package:wafy/features/splash/presentation/bindings/splash_binding.dart';
import 'package:wafy/features/splash/presentation/pages/splash_page.dart';

class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: Routes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => OnboardingPage(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.menu,
      page: () {
        return MenuPage();
      },
      binding: MenuBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.orderDetails,
      page: () => const OrderDetailsPage(),
      binding: OrderDetailsBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.printOrder,
      page: () => const PrintOrderPage(),
      middlewares: [AuthMiddleware()],
    ),
    // Table details routes
    GetPage(
      name: Routes.tableDetails,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        final tableId = args?['tableId'] as int? ?? 0;
        final tableName = args?['tableName'] as String? ?? '';
        return TableDetailsPage(tableId: tableId, tableName: tableName);
      },
      binding: TableDetailsBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.tableInvoice,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        final tableId = args?['tableId'] as int? ?? 0; 
        final tableName = args?['tableName'] as String? ?? '';
        return TableInvoicePage(tableId: tableId, tableName: tableName);
      },
      binding: TableDetailsBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.tableAddItems,
      page: () => const TableAddItemsPage(),
      binding: TableDetailsBinding(),
      middlewares: [AuthMiddleware()],
    ),
    // Settings route
    GetPage(
      name: Routes.settings,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
