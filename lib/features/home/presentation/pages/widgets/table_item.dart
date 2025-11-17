import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wafy/app/routes/app_routes.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/utils/app_images.dart';
import 'package:wafy/core/utils/font_constants.dart';
import 'package:wafy/core/utils/number_formatter.dart';
import 'package:wafy/core/widgets/num_text.dart';
import 'package:wafy/features/home/domain/entities/table_entity.dart';

class TableItem extends StatelessWidget {
  final TableEntity table;
  final bool isTablet;

  const TableItem({super.key, required this.table, this.isTablet = false});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: () {
          Get.toNamed(
            Routes.tableDetails,
            arguments: {'tableId': table.id, 'tableName': table.nameAr},
          );
        },
        child: Card(
          color: AppColors.white,
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // صف الحالة والوقت
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: NumText(
                        _getTimeDisplay(),
                        style: FontConstants.poppinsStyle(
                          fontSize: 16.sp,
                          color: AppColors.text,
                          weight: FontConstants.cairoSemiBold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(_getStatusImage()),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                // رقم الطاولة
                Expanded(
                  child: Center(
                    child: NumText(
                      table.nameAr,
                      style: FontConstants.poppinsStyle(
                        fontSize: 20.sp,
                        weight: FontConstants.cairoBold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                // السعر
                Flexible(
                  child: NumText(
                    '${NumberFormatter.formatPrice(table.total)} د.ع',
                    style: FontConstants.poppinsStyle(
                      fontSize: 16.sp,
                      weight: FontConstants.cairoBold,
                      color: AppColors.text,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getStatusImage() {
    switch (table.status) {
      case 1: // متاح (أخضر)
        return AppImages.emptyStateCircle;
      case 3: // منتظر (أصفر)
        return AppImages.waitingPayStateCircle;
      case 2: // مشغول (أحمر)
        return AppImages.workingStateCircle;
      default:
        return AppImages.emptyStateCircle;
    }
  }

  String _getTimeDisplay() {
    switch (table.status) {
      case 1: // متاح (أخضر)
        return "متاح";
      case 3: // منتظر (أصفر)
        return "فاتورة";
      case 2: // مشغول (أحمر)
        return "مشغول";
      default:
        return "متاح";
    }
  }
}
