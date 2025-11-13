import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/utils/font_constants.dart';

class CategoryMenuButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;
  const CategoryMenuButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    print('CategoryMenuButton - text: $text, isSelected: $isSelected');
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.gray,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          text,
          style: FontConstants.cairoStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            weight: isSelected
                ? FontConstants.cairoBold
                : FontConstants.cairoMedium,
            fontSize: isSelected ? 14.sp : 13.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
