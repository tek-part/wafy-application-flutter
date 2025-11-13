import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/widgets/num_text.dart';
import 'package:wafy/core/utils/font_constants.dart';

class TableAddItemsPage extends StatelessWidget {
  const TableAddItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إضافة عناصر',
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
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    Text(
                      'برجر',
                      style: FontConstants.cairoStyle(
                        fontSize: 20.sp,
                        weight: FontConstants.cairoBold,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSizeButton('S', true),
                        _buildSizeButton('M', false),
                        _buildSizeButton('L', false),
                        _buildSizeButton('XL', false),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32.w,
                              height: 32.h,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            const NumText('1'),
                            SizedBox(width: 8.w),
                            Container(
                              width: 32.w,
                              height: 32.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.remove,
                                color: Colors.grey,
                                size: 20.sp,
                              ),
                            ),
                          ],
                        ),
                        const NumText('40 د.ع'),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      width: double.infinity,
                      height: 100.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Text(
                          'الوصف',
                          style: FontConstants.cairoStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.snackbar('نجح', 'تم إضافة العنصر');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: Text(
                          'إضافة',
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeButton(String size, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.grey[200],
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        size,
        style: FontConstants.poppinsStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
          weight: FontConstants.poppinsMedium,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}

