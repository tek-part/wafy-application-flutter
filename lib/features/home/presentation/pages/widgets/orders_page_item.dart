import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/utils/font_constants.dart';
import 'package:wafy/core/utils/number_formatter.dart';
import 'package:wafy/core/widgets/num_text.dart';

class OrdersPageItem extends StatelessWidget {
  final String tableNumber;
  final String orderName;
  final String price;
  final String time;

  const OrdersPageItem({
    super.key,
    required this.tableNumber,
    required this.orderName,
    required this.price,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Text(
                  "رقم الطاوله",
                  style: FontConstants.cairoStyle(
                    weight: FontConstants.cairoSemiBold,
                    fontSize: 12.sp,
                  ),
                ),
                Spacer(),
                NumText(
                  tableNumber,
                  style: FontConstants.poppinsStyle(
                    fontSize: 12.sp,
                    weight: FontConstants.poppinsSemiBold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  "الطلب",
                  style: FontConstants.cairoStyle(
                    weight: FontConstants.cairoMedium,
                    fontSize: 12.sp,
                  ),
                ),
                Spacer(),
                Text(
                  orderName,
                  style: FontConstants.cairoStyle(
                    weight: FontConstants.cairoMedium,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  "السعر",
                  style: FontConstants.cairoStyle(
                    weight: FontConstants.cairoSemiBold,
                    fontSize: 12.sp,
                  ),
                ),
                Spacer(),
                NumText(
                  "${NumberFormatter.formatNumber(double.tryParse(price) ?? 0)} د.ع",
                  style: FontConstants.poppinsStyle(
                    fontSize: 12.sp,
                    weight: FontConstants.poppinsSemiBold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                time,
                style: FontConstants.poppinsStyle(
                  weight: FontConstants.poppinsRegular,
                  fontSize: 12.sp,
                ),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 0.25.sw,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed('/orders/details');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(18.r),
                  ),
                ),
                child: const Text('عرض'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
