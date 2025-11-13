import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wafy/app/routes/app_routes.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/utils/app_images.dart';
import 'package:wafy/core/utils/font_constants.dart';
import 'package:wafy/features/menu/presentation/controllers/menu_controller.dart';
import 'package:wafy/features/menu/presentation/enums/menu_mode.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool hasLogo;
  final bool isHomeScreen;
  final IconData? icon;
  final VoidCallback? onPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.icon,
    this.onPressed,
    this.hasLogo = false,
    this.isHomeScreen = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray,
            offset: Offset(0, 1),
            spreadRadius: 1,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (hasLogo) Image.asset(AppImages.logoApp, height: 45.h),
          if (icon != null) Icon(icon, color: AppColors.grayDarker),
          SizedBox(width: 20.w),
          Text(
            title,
            style: FontConstants.cairoStyle(
              fontSize: 24.sp,
              weight: FontConstants.cairoBold,
              color: AppColors.primary,
            ),
          ),

          Spacer(),

          if (isHomeScreen)
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.settings);
              },
              icon: Icon(Icons.settings_outlined),
            ),
          if (!isHomeScreen)
            Obx(() {
              // التحقق من وجود FullMenuController قبل استخدامه
              if (Get.isRegistered<FullMenuController>()) {
                final menuController = Get.find<FullMenuController>();
                final menuMode = menuController.menuMode.value;
                if (menuMode == MenuMode.addToTable) {
                  return IconButton(
                    onPressed: onPressed,
                    icon: Icon(Icons.arrow_forward_ios),
                  );
                }
              }
              // إذا لم يكن مسجلاً أو كان menuMode != addToTable، لا نعرض أي شيء
              return SizedBox.shrink();
            }),
        ],
      ),
    );
  }
}
