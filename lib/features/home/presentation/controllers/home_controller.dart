import 'package:get/get.dart';
import 'package:wafy/features/home/presentation/controllers/floors_controller.dart';
import 'package:wafy/features/home/presentation/controllers/tables_controller.dart';
import 'package:wafy/features/menu/presentation/controllers/menu_controller.dart';
import 'package:wafy/features/menu/presentation/enums/menu_mode.dart';

class HomeController extends GetxController {
  final RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // FloorsController و TablesController يتم تسجيلهما في HomeBinding
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
    // FloorsController و TablesController مسجلة بشكل permanent في HomeBinding
    // ولا يجب حذفها هنا
    super.onClose();
  }
}
