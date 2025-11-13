import 'package:get/get.dart';
import 'package:wafy/features/menu/domain/usecases/refresh_menu_data.dart';
import 'package:wafy/features/menu/domain/usecases/preload_menu_data.dart';
import 'package:wafy/features/menu/presentation/controllers/menu_controller.dart';
import '../controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    // Use cases - استخدام الـ instances الموجودة من MenuBinding
    Get.lazyPut<RefreshMenuData>(() => RefreshMenuData(Get.find()));
    Get.lazyPut<PreloadMenuData>(() => PreloadMenuData(Get.find()));

    // Controller
    Get.lazyPut<SettingsController>(
      () => SettingsController(
        Get.find<RefreshMenuData>(),
        Get.find<PreloadMenuData>(),
        menuController: Get.isRegistered<FullMenuController>()
            ? Get.find<FullMenuController>()
            : null,
      ),
    );
  }
}

