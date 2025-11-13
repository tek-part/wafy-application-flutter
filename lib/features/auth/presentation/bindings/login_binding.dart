import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wafy/core/network/api_client.dart';
import 'package:wafy/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:wafy/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:wafy/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:wafy/features/auth/domain/repositories/auth_repository.dart';
import 'package:wafy/features/auth/domain/usecases/get_all_users.dart';
import 'package:wafy/features/auth/domain/usecases/login.dart';
import 'package:wafy/features/auth/domain/usecases/get_comp_info.dart';
import 'package:wafy/features/auth/presentation/controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Core dependencies - استخدام الـ instances الموجودة
    Get.lazyPut<ApiClient>(() => ApiClient(Get.find()));

    // تأكد من وجود authBox (إذا لم يكن موجوداً، أنشئه)
    if (!Get.isRegistered<Box>(tag: 'auth')) {
      Get.lazyPut<Box>(() => Hive.box('auth'), tag: 'auth');
    }

    // Data sources
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(apiClient: Get.find()),
    );
    Get.lazyPut<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(
        sharedPreferences: Get.find(),
        authBox: Get.find<Box>(tag: 'auth'),
      ),
    );

    // Repository
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: Get.find(),
        localDataSource: Get.find(),
      ),
    );

    // Use cases
    Get.lazyPut<GetAllUsers>(() => GetAllUsers(Get.find()));
    Get.lazyPut<Login>(() => Login(Get.find()));
    Get.lazyPut<GetCompInfo>(() => GetCompInfo(Get.find()));

    // Controller
    Get.lazyPut<LoginController>(
      () => LoginController(Get.find(), Get.find(), Get.find()),
    );
  }
}
