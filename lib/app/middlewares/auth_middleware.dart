import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wafy/app/routes/app_routes.dart';
import 'package:wafy/core/services/user_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final userService = Get.find<UserService>();

    if (!userService.isLoggedIn) {
      return const RouteSettings(name: Routes.login);
    }

    return null;
  }
}
