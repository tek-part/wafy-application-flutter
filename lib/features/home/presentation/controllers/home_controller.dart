import 'package:get/get.dart';
import 'package:wafy/features/home/domain/usecases/get_tables_usecase.dart';
import 'package:wafy/features/home/domain/usecases/get_tables_status_usecase.dart';
import 'package:wafy/features/home/presentation/controllers/floors_controller.dart';
import 'package:wafy/features/home/presentation/controllers/tables_controller.dart';
import 'package:wafy/features/menu/presentation/controllers/menu_controller.dart';
import 'package:wafy/features/menu/presentation/enums/menu_mode.dart';

class HomeController extends GetxController {
  final RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

    // // تسجيل Menu controllers بشكل دائم للاستخدام في IndexedStack
    // Get.put<MenuCategoriesController>(
    //   MenuCategoriesController(Get.find()),
    //   permanent: true,
    // );
    // Get.put<MenuItemsController>(
    //   MenuItemsController(Get.find()),
    //   permanent: true,
    // );
    // Get.put<MenuController>(
    //   MenuController(Get.find(), Get.find()),
    //   permanent: true,
    // );
    // Get.put<AddItemFromMenuController>(
    //   AddItemFromMenuController(),
    //   permanent: true,
    // );

    // تسجيل Home controllers
    Get.put<FloorsController>(FloorsController(Get.find()), permanent: true);
    Get.put<TablesController>(
      TablesController(Get.find<GetTables>(), Get.find<GetTablesStatus>()),
      permanent: true,
    );
  }

  void changeIndex(int index) {
    if (index == 1) {
      if (Get.isRegistered<FullMenuController>()) {
        var controller = Get.find<FullMenuController>();
        controller.setMenuMode(MenuMode.view);
      }
    }
    currentIndex.value = index;
  }

  // الحصول على FloorsController
  FloorsController get floorsController => Get.find<FloorsController>();

  // الحصول على TablesController
  TablesController get tablesController => Get.find<TablesController>();

  @override
  void onClose() {
    // // تنظيف الـ controllers عند إغلاق HomeController
    // if (Get.isRegistered<MenuCategoriesController>()) {
    //   Get.delete<MenuCategoriesController>();
    // }
    // if (Get.isRegistered<MenuItemsController>()) {
    //   Get.delete<MenuItemsController>();
    // }
    // if (Get.isRegistered<MenuController>()) {
    //   Get.delete<MenuController>();
    // }
    // if (Get.isRegistered<AddItemFromMenuController>()) {
    //   Get.delete<AddItemFromMenuController>();
    // }
    if (Get.isRegistered<FloorsController>()) {
      Get.delete<FloorsController>();
    }
    if (Get.isRegistered<TablesController>()) {
      Get.delete<TablesController>();
    }
    super.onClose();
  }
}
