import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wafy/core/network/dio_factory.dart';
import 'package:wafy/app/bindings/user_service_binding.dart';
import 'package:wafy/features/menu/presentation/bindings/menu_binding.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core dependencies - يجب أن تكون أولاً
    Get.putAsync<SharedPreferences>(
      () async => await SharedPreferences.getInstance(),
    );

    // Hive box dependencies
    Get.lazyPut<Box>(() => Hive.box('auth'), tag: 'auth');
    Get.lazyPut<Box>(() => Hive.box('menu'), tag: 'menu');

    Get.lazyPut(() => DioFactory.create());

    // إضافة UserServiceBinding هنا بعد تسجيل Dio
    UserServiceBinding().dependencies();

    // إضافة MenuBinding لتسجيل جميع Menu dependencies
    MenuBinding().dependencies();
  }
}
