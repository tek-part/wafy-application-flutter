import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/utils/font_constants.dart';
import 'package:wafy/core/utils/number_formatter.dart';

class OrdersDetailsPrintedItem extends StatelessWidget {
  final String orderName;
  final String price;
  final String time;
  final VoidCallback onPressed;
  const OrdersDetailsPrintedItem({
    super.key,
    required this.orderName,
    required this.price,
    required this.time,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          spacing: 10.h,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "الطلب",
                  style: FontConstants.cairoStyle(
                    fontSize: 16.sp,
                    weight: FontConstants.cairoSemiBold,
                  ),
                ),
                Text(
                  orderName,
                  style: FontConstants.cairoStyle(
                    fontSize: 16.sp,
                    weight: FontConstants.cairoMedium,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "السعر",
                  style: FontConstants.cairoStyle(
                    fontSize: 16.sp,
                    weight: FontConstants.cairoSemiBold,
                  ),
                ),
                Text(
                  "${NumberFormatter.formatNumber(double.tryParse(price) ?? 0)} د.ع",
                  style: FontConstants.poppinsStyle(
                    fontSize: 16.sp,
                    weight: FontConstants.poppinsMedium,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "وقت الطباعة",
                  style: FontConstants.cairoStyle(
                    fontSize: 16.sp,
                    weight: FontConstants.cairoSemiBold,
                  ),
                ),
                Text(
                  time,
                  style: FontConstants.poppinsStyle(
                    fontSize: 16.sp,
                    weight: FontConstants.poppinsMedium,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 0.25.sw,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                onPressed: onPressed,
                child: Text(
                  "عرض",
                  style: FontConstants.cairoStyle(
                    fontSize: 16.sp,
                    weight: FontConstants.cairoSemiBold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
