import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wafy/core/network/api_client.dart';
import 'package:wafy/features/home/data/datasources/home_remote_datasource.dart';
import 'package:wafy/features/home/data/repositories/home_repository_impl.dart';
import 'package:wafy/features/home/domain/repositories/home_repository.dart';
import 'package:wafy/features/home/domain/usecases/get_floors_usecase.dart';
import 'package:wafy/features/home/domain/usecases/get_tables_usecase.dart';
import 'package:wafy/features/home/domain/usecases/get_tables_status_usecase.dart';
import 'package:wafy/features/home/presentation/controllers/home_controller.dart';
import 'package:wafy/features/home/presentation/controllers/floors_controller.dart';
import 'package:wafy/features/home/presentation/controllers/tables_controller.dart';
import 'package:wafy/features/menu/data/datasources/menu_local_data_source.dart';
import 'package:wafy/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:wafy/features/menu/data/repositories/menu_repository_impl.dart';
import 'package:wafy/features/menu/domain/repositories/menu_repository.dart';
import 'package:wafy/features/menu/domain/usecases/get_menu_categories.dart';
import 'package:wafy/features/menu/domain/usecases/get_menu_items.dart';
import 'package:wafy/features/menu/domain/usecases/preload_menu_data.dart';
import 'package:wafy/features/menu/presentation/controllers/menu_categories_controller.dart';
import 'package:wafy/features/menu/presentation/controllers/menu_controller.dart';
import 'package:wafy/features/menu/presentation/controllers/menu_items_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Data Sources
    Get.lazyPut<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
    );

    // Repositories
    Get.lazyPut<HomeRepository>(
      () => HomeRepositoryImpl(
        remoteDataSource: Get.find<HomeRemoteDataSource>(),
      ),
    );

    // Use Cases
    Get.lazyPut<GetFloors>(() => GetFloors(Get.find<HomeRepository>()));
    Get.lazyPut<GetTables>(() => GetTables(Get.find<HomeRepository>()));
    Get.lazyPut<GetTablesStatus>(
      () => GetTablesStatus(Get.find<HomeRepository>()),
    );

    // Controllers
    Get.lazyPut<HomeController>(() => HomeController());
    // تسجيل FloorsController و TablesController بشكل permanent لضمان توافرهما
    Get.put<FloorsController>(
      FloorsController(Get.find<GetFloors>()),
      permanent: true,
    );
    Get.put<TablesController>(
      TablesController(Get.find<GetTables>(), Get.find<GetTablesStatus>()),
      permanent: true,
    );

    // تسجيل FullMenuController بشكل permanent إذا لم يكن مسجلاً
    // هذا يضمن توافره في جميع الصفحات
    if (!Get.isRegistered<FullMenuController>()) {
      // تسجيل Menu dependencies إذا لم تكن مسجلة
      if (!Get.isRegistered<Box>(tag: 'menu')) {
        Get.lazyPut<Box>(() => Hive.box('menu'), tag: 'menu');
      }
      if (!Get.isRegistered<MenuRemoteDataSource>()) {
        Get.lazyPut<MenuRemoteDataSource>(
          () => MenuRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
        );
      }
      if (!Get.isRegistered<MenuLocalDataSource>()) {
        Get.lazyPut<MenuLocalDataSource>(
          () => MenuLocalDataSourceImpl(
            sharedPreferences: Get.find(),
            menuBox: Get.find<Box>(tag: 'menu'),
          ),
        );
      }
      if (!Get.isRegistered<MenuRepository>()) {
        Get.lazyPut<MenuRepository>(
          () => MenuRepositoryImpl(
            remoteDataSource: Get.find<MenuRemoteDataSource>(),
            localDataSource: Get.find<MenuLocalDataSource>(),
          ),
        );
      }
      if (!Get.isRegistered<GetMenuCategories>()) {
        Get.lazyPut<GetMenuCategories>(
          () => GetMenuCategories(Get.find<MenuRepository>()),
        );
      }
      if (!Get.isRegistered<GetMenuItems>()) {
        Get.lazyPut<GetMenuItems>(
          () => GetMenuItems(Get.find<MenuRepository>()),
        );
      }
      if (!Get.isRegistered<PreloadMenuData>()) {
        Get.lazyPut<PreloadMenuData>(
          () => PreloadMenuData(Get.find<MenuRepository>()),
        );
      }
      if (!Get.isRegistered<MenuCategoriesController>()) {
        Get.lazyPut<MenuCategoriesController>(
          () => MenuCategoriesController(Get.find<GetMenuCategories>()),
        );
      }
      if (!Get.isRegistered<MenuItemsController>()) {
        Get.lazyPut<MenuItemsController>(
          () => MenuItemsController(Get.find<GetMenuItems>()),
        );
      }
      // تسجيل FullMenuController بشكل permanent
      Get.put<FullMenuController>(
        FullMenuController(
          Get.find<MenuCategoriesController>(),
          Get.find<MenuItemsController>(),
          preloadMenuData: Get.find<PreloadMenuData>(),
          menuRepository: Get.find<MenuRepository>(),
        ),
        permanent: true,
      );
    }
  }
}
