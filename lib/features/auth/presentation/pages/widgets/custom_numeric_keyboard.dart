import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/utils/font_constants.dart';

class CustomNumericKeyboard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final VoidCallback? onClose;

  const CustomNumericKeyboard({
    super.key,
    required this.controller,
    required this.onSubmit,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // لوحة المفاتيح الرقمية
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
            ),
            itemCount: 12, // 0-9 + حذف + إخفاء
            itemBuilder: (context, index) {
              if (index == 9) {
                // زر الحذف
                return _buildActionButton(
                  icon: Icons.backspace,
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      controller.text = controller.text.substring(
                        0,
                        controller.text.length - 1,
                      );
                    }
                  },
                  color: AppColors.error,
                );
              } else if (index == 10) {
                // الرقم 0
                return _buildNumberButton('0');
              } else if (index == 11) {
                // زر الإخفاء
                return _buildActionButton(
                  icon: Icons.close,
                  onPressed: () {
                    onClose?.call();
                  },
                  color: AppColors.gray,
                );
              } else {
                // الأرقام 1-9
                return _buildNumberButton('${index + 1}');
              }
            },
          ),

          SizedBox(height: 20.h),

          // زر الإدخال
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                onSubmit();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.h),
              ),
              child: Text(
                'دخول',
                style: FontConstants.cairoStyle(
                  fontSize: 16.sp,
                  weight: FontConstants.cairoSemiBold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return ElevatedButton(
      onPressed: () {
        controller.text += number;
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
        ),
      ),
      child: Text(
        number,
        style: FontConstants.cairoStyle(
          fontSize: 24.sp,
          weight: FontConstants.cairoSemiBold,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AppColors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Icon(icon, size: 24.sp),
    );
  }
}
