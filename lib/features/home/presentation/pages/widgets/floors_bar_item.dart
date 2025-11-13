import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/utils/font_constants.dart';
import 'package:wafy/core/utils/string_extensions.dart';
import 'package:wafy/features/home/domain/entities/floor_entity.dart';

class FloorsBarItem extends StatelessWidget {
  final FloorEntity floor;
  final bool isSelected;
  final VoidCallback onTap;

  const FloorsBarItem({
    super.key,
    required this.floor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2.r,
              offset: Offset(0, 1.h),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              floor.nameAr.cleanFloorName(),
              style: FontConstants.cairoStyle(
                fontSize: 12.sp,
                weight: FontConstants.cairoMedium,
                color: isSelected ? AppColors.white : AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
