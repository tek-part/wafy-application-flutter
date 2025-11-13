import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/widgets/num_text.dart';
import 'package:wafy/core/utils/font_constants.dart';

class PrintOrderPage extends StatelessWidget {
  const PrintOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'طباعة الطلب',
          style: FontConstants.cairoStyle(
            fontSize: 18.sp,
            weight: FontConstants.cairoSemiBold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.text,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Text(
              'المطلوب',
              style: FontConstants.cairoStyle(
                fontSize: 18.sp,
                weight: FontConstants.cairoBold,
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(bottom: 8.h),
                    child: ListTile(
                      leading: NumText('${index + 1}'),
                      title: Text(_getItemName(index)),
                      trailing: const NumText('40 د.ع'),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.snackbar('نجح', 'تم إرسال الطلب للطباعة');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                child: Text(
                  'طباعة الطلب',
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

  String _getItemName(int index) {
    final items = ['بيتزا', 'برجر', 'شورما', 'بيتزا', 'المنتج', 'المنتج'];
    return items[index % items.length];
  }
}
