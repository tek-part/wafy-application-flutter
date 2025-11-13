import 'package:get/get.dart';
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
    Get.lazyPut<FloorsController>(
      () => FloorsController(Get.find<GetFloors>()),
    );
    Get.lazyPut<TablesController>(
      () =>
          TablesController(Get.find<GetTables>(), Get.find<GetTablesStatus>()),
    );
  }
}
