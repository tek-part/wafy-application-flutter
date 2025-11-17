import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wafy/features/auth/presentation/controllers/login_controller.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/utils/font_constants.dart';

class CompanyInfoWidget extends GetView<LoginController> {
  const CompanyInfoWidget({super.key});

  // تحويل Base64 string إلى Uint8List للصورة
  Uint8List _base64ToImage(String base64String) {
    try {
      // إزالة data:image prefix إذا كان موجوداً
      if (base64String.contains(',')) {
        base64String = base64String.split(',')[1];
      }
      return base64Decode(base64String);
    } catch (e) {
      // في حالة الخطأ، إرجاع صورة فارغة
      return Uint8List(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final company = controller.companyInfo.value;
      final isLoading = controller.state.maybeWhen(
        loading: () => true,
        orElse: () => false,
      );

      // إخفاء الخطأ إذا كان خطأ شبكة
      final hasError = controller.state.maybeWhen(
        error: (message) => true,
        orElse: () => false,
      );

      return isLoading && company == null && !hasError
          ? SizedBox.shrink()
          : Column(
              children: [
                // شعار الشركة
                Container(
                  width: 180.w,
                  height: 180.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(90.r),
                  ),
                  child: isLoading && company == null
                      ? Center(
                          child: SizedBox(
                            width: 30.w,
                            height: 30.h,
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : company != null && company.loGo.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(40.r),
                          child: Image.memory(
                            _base64ToImage(company.loGo),
                            width: 80.w,
                            height: 80.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.business,
                                size: 40.sp,
                                color: AppColors.primary,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.business,
                          size: 40.sp,
                          color: AppColors.primary,
                        ),
                ),
                SizedBox(height: 10.h),
                // اسم الشركة
                Text(
                  company?.companyNameAr ?? 'اسم الشركة',
                  style: FontConstants.cairoStyle(
                    color: AppColors.white,
                    fontSize: 16.sp,
                    weight: FontConstants.cairoSemiBold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
    });
  }
}
