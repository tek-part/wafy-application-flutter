import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/utils/font_constants.dart';
import 'package:wafy/features/menu/domain/entities/menu_item.dart';

class MenuItemDetailsDialog extends StatelessWidget {
  final MenuItem menuItem;

  const MenuItemDetailsDialog({
    super.key,
    required this.menuItem,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = menuItem.itemImage != null &&
        menuItem.itemImage!.isNotEmpty;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      backgroundColor: AppColors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image or Name
              Container(
                width: double.infinity,
                height: 250.h,
                decoration: BoxDecoration(
                  color: AppColors.gray,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: hasImage
                      ? CachedNetworkImage(
                          imageUrl: menuItem.itemImage!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                          errorWidget: (context, url, error) => Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported,
                                  size: 48.sp,
                                  color: AppColors.grayDarker,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  menuItem.nameAr,
                                  style: FontConstants.cairoStyle(
                                    fontSize: 18.sp,
                                    weight: FontConstants.cairoBold,
                                    color: AppColors.grayDarker,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            menuItem.nameAr,
                            style: FontConstants.cairoStyle(
                              fontSize: 24.sp,
                              weight: FontConstants.cairoBold,
                              color: AppColors.grayDarker,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 24.h),

              // Description
              if (menuItem.description.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.gray,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    menuItem.description,
                    style: FontConstants.cairoStyle(
                      fontSize: 14.sp,
                      weight: FontConstants.cairoRegular,
                      color: AppColors.text,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),

              SizedBox(height: 24.h),

              // Close Button
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'إغلاق',
                    style: FontConstants.cairoStyle(
                      fontSize: 16.sp,
                      weight: FontConstants.cairoBold,
                      color: AppColors.white,
                    ),
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





