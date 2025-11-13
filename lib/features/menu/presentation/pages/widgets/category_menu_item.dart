import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/utils/custom_icons_data_type_icons.dart';
import 'package:wafy/core/utils/font_constants.dart';
import 'package:wafy/core/utils/number_formatter.dart';
import 'package:wafy/features/menu/domain/entities/menu_item.dart';

class CategoryMenuItem extends StatelessWidget {
  final MenuItem menuItem;
  final bool showAddButton;
  final VoidCallback onAdd;
  final VoidCallback onTap;
  const CategoryMenuItem({
    super.key,
    required this.menuItem,
    required this.onAdd,
    this.showAddButton = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showAddButton ? onAdd : onTap,
      child: Card(
        color: AppColors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: Center(
                  child:
                      (menuItem.itemImage == null ||
                              menuItem.itemImage!.isEmpty)
                      ? Text(
                          menuItem.nameAr,
                          style: FontConstants.cairoStyle(
                            fontSize: 18.sp,
                            weight: FontConstants.cairoBold,
                            color: AppColors.grayDarker,
                          ),
                          textAlign: TextAlign.center,
                        )
                      : CachedNetworkImage(
                          imageUrl: menuItem.itemImage!,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Center(
                            child: Text(
                              menuItem.nameAr,
                              style: FontConstants.cairoStyle(
                                fontSize: 18.sp,
                                weight: FontConstants.cairoBold,
                                color: AppColors.grayDarker,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                ),
              ),

              SizedBox(height: 10.h),

              Expanded(
                flex: 3,
                child: (showAddButton)
                    ? IntrinsicWidth(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(
                              child: Text(
                                "${NumberFormatter.formatPrice(menuItem.price)} د.ع",
                                style: FontConstants.poppinsStyle(
                                  fontSize: 10.sp,
                                  weight: FontConstants.poppinsBold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),

                            GestureDetector(
                              onTap: onAdd,
                              child: Icon(
                                CustomIconsDataType.category_item_add_icon,
                                size: 24.sp,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        //                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              menuItem.nameAr,
                              style: FontConstants.poppinsStyle(
                                fontSize: 12.sp,
                                weight: FontConstants.poppinsBold,
                                color: AppColors.primary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Text(
                              "${NumberFormatter.formatPrice(menuItem.price)} د.ع ",
                              style: FontConstants.poppinsStyle(
                                fontSize: 12.sp,
                                weight: FontConstants.poppinsBold,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}
