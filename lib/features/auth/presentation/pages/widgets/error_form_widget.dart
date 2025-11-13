import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wafy/features/auth/presentation/controllers/login_controller.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/utils/font_constants.dart';

class ErrorFormWidget extends GetView<LoginController> {
  final String message;

  const ErrorFormWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.error_outline, size: 60.sp, color: AppColors.error),
        SizedBox(height: 10.h),
        Text(
          message,
          style: FontConstants.cairoStyle(
            color: AppColors.error,
            fontSize: 14.sp,
            weight: FontConstants.cairoSemiBold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.refreshData, // Retry loading data
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
            child: Text(
              'إعادة المحاولة',
              style: FontConstants.cairoStyle(
                fontSize: 16.sp,
                weight: FontConstants.cairoSemiBold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
