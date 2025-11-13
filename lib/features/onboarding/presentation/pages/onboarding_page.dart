import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wafy/core/utils/app_images.dart';
import 'package:wafy/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/utils/font_constants.dart';

class OnboardingPage extends GetView<OnboardingController> {
  List<String> images = [
    AppImages.onboarding1,
    AppImages.onboarding2,
    AppImages.onboarding3,
  ];
  OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Obx(() {
            return Image.asset(
              images[controller.currentPage.value],
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            );
          }),
          Column(
            children: [
              Expanded(
                child: Center(
                  child: SizedBox(
                    height: 350.h,
                    child: PageView.builder(
                      controller: controller.pageController,
                      onPageChanged: controller.onPageChanged,
                      itemCount: controller.pages.length,
                      itemBuilder: (context, index) {
                        return _buildPage(controller.pages[index], index);
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              Obx(() {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 25.h,
                      height: 25.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: AlignmentGeometry.topCenter,
                          end: AlignmentGeometry.bottomCenter,

                          colors: [
                            AppColors.gray,
                            controller.currentPage.value == 0
                                ? AppColors.primary
                                : AppColors.gray,
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 45.w),
                    Container(
                      width: 25.h,
                      height: 25.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: AlignmentGeometry.topCenter,
                          end: AlignmentGeometry.bottomCenter,

                          colors: [
                            AppColors.gray,
                            controller.currentPage.value == 1
                                ? AppColors.primary
                                : AppColors.gray,
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 45.w),
                    Container(
                      width: 25.h,
                      height: 25.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        gradient: LinearGradient(
                          begin: AlignmentGeometry.topCenter,
                          end: AlignmentGeometry.bottomCenter,

                          colors: [
                            AppColors.gray,
                            controller.currentPage.value == 2
                                ? AppColors.primary
                                : AppColors.gray,
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
              SizedBox(height: 40.h),

              SizedBox(
                width: 0.9.sw,
                child: ElevatedButton(
                  onPressed: controller.nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 16.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Obx(() {
                    return Text(
                      controller.currentPage.value ==
                              controller.pages.length - 1
                          ? 'ابدأ الآن'
                          : 'التالي',
                      style: FontConstants.cairoStyle(
                        fontSize: 18.sp,
                        weight: FontConstants.cairoSemiBold,
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPage(Map<String, dynamic> page, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColors.background.withValues(alpha: 0.15),
      ),
      padding: EdgeInsets.all(16.0.w),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            page['title'],
            style: FontConstants.cairoStyle(
              fontSize: 18.sp,
              weight: FontConstants.cairoBold,
              color: AppColors.secondaryText,
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 20.h),
          Text(
            page['description'],
            style: FontConstants.cairoStyle(
              fontSize: 16.sp,
              color: AppColors.white,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
