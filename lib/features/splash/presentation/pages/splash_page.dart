import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wafy/core/utils/app_images.dart';
import 'package:wafy/features/splash/presentation/controllers/splash_controller.dart';
import 'package:wafy/core/theme/colors.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // استدعاء controller لتفعيله
    controller;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1000),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: Opacity(
                opacity: value,
                child: Image.asset(
                  AppImages.logoApp,
                  width: 200.w,
                  height: 200.h,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
