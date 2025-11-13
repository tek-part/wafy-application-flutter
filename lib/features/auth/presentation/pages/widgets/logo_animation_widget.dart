import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/utils/app_images.dart';

class LogoAnimationWidget extends StatelessWidget {
  const LogoAnimationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: 0.9 + (0.1 * value),
            child: Opacity(
              opacity: value,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(60.r),
                ),
                padding: EdgeInsets.all(10.w),
                child: Image.asset(
                  AppImages.logoApp,
                  width: 40.w,
                  height: 40.h,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
