import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wafy/core/network/api_client.dart';
import 'package:wafy/features/menu/data/datasources/menu_local_data_source.dart';
import 'package:wafy/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:wafy/features/menu/data/repositories/menu_repository_impl.dart';
import 'package:wafy/features/menu/domain/repositories/menu_repository.dart';
import 'package:wafy/features/menu/domain/usecases/get_menu_categories.dart';
import 'package:wafy/features/menu/domain/usecases/get_menu_items.dart';
import 'package:wafy/features/menu/domain/usecases/get_item_sizes.dart';
import 'package:wafy/features/menu/domain/usecases/preload_menu_data.dart';
import 'package:wafy/features/menu/domain/usecases/refresh_menu_data.dart';
import 'package:wafy/features/menu/presentation/controllers/add_item_from_menu_controller.dart';
import 'package:wafy/features/menu/presentation/controllers/menu_categories_controller.dart';
import 'package:wafy/features/menu/presentation/controllers/menu_controller.dart';
import 'package:wafy/features/menu/presentation/controllers/menu_items_controller.dart';

class MenuBinding extends Bindings {
  @override
  void dependencies() {
    // Core dependencies - استخدام الـ instances الموجودة
    Get.lazyPut<ApiClient>(() => ApiClient(Get.find()));

    // تأكد من وجود menuBox (إذا لم يكن موجوداً، أنشئه)
    if (!Get.isRegistered<Box>(tag: 'menu')) {
      Get.lazyPut<Box>(() => Hive.box('menu'), tag: 'menu');
    }

    // Data sources
    Get.lazyPut<MenuRemoteDataSource>(
      () => MenuRemoteDataSourceImpl(apiClient: Get.find()),
    );
    Get.lazyPut<MenuLocalDataSource>(
      () => MenuLocalDataSourceImpl(
        sharedPreferences: Get.find(),
        menuBox: Get.find<Box>(tag: 'menu'),
      ),
    );

    // Repository
    Get.lazyPut<MenuRepository>(
      () => MenuRepositoryImpl(
        remoteDataSource: Get.find(),
        localDataSource: Get.find(),
      ),
    );

    // Use cases
    Get.lazyPut<GetMenuCategories>(() => GetMenuCategories(Get.find()));
    Get.lazyPut<GetMenuItems>(() => GetMenuItems(Get.find()));
    Get.lazyPut<GetItemSizes>(() => GetItemSizes(Get.find()));
    Get.lazyPut<PreloadMenuData>(() => PreloadMenuData(Get.find()));
    Get.lazyPut<RefreshMenuData>(() => RefreshMenuData(Get.find()));

    // Controllers
    Get.lazyPut<MenuCategoriesController>(
      () => MenuCategoriesController(Get.find()),
    );
    Get.lazyPut<MenuItemsController>(() => MenuItemsController(Get.find()));
    Get.lazyPut<FullMenuController>(
      () => FullMenuController(
        Get.find(),
        Get.find(),
        preloadMenuData: Get.find<PreloadMenuData>(),
        menuRepository: Get.find<MenuRepository>(),
      ),
    );
    Get.lazyPut<AddItemFromMenuController>(
      () => AddItemFromMenuController(Get.find<GetItemSizes>()),
    );
  }
}
