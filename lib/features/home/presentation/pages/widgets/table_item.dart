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

  const TableItem({super.key, required this.table});

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
            padding: EdgeInsets.all(8.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NumText(
                      _getTimeDisplay(),
                      style: FontConstants.poppinsStyle(
                        fontSize: 12.sp,
                        color: AppColors.text,
                        weight: FontConstants.poppinsBold,
                      ),
                    ),
                    Container(
                      width: 20.h,
                      height: 20.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(_getStatusImage()),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                NumText(
                  table.nameAr,
                  style: FontConstants.poppinsStyle(
                    fontSize: 24.sp,
                    weight: FontConstants.poppinsBold,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: NumText(
                        '${NumberFormatter.formatPrice(table.total)} د.ع',
                        style: FontConstants.poppinsStyle(
                          fontSize: 10.sp,
                          weight: FontConstants.poppinsBold,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ],
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
      case 0: // متاح (أخضر)
        return AppImages.emptyStateCircle;
      case 2: // منتظر (أصفر)
        return AppImages.waitingPayStateCircle;
      case 1: // مشغول (أحمر)
        return AppImages.workingStateCircle;
      default:
        return AppImages.emptyStateCircle;
    }
  }

  String _getTimeDisplay() {
    switch (table.status) {
      case 0: // متاح (أخضر)
        return "متاح";
      case 2: // منتظر (أصفر)
        return "منتظر";
      case 1: // مشغول (أحمر)
        return "مشغول";
      default:
        return "متاح";
    }
  }
}
