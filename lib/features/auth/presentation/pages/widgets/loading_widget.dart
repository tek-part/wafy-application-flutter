import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wafy/features/auth/presentation/controllers/login_controller.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/utils/font_constants.dart';

class LoadingWidget extends GetView<LoginController> {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircularProgressIndicator(color: AppColors.white),
        SizedBox(height: 20.h),
        Text(
          controller.passwordController.text.isEmpty
              ? 'جاري تحميل البيانات...'
              : 'جاري تسجيل الدخول...',
          style: FontConstants.cairoStyle(
            color: AppColors.white,
            fontSize: 14.sp,
            weight: FontConstants.cairoSemiBold,
          ),
        ),
      ],
    );
  }
}
