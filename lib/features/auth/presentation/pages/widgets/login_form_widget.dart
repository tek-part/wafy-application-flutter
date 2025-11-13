import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wafy/features/auth/presentation/controllers/login_controller.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/utils/font_constants.dart';
import 'package:wafy/features/auth/presentation/pages/widgets/custom_numeric_keyboard.dart';

class LoginFormWidget extends GetView<LoginController> {
  final String? errorMessage;

  LoginFormWidget({super.key, this.errorMessage});

  final RxBool showKeyboard = false.obs;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          // إخفاء لوحة المفاتيح عند الضغط خارجها
          if (showKeyboard.value) {
            showKeyboard.value = false;
          }
        },
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              TextField(
                controller: controller.passwordController,
                textAlign: TextAlign.center,
                readOnly: true,
                showCursor: true,
                decoration: InputDecoration(
                  hintText: 'قم بادخال كلمة المرور',
                  hintStyle: FontConstants.cairoStyle(
                    color: AppColors.text,
                    fontSize: 12.sp,
                    weight: FontConstants.cairoSemiBold,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: errorMessage != null
                          ? AppColors.error
                          : AppColors.gray,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(color: AppColors.error),
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  suffixIcon: controller.passwordController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: AppColors.primary),
                          onPressed: () {
                            controller.passwordController.clear();
                          },
                        )
                      : null,
                ),
                style: FontConstants.cairoStyle(
                  color: AppColors.primary,
                  fontSize: 16.sp,
                  weight: FontConstants.cairoSemiBold,
                ),
                textDirection: TextDirection.ltr,
                onTap: () {
                  // إخفاء لوحة المفاتيح الافتراضية
                  FocusScope.of(context).unfocus();
                  // إظهار/إخفاء لوحة المفاتيح المخصصة
                  showKeyboard.value = !showKeyboard.value;

                  // التمرير التلقائي لأسفل عند إظهار لوحة المفاتيح
                  if (showKeyboard.value) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (scrollController.hasClients &&
                            scrollController.position.maxScrollExtent > 0) {
                          scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOut,
                          );
                        }
                      });
                    });
                  }
                },
              ),
              // عرض رسالة الخطأ أسفل حقل كلمة المرور
              if (errorMessage != null) ...[
                SizedBox(height: 10.h),
                Text(
                  errorMessage!,
                  style: FontConstants.cairoStyle(
                    color: AppColors.error,
                    fontSize: 12.sp,
                    weight: FontConstants.cairoSemiBold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              SizedBox(height: 20.h),
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     onPressed: controller.login,
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: AppColors.white,
              //       foregroundColor: AppColors.primary,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(16.r),
              //         side: BorderSide(
              //           color: AppColors.primary.withOpacity(0.5),
              //           width: 2,
              //         ),
              //       ),
              //       padding: EdgeInsets.symmetric(vertical: 12.h),
              //     ),
              //     child: Text(
              //       'دخول',
              //       style: FontConstants.cairoStyle(
              //         fontSize: 16.sp,
              //         weight: FontConstants.cairoSemiBold,
              //       ),
              //     ),
              //   ),
              // ),

              // لوحة المفاتيح الرقمية المخصصة
              if (showKeyboard.value) ...[
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () {
                    // منع إغلاق لوحة المفاتيح عند الضغط عليها
                  },
                  child: CustomNumericKeyboard(
                    controller: controller.passwordController,
                    onSubmit: () {
                      showKeyboard.value = false;
                      // إضافة تأخير صغير قبل استدعاء login
                      Future.delayed(const Duration(milliseconds: 100), () {
                        controller.login();
                      });
                    },
                    onClose: () {
                      showKeyboard.value = false;
                    },
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void dispose() {
    scrollController.dispose();
  }
}
