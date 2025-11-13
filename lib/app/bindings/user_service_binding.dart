import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wafy/core/network/api_client.dart';
import 'package:wafy/core/services/user_service.dart';
import 'package:wafy/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:wafy/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:wafy/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:wafy/features/auth/domain/repositories/auth_repository.dart';
import 'package:wafy/features/auth/domain/usecases/get_current_user.dart';

class UserServiceBinding extends Bindings {
  @override
  void dependencies() {
    // SHARED

    // ApiClient - instance للـ baseUrl
    Get.lazyPut<ApiClient>(() => ApiClient(Get.find()));

    // ApiClient - instance للـ baseUrl2 (للـ invoice endpoints)
    Get.lazyPut<ApiClient>(() => ApiClient(Get.find()), tag: 'invoice');
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

    // Auth Repository للـ UserService
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: Get.find(),
        localDataSource: Get.find(),
      ),
      fenix: true, // يبقى في الذاكرة
    );

    // GetCurrentUser use case
    Get.lazyPut<GetCurrentUser>(() => GetCurrentUser(Get.find()), fenix: true);

    // UserService - يجب أن يكون permanent
    Get.put<UserService>(
      UserService(Get.find()),
      permanent: true, // لا يتم حذفه أبداً
    );
  }
}
