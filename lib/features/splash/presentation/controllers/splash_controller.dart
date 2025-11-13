import 'package:get/get.dart';
import 'package:wafy/app/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.offAllNamed(Routes.login);
    });
  }
}
