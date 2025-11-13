import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wafy/features/auth/presentation/controllers/login_controller.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/features/auth/presentation/pages/widgets/company_info_widget.dart';
import 'package:wafy/features/auth/presentation/pages/widgets/form_animation_widget.dart';
import 'package:wafy/features/auth/presentation/pages/widgets/logo_animation_widget.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  // تأثير fade للشعار
                  const LogoAnimationWidget(),
                  SizedBox(height: 0.18.sh),
                  // عرض معلومات الشركة - دائماً مرئي
                  const CompanyInfoWidget(),
                  SizedBox(height: 20.h),
                  // تأثير slide للفورم
                  const FormAnimationWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
