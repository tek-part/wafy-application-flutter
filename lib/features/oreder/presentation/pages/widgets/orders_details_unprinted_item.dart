import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/utils/font_constants.dart';
import 'package:wafy/core/utils/number_formatter.dart';

class OrdersDetailsUnprintedItem extends StatelessWidget {
  final String orderName;
  final String count;
  final String price;
  const OrdersDetailsUnprintedItem({
    super.key,
    required this.orderName,
    required this.count,
    required this.price,
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
                  orderName,
                  style: FontConstants.cairoStyle(
                    fontSize: 16.sp,
                    weight: FontConstants.cairoBold,
                  ),
                ),
                Text(
                  count,
                  style: FontConstants.poppinsStyle(
                    fontSize: 16.sp,
                    weight: FontConstants.poppinsBold,
                  ),
                ),
              ],
            ),
            Text(
              "${NumberFormatter.formatNumber(double.tryParse(price) ?? 0)} د.ع",
              style: FontConstants.poppinsStyle(
                fontSize: 16.sp,
                weight: FontConstants.poppinsBold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
