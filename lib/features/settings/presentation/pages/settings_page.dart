import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/utils/font_constants.dart';
import 'package:wafy/features/home/presentation/pages/widgets/custom_app_bar.dart';
import '../controllers/settings_controller.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              CustomAppBar(
                title: 'الإعدادات',
                showBackButton: true,
                onPressed: () {
                  Get.back();
                },
              ),
              SizedBox(height: 32.h),
              // زر حذف البيانات المحلية وإعادة تحميلها
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isReloading.value
                        ? null
                        : () {
                            controller.clearAndReloadMenuData();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      disabledBackgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: controller.isReloading.value
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'جاري إعادة التحميل...',
                                style: FontConstants.cairoStyle(
                                  fontSize: 16.sp,
                                  weight: FontConstants.cairoMedium,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.refresh, size: 24.sp),
                              SizedBox(width: 12.w),
                              Text(
                                'حذف البيانات المحلية وإعادة تحميلها',
                                style: FontConstants.cairoStyle(
                                  fontSize: 16.sp,
                                  weight: FontConstants.cairoMedium,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              // معلومات إضافية
              Card(
                color: AppColors.white,
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'معلومات',
                        style: FontConstants.cairoStyle(
                          fontSize: 18.sp,
                          weight: FontConstants.cairoBold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'سيتم حذف جميع البيانات المحلية (الفئات، العناصر، والمقاسات) وإعادة تحميلها من الخادم.',
                        style: FontConstants.cairoStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
